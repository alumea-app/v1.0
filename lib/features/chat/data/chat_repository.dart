import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:alumea/features/chat/domain/chat_message.dart';
import 'package:alumea/features/chat/domain/chat_session.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ChatRepository(this.firestore, this.auth);

  String? get userId => auth.currentUser?.uid;

  Future<String> getOrCreateSessionId() async {
    if (userId == null) throw Exception('No user');
    final sessionsRef =
        firestore.collection('users').doc(userId).collection('chat_sessions');
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final query = await sessionsRef
        .where('startedAt',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .orderBy('startedAt', descending: true)
        .limit(1)
        .get();
    if (query.docs.isNotEmpty) {
      return query.docs.first.id;
    } else {
      final doc =
          await sessionsRef.add({'startedAt': Timestamp.fromDate(today)});
      return doc.id;
    }
  }

  Future<void> saveMessageToHistory(ChatMessage message,
      {String? sessionId}) async {
    if (userId == null) return;
    final sid = sessionId ?? await getOrCreateSessionId();
    await firestore
        .collection('users')
        .doc(userId)
        .collection('chat_sessions')
        .doc(sid)
        .collection('messages')
        .add({
      'text': message.text,
      'sender': message.sender.name,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<DocumentReference> createPrompt(String text) {
    return firestore.collection('conversations').add({'prompt': text});
  }

  Stream<String?> getResponseStream(DocumentReference docRef) {
    return docRef.snapshots().map((snapshot) {
      if (!snapshot.exists) return null;
      final data = snapshot.data() as Map<String, dynamic>?;
      return data?['response'] as String?;
    });
  }

  /// Returns a stream of all messages for the current user's sessions, grouped by session.
  Stream<Map<ChatSession, List<ChatMessage>>> getSessionChatHistoryStream() {
    if (userId == null) return Stream.value({});
    final sessionsRef = firestore
        .collection('users')
        .doc(userId)
        .collection('chat_sessions')
        .orderBy('startedAt', descending: true);
    return sessionsRef.snapshots().switchMap((sessionSnapshot) {
      if (sessionSnapshot.docs.isEmpty) return Stream.value({});
      final sessionStreams = sessionSnapshot.docs.map((sessionDoc) {
        final session = ChatSession.fromFirestore(sessionDoc);
        final messagesRef = sessionDoc.reference
            .collection('messages')
            .orderBy('timestamp', descending: false);
        return messagesRef.snapshots().map((messagesSnapshot) {
          final messages = messagesSnapshot.docs.map((doc) {
            final data = doc.data();
            return ChatMessage(
              text: data['text'],
              sender: data['sender'] == 'lumi' ? Sender.lumi : Sender.user,
            );
          }).toList();
          return MapEntry(session, messages);
        });
      }).toList();
      return Rx.combineLatestList(sessionStreams).map((entries) {
        return Map.fromEntries(entries);
      });
    });
  }
}

// --- Providers ---
final firestoreProvider =
    Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);
final firebaseAuthProvider =
    Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);
final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepository(
    ref.watch(firestoreProvider),
    ref.watch(firebaseAuthProvider),
  );
});

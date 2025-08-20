import 'dart:async';
import 'package:alumea/features/chat/domain/chat_message.dart';
import 'package:alumea/features/check-in/data/check_in_repository.dart';
import 'package:alumea/features/check-in/domain/check_in_model.dart';
import 'package:alumea/features/journey/domain/journey_entry.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';

final journeyRepositoryProvider = Provider<JourneyRepository>((ref) {
  return JourneyRepository(
    firestore: ref.watch(firestoreProvider),
    auth: ref.watch(authProvider),
  );
});

class JourneyRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  JourneyRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  })  : _firestore = firestore,
        _auth = auth;
  
  String? get _userId => _auth.currentUser?.uid;

  Stream<List<JourneyEntry>> getJourneyStream() {
    if (_userId == null) return Stream.value([]);

    // 1. Get streams from all the collections we care about.
    final checkInsStream = _firestore
        .collection('users')
        .doc(_userId)
        .collection('check_ins')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => CheckInModel.fromFirestore(doc)).toList());
    
    final chatHistoryStream = _firestore
        .collection('users').doc(_userId).collection('chat_history')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
            final data = doc.data();
            return ChatMessage(
              text: data['text'],
              sender: data['sender'] == 'lumi' ? Sender.lumi : Sender.user,
              timestamp: (data['timestamp'] as Timestamp?)?.toDate(),
            );
        }).toList());

    // 2. Combine the streams into a single stream of JourneyEntry objects.
     return Rx.combineLatest2(checkInsStream, chatHistoryStream, 
      (List<CheckInModel> checkIns, List<ChatMessage> chatMessages) {
        final allEntries = <JourneyEntry>[];

        // --- Process Check-ins (same as before) ---
        allEntries.addAll(checkIns.map((checkIn) => CheckInJourneyEntry(checkInData: checkIn)));

        // --- NEW: Process Chat Messages ---
        // Group all chat messages by the day they were created
        final groupedChats = groupBy(chatMessages, (ChatMessage msg) {
          final date = msg.timestamp!;
          return DateTime(date.year, date.month, date.day);
        });

        // Create a single ConversationJourneyEntry for each day
        groupedChats.forEach((date, messages) {
  if (messages.isNotEmpty) {
    allEntries.add(ConversationJourneyEntry(
      // Pass the FULL list of messages, not just a snippet
      messages: messages, 
      timestamp: date,
    ));
  }
});
        
        // 4. Sort the combined list by timestamp
        allEntries.sort((a, b) => b.timestamp.compareTo(a.timestamp));
        return allEntries;
    });
  }
}
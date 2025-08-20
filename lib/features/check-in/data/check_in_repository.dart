import 'package:alumea/features/check-in/domain/check_in_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firestoreProvider = Provider((_) => FirebaseFirestore.instance);
final authProvider = Provider((_) => FirebaseAuth.instance);

final checkInRepositoryProvider = Provider<CheckInRepository>((ref) {
  return CheckInRepository(
    ref.watch(firestoreProvider),
    ref.watch(authProvider),
  );
});

final lastCheckInProvider = FutureProvider<CheckInModel?>((ref) async {
  final repo = ref.watch(checkInRepositoryProvider);
  return await repo.getLastCheckIn();
});

final hasCheckedInTodayProvider = FutureProvider<bool>((ref) async {
  final repo = ref.watch(checkInRepositoryProvider);
  return await repo.hasCheckedInToday();
});

class CheckInRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  CheckInRepository(this._firestore, this._auth);

  String get _userId => _auth.currentUser!.uid;

  Future<void> saveCheckIn(CheckInModel checkIn) {
    return _firestore
        .collection('users')
        .doc(_userId)
        .collection('check_ins')
        .add({
          'moodRating': checkIn.moodRating,
          'activities': checkIn.activities,
          'note': checkIn.note,
          'timestamp': Timestamp.fromDate(checkIn.timestamp),
        });
  }

  /// Fetches the most recent check-in for the current user.
  Future<CheckInModel?> getLastCheckIn() async {
    final snapshot = await _firestore
        .collection('users')
        .doc(_userId)
        .collection('check_ins')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;

    final doc = snapshot.docs.first;
    return CheckInModel(
      moodRating: doc['moodRating'] as int,
      activities: List<String>.from(doc['activities'] ?? []),
      note: doc['note'] as String? ?? '',
      timestamp: (doc['timestamp'] as Timestamp).toDate(),
    );
  }

  /// Returns true if the user has checked in today.
  Future<bool> hasCheckedInToday() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);

    final snapshot = await _firestore
        .collection('users')
        .doc(_userId)
        .collection('check_ins')
        .where(
          'timestamp',
          isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay),
        )
        .where('timestamp', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
        .limit(1)
        .get();

    return snapshot.docs.isNotEmpty;
  }
}

// lib/features/check_in/data/check_in_repository.dart
import 'package:alumea/features/check-in/domain/check_in_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Standard providers for Firebase services.
final firestoreProvider = Provider((_) => FirebaseFirestore.instance);
final authProvider = Provider((_) => FirebaseAuth.instance);

final checkInRepositoryProvider = Provider<CheckInRepository>((ref) {
  return CheckInRepository(ref.watch(firestoreProvider), ref.watch(authProvider));
});

class CheckInRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  CheckInRepository(this._firestore, this._auth);
  
  String get _userId => _auth.currentUser!.uid;

  Future<void> saveCheckIn(CheckInModel checkIn) {
    return _firestore.collection('users').doc(_userId).collection('check_ins').add({
      'moodRating': checkIn.moodRating,
      'contextTags': checkIn.contextTags,
      'note': checkIn.note,
      'timestamp': Timestamp.fromDate(checkIn.timestamp),
    });
  }
}
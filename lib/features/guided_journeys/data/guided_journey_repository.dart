import 'package:alumea/core/providers/firebase_provider.dart';
import 'package:alumea/features/guided_journeys/domain/guided_journey_model.dart';
import 'package:alumea/features/guided_journeys/domain/journey_step_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final guidedJourneyRepositoryProvider = Provider<GuidedJourneyRepository>((ref) {
  return GuidedJourneyRepository(firestore: ref.watch(firestoreProvider));
});

class GuidedJourneyRepository {
  final FirebaseFirestore _firestore;

  GuidedJourneyRepository({required FirebaseFirestore firestore}) : _firestore = firestore;

  Stream<List<GuidedJourney>> getGuidedJourneysStream() {
    return _firestore
        .collection('guided_journeys')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => GuidedJourney.fromFirestore(doc))
          .toList();
    });
  }

  // We can add a method to fetch steps for a specific journey later.
   Stream<List<JourneyStep>> getJourneyStepsStream(String journeyId) {
    return _firestore
        .collection('guided_journeys')
        .doc(journeyId)
        .collection('steps')
        .orderBy('day', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => JourneyStep.fromFirestore(doc))
          .toList();
    });
  }

  // We'll also need a way to save the user's answers.
  Future<void> saveUserAnswer({
    required String journeyId,
    required String stepId,
    required String answer,
    required String userId,
  }) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('journey_progress')
        .doc(journeyId)
        .collection('answers')
        .doc(stepId)
        .set({
      'answer': answer,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
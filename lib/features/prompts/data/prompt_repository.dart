import 'package:alumea/core/providers/firebase_provider.dart';
import 'package:alumea/features/prompts/domain/prompt_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final promptRepositoryProvider = Provider<PromptRepository>((ref) {
  return PromptRepository(ref.watch(firestoreProvider));
});

class PromptRepository {
  final FirebaseFirestore _firestore;
  PromptRepository(this._firestore);

  // Fetches all prompts from the database one time.
  Future<List<PromptModel>> getAllPrompts() async {
    try {
      final snapshot = await _firestore.collection('daily_prompts').get();
      return snapshot.docs
          .map((doc) => PromptModel.fromFirestore(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('Error fetching prompts: $e');
      return [];
    }
  }
}

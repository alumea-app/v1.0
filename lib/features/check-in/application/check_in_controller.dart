// lib/features/check_in/application/check_in_controller.dart
import 'package:alumea/features/check-in/data/check_in_repository.dart';
import 'package:alumea/features/check-in/domain/check_in_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// The provider for our controller.
final checkInControllerProvider =
    StateNotifierProvider.autoDispose<CheckInController, CheckInModel>((ref) {
      // It depends on the repository to save the data.
      return CheckInController(ref.read(checkInRepositoryProvider));
    });

class CheckInController extends StateNotifier<CheckInModel> {
  final CheckInRepository _repository;
  CheckInController(this._repository)
    : super(
        CheckInModel(moodRating: 0, activities: [], timestamp: DateTime.now()),
      );

  void updateMood(int rating) {
    state = state.copyWith(moodRating: rating);
  }

  void updateTags(List<String> tags) {
    state = state.copyWith(activities: tags);
  }

  void updateNote(String note) {
    state = state.copyWith(note: note);
  }

  Future<void> submitCheckIn() async {
    // Here we call the repository to save the final state to Firebase.
    await _repository.saveCheckIn(state);
  }
}

// lib/features/check_in/domain/check_in_model.dart

class CheckInModel {
  final int moodRating; // 1 to 5, where 1 is awful, 5 is great
  final List<String> contextTags;
  final String? note;
  final DateTime timestamp;

  CheckInModel({
    required this.moodRating,
    required this.contextTags,
    this.note,
    required this.timestamp,
  });

  // TODO: Add a toJson() method here to easily save this to Firestore later.
  CheckInModel copyWith(
      {int? moodRating,
      List<String>? contextTags,
      String? note,
      DateTime? timestamp}) {
    return CheckInModel(
        moodRating: moodRating ?? this.moodRating,
        contextTags: contextTags ?? this.contextTags,
        note: note ?? this.note,
        timestamp: timestamp ?? this.timestamp);
  }
}

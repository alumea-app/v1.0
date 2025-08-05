class CheckInModel {
  final int moodRating; // 1 to 5
  final List<String> contextTags;
  final String? note;
  final DateTime timestamp;

  CheckInModel({
    required this.moodRating,
    required this.contextTags,
    this.note,
    required this.timestamp,
  });
  
  // Helper method to easily create a new instance with updated values
  CheckInModel copyWith({
    int? moodRating,
    List<String>? contextTags,
    String? note,
  }) {
    return CheckInModel(
      moodRating: moodRating ?? this.moodRating,
      contextTags: contextTags ?? this.contextTags,
      note: note ?? this.note,
      timestamp: timestamp, // timestamp doesn't change
    );
  }
}
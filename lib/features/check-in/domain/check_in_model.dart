import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class CheckInModel extends Equatable {
  final int moodRating; // 1 to 5
  final List<String> activities;
  final String? note;
  final DateTime timestamp;
  final String? id;

  const CheckInModel({
    required this.moodRating,
    required this.activities,
    this.note,
    required this.timestamp,
    this.id,
  });

  // Helper method to easily create a new instance with updated values
  CheckInModel copyWith({
    int? moodRating,
    List<String>? activities,
    String? note,
    String? id,
  }) {
    return CheckInModel(
      moodRating: moodRating ?? this.moodRating,
      activities: activities ?? this.activities,
      note: note ?? this.note,
      timestamp: timestamp, // timestamp doesn't change
      id: id ?? this.id,
    );
  }

  @override
  List<Object?> get props => [moodRating, activities, note, timestamp, id];

  factory CheckInModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CheckInModel(
      moodRating:
          data['moodRating'] ?? 3, // Changed from 'mood' to 'moodRating'
      activities: List<String>.from(data['activities'] ?? []),
      note: data['note'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      id: doc.id,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'moodRating': moodRating,
      'activities': activities,
      'note': note,
      'timestamp': Timestamp.fromDate(timestamp),
      'id': id,
    };
  }
}

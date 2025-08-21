import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

// Enum to define the different types of tasks
enum JourneyTaskType { textInput, journalPrompt, multiChoice, breathingExercise }

class JourneyStep extends Equatable {
  final String id;
  final int day;
  final String title;
  final String audioScript; // Storing the audio content as text for now
  final JourneyTaskType taskType;
  final String? taskPrompt; // The question for the user
  final List<String>? taskChoices; // Options for multi-choice
   final String audioAssetPath; 

  const JourneyStep({
    required this.id,
    required this.day,
    required this.title,
    required this.audioScript,
    required this.taskType,
    this.taskPrompt,
    this.taskChoices,
    required this.audioAssetPath,
  });

  @override
  List<Object?> get props => [id, day, title, audioScript, taskType, taskPrompt, taskChoices, audioAssetPath];

  factory JourneyStep.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return JourneyStep(
      id: doc.id,
      day: data['day'] ?? 0,
      title: data['title'] ?? '',
      audioScript: data['audioScript'] ?? '',
      // Convert the string from Firestore to our enum
      taskType: JourneyTaskType.values.firstWhere(
        (e) => e.name == data['taskType'],
        orElse: () => JourneyTaskType.journalPrompt,
      ),
      taskPrompt: data['taskPrompt'],
      taskChoices: data['taskChoices'] != null ? List<String>.from(data['taskChoices']) : null,
      audioAssetPath: data['audioAssetPath'] ?? '',
    );
  }
}
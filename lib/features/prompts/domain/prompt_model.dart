import 'package:equatable/equatable.dart';

class PromptModel extends Equatable {
  final String id;
  final String text;
  final String category;

  const PromptModel({
    required this.id,
    required this.text,
    required this.category,
  });

  @override
  List<Object?> get props => [id, text, category];

  factory PromptModel.fromFirestore(Map<String, dynamic> data, String documentId) {
    return PromptModel(
      id: documentId,
      text: data['text'] ?? '',
      category: data['category'] ?? '',
    );
  }
}
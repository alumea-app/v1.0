import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class GuidedJourney extends Equatable {
  final String id;
  final String title;
  final String description;
  final String iconUrl; // For a custom icon on the card

  const GuidedJourney({
    required this.id,
    required this.title,
    required this.description,
    required this.iconUrl,
  });

  @override
  List<Object?> get props => [id, title, description, iconUrl];

  factory GuidedJourney.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return GuidedJourney(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      iconUrl: data['iconUrl'] ?? '',
    );
  }
}
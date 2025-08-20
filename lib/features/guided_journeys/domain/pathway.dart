import 'package:alumea/features/guided_journeys/domain/pathway_day.dart';

class Pathway {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final List<PathwayDay> days;

  Pathway({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.days,
  });
}
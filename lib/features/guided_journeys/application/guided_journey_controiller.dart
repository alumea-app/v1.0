import 'package:alumea/features/guided_journeys/data/guided_journey_repository.dart';
import 'package:alumea/features/guided_journeys/domain/pathway.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// This provider fetches the list of all available pathways
final allPathwaysProvider = FutureProvider<List<Pathway>>((ref) {
  return ref.watch(journeysRepositoryProvider).getAllPathways();
});
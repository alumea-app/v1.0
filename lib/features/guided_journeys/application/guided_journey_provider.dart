import 'package:alumea/features/guided_journeys/data/guided_journey_repository.dart';
import 'package:alumea/features/guided_journeys/domain/guided_journey_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'guided_journey_provider.g.dart';

@riverpod
Stream<List<GuidedJourney>> guidedJourneys(GuidedJourneysRef ref) {
  return ref.watch(guidedJourneyRepositoryProvider).getGuidedJourneysStream();
}
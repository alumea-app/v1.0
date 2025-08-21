import 'package:alumea/features/guided_journeys/data/guided_journey_repository.dart';
import 'package:alumea/features/guided_journeys/domain/journey_step_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'journey_detail_provider.g.dart';

@riverpod
Stream<List<JourneyStep>> journeySteps(Ref ref, String journeyId) {
  final repository = ref.watch(guidedJourneyRepositoryProvider);
  return repository.getJourneyStepsStream(journeyId);
}
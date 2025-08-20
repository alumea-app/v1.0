import 'package:alumea/features/journey/data/journey_repository.dart';
import 'package:alumea/features/journey/domain/journey_entry.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:collection/collection.dart'; // Import the collection package

part 'journey_provider.g.dart';

// The provider will now provide a Map, grouped by date.
@riverpod
Stream<Map<DateTime, List<JourneyEntry>>> journeyEntries(Ref ref) {
  return ref.watch(journeyRepositoryProvider).getJourneyStream().map((entries) {
    // Use the `groupBy` function from the collection package to group entries
    return groupBy(entries, (JourneyEntry entry) {
      // Group by the start of the day (ignoring time)
      final date = entry.timestamp;
      return DateTime(date.year, date.month, date.day);
    });
  });
}
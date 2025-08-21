import 'package:alumea/features/guided_journeys/application/guided_journey_provider.dart';
import 'package:alumea/features/guided_journeys/presentation/journey_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class GuidedJourneysListScreen extends ConsumerWidget {
  const GuidedJourneysListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final journeysAsync = ref.watch(guidedJourneysProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Guided Journeys')),
      body: journeysAsync.when(
        data: (journeys) {
          if (journeys.isEmpty) {
            return const Center(
              child: Text('No journeys available right now.'),
            );
          }
          return ListView.builder(
            itemCount: journeys.length,
            itemBuilder: (context, index) {
              final journey = journeys[index];
              return ListTile(
                leading: CircleAvatar(
                  child: Text(journey.title[0]),
                ), // Placeholder for icon
                title: Text(journey.title),
                subtitle: Text(journey.description),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          JourneyDetailScreen(journey: journey),
                    ),
                  );
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}

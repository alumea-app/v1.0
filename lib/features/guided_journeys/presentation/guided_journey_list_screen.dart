import 'package:alumea/features/guided_journeys/application/guided_journey_controiller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GuidedJourneyListScreen extends ConsumerWidget {
  const GuidedJourneyListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncPathways = ref.watch(allPathwaysProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Guided Journeys')),
      body: asyncPathways.when(
        data: (pathways) => ListView.builder(
          itemCount: pathways.length,
          itemBuilder: (context, index) {
            final pathway = pathways[index];
            return Card(
              margin: const EdgeInsets.all(16),
              child: ListTile(
                title: Text(pathway.title),
                subtitle: Text(pathway.subtitle),
                // TODO: Add onTap to navigate to the pathway detail screen
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}

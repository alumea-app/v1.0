import 'package:alumea/features/guided_journeys/domain/pathway.dart';
import 'package:alumea/features/guided_journeys/domain/pathway_day.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class JourneysRepository {
  Future<List<Pathway>> getAllPathways() async {
    // In a real app, this would be a Firestore query. For our MVP, it's a simple list.
    return Future.value([_tamingTheInnerCritic, _findingYourCalmAnchor]);
  }
}

// --- The Hardcoded Content for our MVP ---
final Pathway _tamingTheInnerCritic = Pathway(
  id: 'pathway_inner_critic',
  title: 'Taming the Inner Critic',
  subtitle: '5 days to build self-compassion',
  description:
      'Learn to recognize, understand, and soften the critical voice in your head.',
  days: [
    PathwayDay(
      dayNumber: 1,
      title: "Naming Your Critic",
      audioScript: "Welcome to Day 1. That critical voice...",
      taskType: PathwayTaskType.textInput,
      taskPrompt: "What is your inner critic's name?",
    ),
    PathwayDay(
      dayNumber: 2,
      title: "Recognizing the Script",
      audioScript: "Hello again. Your critic...",
      taskType: PathwayTaskType.journalPrompt,
      taskPrompt: "Write down one or two phrases your critic often says.",
    ),
    //... Add the rest of the days for this pathway here
  ],
);

final Pathway _findingYourCalmAnchor = Pathway(
  id: '',
  title: '',
  subtitle: '',
  description: '',
  days: [] /* ... content for the second pathway ... */,
);

// --- Riverpod Provider ---
final journeysRepositoryProvider = Provider((ref) => JourneysRepository());

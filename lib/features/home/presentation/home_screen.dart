import 'package:alumea/core/app_theme.dart';
import 'package:alumea/features/auth/application/auth_controller.dart';
import 'package:alumea/features/check-in/data/check_in_repository.dart';
import 'package:alumea/features/home/presentation/widgets/blue_dot_widget.dart';
import 'package:alumea/features/home/presentation/widgets/for_you_card.dart';
import 'package:alumea/features/home/presentation/widgets/helper_cards.dart';
import 'package:alumea/features/prompts/application/daily_prompt_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userDataAsync = ref.watch(currentUserDataProvider);
    final hasCheckedInTodayAsync = ref.watch(hasCheckedInTodayProvider);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            userDataAsync.when(
              data: (user) => RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${_getGreeting()}, ',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    TextSpan(
                      text: user!.name,
                      style: Theme.of(context).textTheme.headlineSmall!
                          .copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .primary, // Change this to your desired color
                          ),
                    ),
                  ],
                ),
              ),
              loading: () => const SizedBox(height: 28),
              error: (e, s) => const Text('Hello.'),
            ),
            const SizedBox(height: 40),
            GestureDetector(
              onTap: () => Routemaster.of(context).push('/chat'),
              child: AbsorbPointer(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "What's on your mind?",
                    prefixIcon: const Icon(Icons.chat_bubble_outline_rounded),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.surface,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.surface,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'For You',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 150, // Give the scrolling list a fixed height
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      // These are our placeholder recommendations
                      ForYouCard(
                        title: 'Daily Check-in',
                        subtitle: 'How are you feeling?',
                        icon: Icons.calendar_today_outlined,
                        onTap: () => Routemaster.of(context).push('/check-in'),
                      ),
                      hasCheckedInTodayAsync.when(
                        data: (checkedIn) => !checkedIn
                            ? const BlueDot()
                            : const SizedBox.shrink(),
                        loading: () => const SizedBox.shrink(),
                        error: (e, s) => const SizedBox.shrink(),
                      ),
                      const SizedBox(width: 16),
                      ForYouCard(
                        title: 'Breathing Exercise',
                        subtitle: 'Find your calm',
                        icon: Icons.air,
                        onTap: () {
                          // TODO: Navigate to breathing exercise tool
                        },
                      ),
                      const SizedBox(width: 16),
                      ForYouCard(
                        title: 'Guided Journeys',
                        subtitle: 'Start a guided journey',
                        icon: Icons.record_voice_over_rounded,
                        onTap: () {
                          Routemaster.of(context).push('/guided-journeys');
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            const Text(
              'Insight of the Day',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ref
                .watch(dailyPromptProvider)
                .when(
                  data: (prompt) {
                    if (prompt == null) {
                      // This will show if there are no prompts in Firestore
                      return const Text('Check back later for a new insight!');
                    }
                    return Card(
                      elevation: 0,
                      color: AppTheme.primaryBlue.withValues(alpha: 0.05),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          prompt.text, // Display the prompt text
                          style: const TextStyle(fontSize: 16, height: 1.5),
                        ),
                      ),
                    );
                  },
                  // Show a small loading indicator while the prompt is being fetched
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, s) => const Text('Could not load insight.'),
                ),
          ],
        ),
      ),
    );
  }
}

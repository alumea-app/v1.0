import 'package:alumea/core/app_theme.dart';
import 'package:alumea/features/auth/application/auth_controller.dart';
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
                      style:
                          Theme.of(context).textTheme.headlineSmall!.copyWith(
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
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _ActionCard(
                    title: 'Daily Check-in',
                    subtitle: 'How are you feeling?',
                    icon: Icons.calendar_today_outlined,
                    onTap: () => Routemaster.of(context).push('/check-in'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _ActionCard(
                    title: 'SOS',
                    subtitle: 'Need help now?',
                    icon: Icons.favorite_border_outlined,
                    onTap: () => Routemaster.of(context).push('/sos'),
                    isEmphasized: true,
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
            ref.watch(dailyPromptProvider).when(
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

// A reusable private widget for the helper cards
class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    this.isEmphasized = false,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final bool isEmphasized;

  @override
  Widget build(BuildContext context) {
    final color = isEmphasized ? AppTheme.accentCoral : AppTheme.primaryBlue;
    final bgColor = isEmphasized
        ? AppTheme.accentCoral.withValues(alpha: 0.1)
        : Colors.white;

    return Card(
      elevation: 0,
      color: bgColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isEmphasized
            ? BorderSide.none
            : BorderSide(color: Colors.grey[200]!),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 12),
              Text(title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16, color: color)),
              const SizedBox(height: 4),
              Text(subtitle,
                  style: TextStyle(color: color.withValues(alpha: 0.8))),
            ],
          ),
        ),
      ),
    );
  }
}

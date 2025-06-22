import 'package:alumea/features/auth/application/auth_controller.dart';
import 'package:alumea/features/chat/presentation/chat_screen.dart'; // The Home Screen
import 'package:alumea/features/onboarding/presentation/onboarding_welcome_screen.dart'; // The First Screen
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // We watch our authControllerProvider. Riverpod will automatically
    // rebuild this widget when the user's auth state changes.
    final authState = ref.watch(authControllerProvider);

    // Use .when() to gracefully handle all states: loading, error, and data.
    return authState.when(
      // Data is available: we have a definitive auth state.
      data: (user) {
        if (user != null) {
          // If the user object is not null, they are logged in. Show the main app.
          return ChatScreen();
        } else {
          // If the user is null, they are logged out. Show the start of the onboarding flow.
          return const OnboardingWelcomeScreen();
        }
      },
      // Still waiting for Firebase to give us the initial auth state.
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      // An error occurred during auth state checking.
      error: (err, stack) => Scaffold(
        body: Center(child: Text('Something went wrong: $err')),
      ),
    );
  }
}

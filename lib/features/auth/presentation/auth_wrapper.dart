import 'package:alumea/features/auth/application/auth_controller.dart';
import 'package:alumea/features/chat/presentation/chat_screen.dart'; // The Home Screen
import 'package:alumea/features/onboarding/presentation/onboarding_welcome_screen.dart'; // The First Screen
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // We watch our authControllerProvider. Riverpod will automatically
    // rebuild this widget when the user's auth state changes.
    final isLoggedIn = ref.watch(authControllerProvider);

    // Show the appropriate screen based on the user's authentication state.
    if (isLoggedIn) {
      // If the user is logged in, show the main app.
      return ChatScreen();
    } else {
      // If the user is logged out, show the start of the onboarding flow.
      return const OnboardingWelcomeScreen();
    }
  }
}

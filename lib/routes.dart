import 'package:alumea/features/auth/presentation/login_screen.dart';
import 'package:alumea/features/chat/presentation/chat_screen.dart';
import 'package:alumea/features/onboarding/presentation/onboarding_chat_screen.dart';
import 'package:alumea/features/onboarding/presentation/onboarding_welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

final routes = RouteMap(
  routes: {
    '/': (_) => const MaterialPage(child: OnboardingWelcomeScreen()),
    // '/': (_) => const MaterialPage(child: AuthWrapper()),
    '/onboardingChat': (_) => const MaterialPage(child: OnboardingChatScreen()),
    '/chat': (_) => MaterialPage(child: ChatScreen()),
    '/login': (_) => MaterialPage(child: LoginScreen()),
  },
);

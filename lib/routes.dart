import 'package:alumea/features/auth/presentation/login_screen.dart';
import 'package:alumea/features/chat/presentation/chat_screen.dart';
import 'package:alumea/features/onboarding/presentation/onboarding_chat_screen.dart';
import 'package:alumea/features/onboarding/presentation/onboarding_welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

// Routes accessible when the user is logged OUT
final loggedOutRoutes = RouteMap(
  routes: {
    '/': (_) => const MaterialPage(child: OnboardingWelcomeScreen()),
    '/onboarding-chat': (_) => const MaterialPage(child: OnboardingChatScreen()),
    '/login': (_) => const MaterialPage(child: LoginScreen()),
  },
);

// Routes accessible when the user is logged IN
final loggedInRoutes = RouteMap(
  onUnknownRoute: (_) => const Redirect('/'),
  routes: {
    '/': (_) => const MaterialPage(child: ChatScreen()),
  },
);
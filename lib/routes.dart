import 'package:alumea/features/auth/presentation/login_screen.dart';
import 'package:alumea/features/chat/presentation/chat_screen.dart';
import 'package:alumea/features/navigation/presentation/app_scaffold.dart';
import 'package:alumea/features/onboarding/presentation/onboarding_chat_screen.dart';
import 'package:alumea/features/onboarding/presentation/onboarding_welcome_screen.dart';
import 'package:alumea/features/settings/presentation/settings_screen_dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

// Routes accessible ONLY when the user is logged OUT
final loggedOutRoutes = RouteMap(
  routes: {
    '/': (_) => const MaterialPage(child: OnboardingWelcomeScreen()),
    '/onboarding-chat': (_) => const MaterialPage(child: OnboardingChatScreen()),
    '/login': (_) => const MaterialPage(child: LoginScreen()),
  },
);

// Routes accessible ONLY when the user is logged IN
final loggedInRoutes = RouteMap(
  onUnknownRoute: (_) => const Redirect('/'),
  routes: {
    // The root is now our AppScaffold with the BottomNavigationBar
    '/': (_) => const MaterialPage(child: AppScaffold()),
    
    // We add a specific route for the chat screen
    '/chat': (_) => MaterialPage(child: ChatScreen()),
    
    // And a route for the settings screen
    '/settings': (_) => const MaterialPage(child: SettingsScreen()),
  },
);
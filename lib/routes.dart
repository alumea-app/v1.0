import 'package:alumea/features/auth/presentation/login_screen.dart';
import 'package:alumea/features/chat/presentation/chat_screen.dart';
import 'package:alumea/features/check-in/presentation/reflection_screen.dart';
import 'package:alumea/features/guided_journeys/presentation/guided_journey_list_screen.dart';
import 'package:alumea/features/journey/presentation/journey_screen.dart';
import 'package:alumea/features/check-in/presentation/check_in_screen.dart';
import 'package:alumea/features/notifications/presentation/notifications_screen.dart';
import 'package:alumea/features/onboarding/presentation/onboarding_chat_screen.dart';
import 'package:alumea/features/onboarding/presentation/onboarding_welcome_screen.dart';
import 'package:alumea/features/security/presentation/app_lock_wrapper.dart';
import 'package:alumea/features/security/presentation/set_passcode_screen.dart';
import 'package:alumea/features/settings/presentation/account_screen.dart';
import 'package:alumea/features/settings/presentation/privacy_policy_screen.dart';
import 'package:alumea/features/settings/presentation/settings_screen.dart';
import 'package:alumea/features/settings/presentation/terms_and_conditions_screen.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

// Routes accessible ONLY when the user is logged OUT
final loggedOutRoutes = RouteMap(
  routes: {
    '/': (_) => const MaterialPage(child: OnboardingWelcomeScreen()),
    '/onboarding-chat': (_) =>
        const MaterialPage(child: OnboardingChatScreen()),
    '/login': (_) => const MaterialPage(child: LoginScreen()),
  },
);

// Routes accessible ONLY when the user is logged IN
final loggedInRoutes = RouteMap(
  onUnknownRoute: (_) => const Redirect('/'),
  routes: {
    // The root is the AppLockWrapper
    '/': (_) => const MaterialPage(child: AppLockWrapper()),

    // Rooute for the chat screen
    '/chat': (_) => MaterialPage(child: ChatScreen()),

    // Route for the journal screen
    '/journal': (_) => MaterialPage(child: JourneyScreen()),

    // Route for the settings screen
    '/settings': (_) => const MaterialPage(child: SettingsScreen()),

    // Route for the settings screen
    '/notifications': (_) => const MaterialPage(child: NotificationsScreen()),

    // Route for the account screen
    '/account': (_) => const MaterialPage(child: AccountScreen()),

    // Route for the terms & conditions screen
    '/terms-and-conditions': (_) =>
        const MaterialPage(child: TermsAndConditionsScreen()),

    // Route for the privacy policy screen
    '/privacy-policy': (_) => const MaterialPage(child: PrivacyPolicyScreen()),

    // Route for the applock screen
    '/set-passcode': (_) => const MaterialPage(child: SetPasscodeScreen()),

    //Route for mood entry screen
    '/check-in': (_) => const MaterialPage(child: CheckInScreen()),

    //Route for reflection screen
    '/check-in/reflection': (routeData) => MaterialPage(
      child: ReflectionScreen(
        // We get the mood rating from the query parameters passed during navigation
        moodRating: int.tryParse(routeData.queryParameters['mood'] ?? '3') ?? 3,
      ),
    ),

    // Route for guided journeys screen
    '/guided-journeys': (_) => const MaterialPage(child: GuidedJourneyListScreen()),
  },
);

// lib/features/auth/application/auth_controller.dart

import 'package:alumea/features/auth/data/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// This is the single most important provider in our authentication system.
// It exposes the current authentication state of the user.
//
// We will use this provider to determine which screen to show the user:
// - If the user is `null` (logged out), we show the onboarding/login screens.
// - If the user is not `null` (logged in), we show the main app (e.g., the ChatScreen).
final authControllerProvider = StreamProvider<User?>((ref) {
  // We watch the repository provider...
  final authRepository = ref.watch(authRepositoryProvider);
  // ...and return its authStateChanges stream.
  // Riverpod will automatically listen to this stream and provide the latest
  // value to any widget that is watching this authControllerProvider.
  return authRepository.authStateChanges;
});
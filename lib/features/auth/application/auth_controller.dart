import 'package:alumea/features/auth/data/auth_repository.dart';
import 'package:alumea/utils/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:alumea/shared/models/user_model.dart';
import 'package:routemaster/routemaster.dart';

final userProvider = StateProvider<UserModel?>((ref) => null);

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(
    authRepository: ref.watch(authRepositoryProvider),
    ref: ref,
  ),
);

final authStateChangeProvider = StreamProvider<User?>((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.authStateChange;
});

final getUserDataProvider =
    StreamProvider.family<UserModel, String>((ref, uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid);
});

final currentUserDetailsProvider = FutureProvider<UserModel>((ref) async {
  final currentUserId = ref.watch(userProvider)!.uid;
  final userDetails =
      ref.watch(authControllerProvider.notifier).getUserData(currentUserId);
  return userDetails.first;
});

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  final Ref _ref;

  AuthController({
    required AuthRepository authRepository,
    required Ref ref,
  })  : _authRepository = authRepository,
        _ref = ref,
        super(false);

  Stream<User?> get authStateChange => _authRepository.authStateChanges;

  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authRepository.signUpWithEmailAndPassword(
      email: email,
      password: password,
    );
    res.fold(
      (l) => showSnackbar(context, l.message),
      (r) async {
        showSnackbar(context, 'Account created! Please login.');
        Routemaster.of(context).replace('/');
      },
    );
    state = false;
  }

  Future<void> signIn({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authRepository.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    res.fold(
      (l) => showSnackbar(
        context,
        l.message.toString(),
      ),
      (r) => Routemaster.of(context).replace('/'),
    );
    state = false;
  }

  Future<void> signOut({
    required BuildContext context,
  }) async {
    state = true;
    _authRepository.signOut();
    Routemaster.of(context).replace('/');
    state = false;
  }

  Stream<UserModel> getUserData(String uid) {
    return _authRepository.getUserData(uid);
  }
}

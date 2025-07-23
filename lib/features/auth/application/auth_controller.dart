import 'package:alumea/features/auth/data/auth_repository.dart';
import 'package:alumea/utils/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:alumea/shared/models/user_model.dart';
import 'package:routemaster/routemaster.dart';

final userProvider = StateProvider<UserModel?>((ref) => null);

// 1. This is our main provider for the authentication state (User or null)
final authStateChangeProvider = StreamProvider<User?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges;
});

// 2. THIS IS OUR NEW, EFFICIENT USER DATA PROVIDER.
// It watches the auth state. When the user logs in, it fetches their data.
// When they log out, it provides null.
final currentUserDataProvider = StreamProvider<UserModel?>((ref) {
  // Watch the auth state stream
  final authState = ref.watch(authStateChangeProvider);
  
  // If a user is logged in (we have data), fetch their user model from Firestore.
  // Otherwise, return a stream of null.
  if (authState.asData?.value != null) {
    final authRepository = ref.watch(authRepositoryProvider);
    return authRepository.getUserData(authState.asData!.value!.uid);
  }
  return Stream.value(null);
});


// 3. We can keep a simple StateNotifier for handling loading states during login/signup
// (This part is optional but good practice)
final authControllerProvider =
    StateNotifierProvider.autoDispose<AuthController, bool>((ref) {
  return AuthController(
    authRepository: ref.watch(authRepositoryProvider),
    ref: ref,
  );
});

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  // ignore: unused_field
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

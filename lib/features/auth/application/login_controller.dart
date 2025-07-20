import 'dart:async';
import 'package:alumea/features/auth/data/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// LoginState remains the same
class LoginState {
  const LoginState({this.isLoading = false, this.error});
  final bool isLoading;
  final String? error;

  LoginState copyWith({bool? isLoading, String? error, bool clearError = false}) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
    );
  }
}

class LoginController extends StateNotifier<LoginState> {
  LoginController(this.ref) : super(const LoginState());

  final Ref ref;

  Future<void> signUp(String email, String password) async {
    state = state.copyWith(isLoading: true, clearError: true);
    final res = await ref
        .read(authRepositoryProvider)
        .signUpWithEmailAndPassword(email: email, password: password);

    // .fold() handles the Either result.
    // The first function is for the Left (Failure) case.
    // The second function is for the Right (Success) case.
    res.fold(
      (failure) => state = state.copyWith(isLoading: false, error: failure.message),
      (_) => state = state.copyWith(isLoading: false),
    );
  }

  Future<void> signIn(String email, String password) async {
    state = state.copyWith(isLoading: true, clearError: true);
    final res = await ref
        .read(authRepositoryProvider)
        .signInWithEmailAndPassword(email: email, password: password);
    
    res.fold(
      (failure) => state = state.copyWith(isLoading: false, error: failure.message),
      (_) => state = state.copyWith(isLoading: false),
    );
  }
}

final loginControllerProvider =
    StateNotifierProvider.autoDispose<LoginController, LoginState>(
        (ref) => LoginController(ref));
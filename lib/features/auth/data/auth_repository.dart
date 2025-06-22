import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthRepository {
  final FirebaseAuth _auth;
  AuthRepository(this._auth);

  // A stream that provides the current logged-in user or null.
  // This is the core of our reactive authentication system.
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Creates a new user with the given email and password.
  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      // You can add custom logic here based on error codes like 'email-already-in-use'.
      // For now, we re-throw the exception to be handled by the UI.
      rethrow;
    }
  }

  /// Signs in a user with the given email and password.
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      // Handle 'user-not-found' or 'wrong-password'.
      rethrow;
    }
  }

  /// Signs out the current user.
  Future<void> signOut() async {
    await _auth.signOut();
  }
}

// --- Providers ---

// A simple provider for the FirebaseAuth instance.
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

// The main provider for our AuthRepository.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(firebaseAuthProvider));
});
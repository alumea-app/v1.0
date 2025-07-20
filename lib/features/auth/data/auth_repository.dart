import 'dart:developer';

import 'package:alumea/core/errors/failure_class.dart';
import 'package:alumea/core/providers/firebase_provider.dart';
import 'package:alumea/core/types/type_defs.dart';
import 'package:alumea/features/onboarding/data/onboarding_repository.dart';
import 'package:alumea/shared/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    auth: ref.watch(authProvider),
    firestore: ref.watch(firestoreProvider),
    prefs: ref.watch(sharedPreferencesProvider).asData!.value,
  );
});

class AuthRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final SharedPreferences _prefs;

  AuthRepository({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
    required SharedPreferences prefs,
  })  : _auth = auth,
        _firestore = firestore,
        _prefs = prefs;

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  CollectionReference get _users => _firestore.collection('users');

  /// Creates a user and saves their data. Returns nothing on success
  /// or a Failure object on error.
  FutureVoid signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user == null) {
        throw 'User creation failed, user is null.';
      }
      final name = _prefs.getString('userName') ?? 'No Name';
      final userModel = UserModel(
        uid: user.uid,
        name: name,
        email: email,
        createdAt: DateTime.now(),
      );
      await _users.doc(user.uid).set(userModel.toMap());
      return right(null); // Return Right(null) for success
    } on FirebaseAuthException catch (e) {
      throw e.message!;
    } catch (e, stackTrace) {
      return left(FailureClass(e.toString(), stackTrace));
    }
  }

  /// Signs in a user. Returns nothing on success or a Failure on error.
  FutureVoid signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return right(null);
    } on FirebaseAuthException catch (e, stackTrace) {
      // **** ADDED LOGGING ****
      log(
        'FirebaseAuthException during sign in:',
        error: 'Code: ${e.code}\nMessage: ${e.message}', // Log code and message
        stackTrace: stackTrace,
        name: 'AuthRepository.signIn', // Optional: Identify the source
      );
      switch (e.code) {
        case 'user-not-found':
        case 'invalid-email': // Added common case
          // Consider returning left instead of throwing for cleaner fpdart usage
          return left(FailureClass('Invalid email address!', stackTrace));
        case 'wrong-password':
        case 'invalid-credential': // Added common case - covers both wrong email/pass generally
          // Consider returning left instead of throwing
          return left(FailureClass('Invalid credentials!', stackTrace));
        case 'user-disabled':
          // Consider returning left instead of throwing
          return left(
              FailureClass('This user account has been disabled.', stackTrace));
        // Add any other specific Firebase Auth error codes you want to handle distinctly
        default:
          // Consider returning left instead of throwing
          return left(FailureClass(
              'An authentication error occurred. Please try again.',
              stackTrace));
      }
    } catch (e, stackTrace) {
      // **** ADDED LOGGING ****
      log(
        'Generic exception during sign in:',
        error: e.toString(), // Log the generic error
        stackTrace: stackTrace,
        name: 'AuthRepository.signIn',
      );
      return left(FailureClass(
          'An unexpected error occurred: ${e.toString()}', stackTrace));
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Stream<UserModel> getUserData(String uid) {
    return _users.doc(uid).snapshots().map(
          (event) => UserModel.fromMap(event.data() as Map<String, dynamic>),
        );
  }
}

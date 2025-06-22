import 'package:alumea/features/auth/data/auth_repository.dart'; // To access our auth provider
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class RegistrationForm extends ConsumerStatefulWidget {
  const RegistrationForm({Key? key}) : super(key: key);

  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends ConsumerState<RegistrationForm> {
  // A GlobalKey to uniquely identify our Form widget and allow validation.
  final _formKey = GlobalKey<FormState>();

  // Controllers to manage the text being entered.
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // A boolean to manage the loading state for user feedback.
  bool _isLoading = false;

  // It's crucial to dispose of controllers when the widget is removed to prevent memory leaks.
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Handles the form submission logic.
  Future<void> _submitForm() async {
    // First, validate the form using the key. If it's not valid, do nothing.
    if (_formKey.currentState!.validate()) {
      // Set loading state to true to show the progress indicator
      setState(() {
        _isLoading = true;
      });

      // Use a try/catch block to gracefully handle potential errors from Firebase.
      try {
        // Read the auth repository from our provider and call the sign-up method.
        await ref.read(authRepositoryProvider).signUpWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
            );

        // IMPORTANT: On success, navigate the user to the main chat screen.
        // We use .replace() so the user cannot press the "back" button to
        // return to the onboarding flow.
        if (mounted) {
          Routemaster.of(context).replace('/onboardingChat');
        }
      } catch (e) {
        // If an error occurs (e.g., email already in use, weak password),
        // show a user-friendly message in a SnackBar.
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Registration failed. Please try again.'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      } finally {
        // IMPORTANT: Always set loading back to false, even if an error occurs.
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // We add padding here to ensure our form content isn't touching the screen edges.
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        // Using a Column with MainAxisSize.min makes the bottom sheet only as
        // tall as its content needs to be.
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Create Your Private Account',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
              // Validator function for email.
              validator: (value) {
                if (value == null ||
                    value.trim().isEmpty ||
                    !value.contains('@')) {
                  return 'Please enter a valid email.';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true, // Hides the password text.
              // Validator function for password.
              validator: (value) {
                if (value == null || value.trim().length < 6) {
                  return 'Password must be at least 6 characters.';
                }
                return null;
              },
            ),
            const SizedBox(height: 32),
            // Conditionally show either the button or a loading indicator.
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Create Account & Continue'),
              ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                // When tapped, take the user to the login screen.
                Navigator.of(context).pop(); // Close the bottom sheet first
                Routemaster.of(context).push('/login');
              },
              child: const Text('Already have an account? Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}

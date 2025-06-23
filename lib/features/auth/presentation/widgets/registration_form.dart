import 'package:alumea/features/auth/application/login_controller.dart';
import 'package:alumea/features/auth/data/auth_repository.dart'; // To access our auth provider
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class RegistrationForm extends ConsumerWidget {
  const RegistrationForm({Key? key}) : super(key: key);

  // A GlobalKey to uniquely identify our Form widget and allow validation.

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();

    // Controllers to manage the text being entered.
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    ref.listen<LoginState>(loginControllerProvider, (previous, next) {
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    });

    // A boolean to manage the loading state for user feedback.
     final loginState = ref.watch(loginControllerProvider);

    Future<void> submitForm() async {
      if (formKey.currentState!.validate()) {
        final success = await ref
            .read(loginControllerProvider.notifier)
            .signUp(emailController.text.trim(), passwordController.text.trim());
        
        if (success && context.mounted) {
          // The AuthWrapper will handle the navigation automatically now.
          // If we are in a modal sheet, we might want to pop it.
          Navigator.of(context).pop();
        }
      }
    }


    // We add padding here to ensure our form content isn't touching the screen edges.
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: formKey,
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
              controller: emailController,
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
              controller: passwordController,
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
            if (loginState.isLoading)
              const Center(child: CircularProgressIndicator())
            else
              ElevatedButton(
                onPressed: submitForm,
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

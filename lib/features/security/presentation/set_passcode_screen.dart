import 'package:alumea/features/security/data/security_repository.dart';
import 'package:alumea/features/security/application/security_controller.dart'; // Import this
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinput/pinput.dart';
import 'package:routemaster/routemaster.dart';
import 'package:alumea/utils/snackbar.dart';

class SetPasscodeScreen extends ConsumerStatefulWidget {
  const SetPasscodeScreen({super.key});

  @override
  ConsumerState<SetPasscodeScreen> createState() => _SetPasscodeScreenState();
}

class _SetPasscodeScreenState extends ConsumerState<SetPasscodeScreen> {
  final _pinController = TextEditingController();
  String? _firstPin;

  @override
  Widget build(BuildContext context) {
    final isConfirming = _firstPin != null;
    final title = isConfirming ? 'Confirm your PIN' : 'Create a 6-digit PIN';
    final subtitle = isConfirming
        ? 'Please enter your PIN again to confirm.'
        : 'This will be used to secure your app.';

    return Scaffold(
      appBar: AppBar(title: const Text('Set up App Lock')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 32),
              Pinput(
                key: ValueKey(isConfirming),
                controller: _pinController,
                length: 6,
                obscureText: true,
                autofocus: true,
                onCompleted: (pin) async {
                  if (!isConfirming) {
                    setState(() => _firstPin = pin);
                    _pinController.clear();
                  } else {
                    if (_firstPin == pin) {
                      await ref.read(securityRepositoryProvider).savePin(pin);
                      showSnackbar(context, 'App Lock has been enabled.');
                      
                      // After PIN is set, check for biometrics
                      await _promptForBiometrics();
                      
                      if (mounted) Routemaster.of(context).pop();
                    } else {
                      showSnackbar(context, 'PINs do not match. Please try again.');
                      setState(() => _firstPin = null);
                      _pinController.clear();
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _promptForBiometrics() async {
    final securityController = ref.read(securityControllerProvider.notifier);
    final canUseBiometrics = await securityController.canUseBiometrics();

    if (canUseBiometrics && mounted) {
      // This will show the system dialog asking for permission and scanning
      // the first time it is called.
      await securityController.unlockWithBiometrics();
    }
  }
}
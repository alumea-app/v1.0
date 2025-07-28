import 'package:alumea/features/security/application/security_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinput/pinput.dart';

class UnlockScreen extends ConsumerStatefulWidget {
  const UnlockScreen({super.key});

  @override
  ConsumerState<UnlockScreen> createState() => _UnlockScreenState();
}

class _UnlockScreenState extends ConsumerState<UnlockScreen> {
  bool _showPinInput = false;
  bool _canUseBiometrics = false;

  @override
  void initState() {
    super.initState();
    _initAuth();
  }

  Future<void> _initAuth() async {
    final securityController = ref.read(securityControllerProvider.notifier);
    _canUseBiometrics = await securityController.canUseBiometrics();
    if (_canUseBiometrics) {
      await _tryBiometrics();
    } else {
      // If no biometrics, go straight to PIN input
      setState(() => _showPinInput = true);
    }
  }

  Future<void> _tryBiometrics() async {
    final success = await ref
        .read(securityControllerProvider.notifier)
        .unlockWithBiometrics();
    if (!mounted) return;
    if (!success) {
      // If biometrics failed or was cancelled, show PIN input
      setState(() => _showPinInput = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: !_showPinInput
              ? const CircularProgressIndicator()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Enter PIN', style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 20),
                    Pinput(
                      length: 6,
                      obscureText: true,
                      autofocus: true,
                      onCompleted: (pin) async {
                        final success = await ref
                            .read(securityControllerProvider.notifier)
                            .unlockWithPin(pin);
                        if (!success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Incorrect PIN')),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    if (_canUseBiometrics)
                      TextButton.icon(
                        icon: const Icon(Icons.fingerprint),
                        label: const Text('Use Biometrics'),
                        onPressed: _tryBiometrics,
                      ),
                  ],
                ),
        ),
      ),
    );
  }
}
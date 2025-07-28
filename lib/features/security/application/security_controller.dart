import 'package:alumea/features/security/data/security_repository.dart';
import 'package:local_auth/local_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'security_controller.g.dart';

final appLockEnabledProvider = FutureProvider<bool>((ref) async {
  return ref.watch(securityRepositoryProvider).hasPin();
});

enum AppLockState { locked, unlocked }

@riverpod
class SecurityController extends _$SecurityController {
  late SecurityRepository _repository;
  late LocalAuthentication _localAuth;

  @override
  Future<AppLockState> build() async {
    _repository = ref.watch(securityRepositoryProvider);
    _localAuth = LocalAuthentication();
    
    final hasPin = await _repository.hasPin();
    return hasPin ? AppLockState.locked : AppLockState.unlocked;
  }

  void lockApp() async {
    if (await _repository.hasPin()) {
      state = const AsyncData(AppLockState.locked);
    }
  }

  Future<bool> canUseBiometrics() async {
    return await _localAuth.canCheckBiometrics;
  }

  Future<bool> unlockWithBiometrics() async {
    if (state.value == AppLockState.unlocked) return true;
    try {
      final didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Please authenticate to open Alumea',
        options: const AuthenticationOptions(biometricOnly: true, stickyAuth: true),
      );
      if (didAuthenticate) {
        state = const AsyncData(AppLockState.unlocked);
      }
      return didAuthenticate;
    } catch (e) {
      return false;
    }
  }

  Future<bool> unlockWithPin(String pin) async {
    if (state.value == AppLockState.unlocked) return true;
    final isPinCorrect = await _repository.verifyPin(pin);
    if (isPinCorrect) {
      state = const AsyncData(AppLockState.unlocked);
    }
    return isPinCorrect;
  }
}
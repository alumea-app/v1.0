import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingRepository {
  final SharedPreferences _prefs;
  OnboardingRepository(this._prefs);

  static const _userNameKey = 'userName';

  Future<void> saveUserName(String name) async {
    await _prefs.setString(_userNameKey, name);
  }
}

// Providers
final sharedPreferencesProvider =
    FutureProvider<SharedPreferences>((ref) => SharedPreferences.getInstance());

final onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider).asData!.value;
  return OnboardingRepository(prefs);
});
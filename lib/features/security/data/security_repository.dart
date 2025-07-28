import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final secureStorageProvider = Provider((ref) {
  const aOptions = AndroidOptions(encryptedSharedPreferences: true);
  return const FlutterSecureStorage(aOptions: aOptions);
});

final securityRepositoryProvider = Provider((ref) {
  return SecurityRepository(ref.watch(secureStorageProvider));
});

class SecurityRepository {
  final FlutterSecureStorage _secureStorage;
  SecurityRepository(this._secureStorage);

  static const String _pinKey = 'user_pin';

  Future<void> savePin(String pin) async {
    await _secureStorage.write(key: _pinKey, value: pin);
  }

  Future<void> deletePin() async {
    await _secureStorage.delete(key: _pinKey);
  }

  Future<bool> hasPin() async {
    final pin = await _secureStorage.read(key: _pinKey);
    return pin != null;
  }

  Future<bool> verifyPin(String pin) async {
    final savedPin = await _secureStorage.read(key: _pinKey);
    return savedPin == pin;
  }
}
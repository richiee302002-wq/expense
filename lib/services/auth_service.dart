import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthService {
  final FlutterSecureStorage _storage;
  static const _pinKey = 'user_pin';

  AuthService(this._storage);

  Future<bool> hasPin() async {
    final pin = await _storage.read(key: _pinKey);
    return pin != null;
  }

  Future<bool> verifyPin(String enteredPin) async {
    final storedPin = await _storage.read(key: _pinKey);
    return storedPin == enteredPin;
  }

  Future<void> setPin(String newPin) async {
    await _storage.write(key: _pinKey, value: newPin);
  }

  Future<void> clearPin() async {
    await _storage.delete(key: _pinKey);
  }
}

final authServiceProvider = Provider<AuthService>((ref) {
  const storage = FlutterSecureStorage();
  return AuthService(storage);
});

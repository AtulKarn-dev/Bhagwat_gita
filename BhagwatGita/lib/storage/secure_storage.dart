import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final _storage = const FlutterSecureStorage();

  Future writeData(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  Future readData(String key) async {
    String? data = await _storage.read(key: key);
    return data;
  }

  Future deleteData(String key) async {
    await _storage.delete(key: key);
  }

  Future deleteAll() async {
    await _storage.deleteAll();
  }
}

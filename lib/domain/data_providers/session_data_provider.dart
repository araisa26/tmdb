import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class KeySession {
  static const sessionId = 'session-id';
  static const accountId = 'account-id';
}

class SessionDataProvider {
  final secirutyStorage = FlutterSecureStorage();
  Future<String?> getSessionId() async =>
      await secirutyStorage.read(key: KeySession.sessionId);
  Future<void> setSessonId(String? value) {
    if (value != null) {
      return secirutyStorage.write(key: KeySession.sessionId, value: value);
    } else {
      return secirutyStorage.delete(key: KeySession.sessionId);
    }
  }

  Future<String?> getAccountId() async =>
      await secirutyStorage.read(key: KeySession.accountId);
  Future<void> setAccountId(int? value) {
    if (value != null) {
      return secirutyStorage.write(
          key: KeySession.accountId, value: value.toString());
    } else {
      return secirutyStorage.delete(key: KeySession.accountId);
    }
  }
}

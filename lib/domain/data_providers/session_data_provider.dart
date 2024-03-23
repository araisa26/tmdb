import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class KeySession {
  static const sessionId = 'session-id';
  static const accountId = 'account-id';
}

abstract class SessionDataProvider {
  static const secirutyStorage = FlutterSecureStorage();
  static Future<String?> getSessionId() async =>
      await secirutyStorage.read(key: KeySession.sessionId);
  static Future<void> setSessonId(String? value) {
    if (value != null) {
      return secirutyStorage.write(key: KeySession.sessionId, value: value);
    } else {
      return secirutyStorage.delete(key: KeySession.sessionId);
    }
  }

  static Future<String?> getAccountId() async =>
      await secirutyStorage.read(key: KeySession.accountId);
  static Future<void> setAccountId(int? value) {
    if (value != null) {
      return secirutyStorage.write(
          key: KeySession.accountId, value: value.toString());
    } else {
      return secirutyStorage.delete(key: KeySession.accountId);
    }
  }
}

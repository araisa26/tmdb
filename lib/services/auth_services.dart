import 'package:flutter/material.dart';
import 'package:themoviedb/domain/api_client/auth_api_client.dart';
import 'package:themoviedb/domain/data_providers/session_data_provider.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';

abstract class AuthServices {
  static Future<bool> isAuth() async {
    return await SessionDataProvider.getSessionId() != null;
  }

  static Future<void> auth(
      TextEditingController login, TextEditingController password) async {
    await SessionDataProvider.setSessonId(
        await AuthApiClient.makeSessionId(login.text, password.text));
    await SessionDataProvider.setAccountId(await AuthApiClient.getAccountId(
        await SessionDataProvider.getSessionId()));
  }

  static Future<void> resetSession(context) async {
    await SessionDataProvider.setSessonId(null);
    await SessionDataProvider.setAccountId(null);
    Navigator.of(context).restorablePushNamedAndRemoveUntil(
        MainNavigationRoutesName.loaderWidget, (route) => false);
  }
}

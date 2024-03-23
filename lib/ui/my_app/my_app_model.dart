import 'package:flutter/material.dart';
import 'package:themoviedb/domain/data_providers/session_data_provider.dart';

class MyAppModel extends ChangeNotifier {
  final sessionDataProvider = SessionDataProvider();
  bool isAuth = false;
  Future<void> checkAuth() async {
    this.isAuth = await sessionDataProvider.getSessionId() != null;
    notifyListeners();
  }
}

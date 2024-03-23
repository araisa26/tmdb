import 'package:flutter/material.dart';
import 'package:themoviedb/domain/api_client.dart';
import 'package:flutter/widgets.dart';
import 'package:themoviedb/domain/data_providers/session_data_provider.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';

class AuthModel extends ChangeNotifier {
  final sessionDataProvider = SessionDataProvider();
  final loginTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  String? errorText;
  bool canAuthStart = false;
  String? sessionId;
  Future<void> auth(BuildContext context) async {
    if (this.loginTextController.text.isEmpty ||
        this.passwordTextController.text.isEmpty) {
      this.errorText = 'Заполните логин или пароль';
      notifyListeners();
    } else {
      this.canAuthStart = true;
      notifyListeners();
      try {
        await sessionDataProvider.setSessonId(await makeSessionId(
            this.loginTextController.text, this.passwordTextController.text));
        await (sessionDataProvider.setAccountId(
            await getAccountId(await sessionDataProvider.getSessionId())));
        if (await sessionDataProvider.getSessionId() != null) {
          Navigator.pushReplacementNamed(
              context, MainNavigationRoutesName.mainScreen);
        } else {
          this.canAuthStart = false;
          this.errorText = 'Неизвестная ошибка';
        }
      } catch (error) {
        this.errorText = error.toString();
        notifyListeners();
      }
      notifyListeners();
    }
  }

  void resertPassword() {
    this.errorText = null;
    this.canAuthStart = false;
    notifyListeners();
  }
}

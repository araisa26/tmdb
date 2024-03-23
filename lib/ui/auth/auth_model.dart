import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:themoviedb/services/auth_services.dart';
import 'package:themoviedb/domain/data_providers/session_data_provider.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';

class AuthModel extends ChangeNotifier {
  final loginTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  String? errorText;
  bool canAuthStart = false;

  Future<void> auth(BuildContext context) async {
    if (loginTextController.text.isEmpty ||
        passwordTextController.text.isEmpty) {
      errorText = 'Заполните логин или пароль';
      notifyListeners();
    } else {
      canAuthStart = true;
      notifyListeners();
      try {
        await AuthServices.auth(loginTextController, passwordTextController);
        (await SessionDataProvider.getSessionId() != null &&
                await SessionDataProvider.getAccountId() != null)
            ? MainNavigation.resetNavigation(context)
            : {
                canAuthStart = false,
                errorText = 'Неизвестная ошибка',
              };
      } catch (error) {
        canAuthStart = false;
        errorText = error.toString();
        notifyListeners();
      }
    }
  }

  void resert() {
    loginTextController.text = '';
    passwordTextController.text = '';
    errorText = null;
    canAuthStart = false;
    notifyListeners();
  }
}

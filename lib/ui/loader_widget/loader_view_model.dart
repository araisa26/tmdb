import 'package:flutter/material.dart';
import 'package:themoviedb/services/auth_services.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';

class LoaderViewModel {
  BuildContext context;
  LoaderViewModel(this.context) {
    checkAuth();
  }
  Future<void> checkAuth() async {
    await AuthServices.isAuth() == true
        ? Navigator.of(context)
            .pushReplacementNamed(MainNavigationRoutesName.mainScreen)
        : Navigator.of(context)
            .pushReplacementNamed(MainNavigationRoutesName.auth);
  }
}

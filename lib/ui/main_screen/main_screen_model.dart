import 'package:flutter/material.dart';

class MainScreenModel extends ChangeNotifier {
  int selectedTab = 0;
  void onselectedTab(index) {
    if (selectedTab == index) return;
    selectedTab = index;
    notifyListeners();
  }
}

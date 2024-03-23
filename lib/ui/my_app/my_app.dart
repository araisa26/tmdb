import 'package:flutter/material.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';
import 'package:themoviedb/resources/app_colors.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "the movie db",
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Appcolors.mainDarkBlue,
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ru', 'RU'),
        Locale('en', 'US'),
      ],
      debugShowCheckedModeBanner: false,
      routes: MainNavigation().routes,
      initialRoute: MainNavigationRoutesName.loaderWidget,
      onGenerateRoute: MainNavigation().onGenerateRoute,
    );
  }
}

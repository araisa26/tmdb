import 'package:flutter/material.dart';
import 'package:themoviedb/library/provider.dart';
import 'package:themoviedb/ui/my_app/my_app_model.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';
import 'package:themoviedb/ui/theme/app_colors.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = Provider.read<MyAppModel>(context);
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
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('ru', 'RU'),
        Locale('en', 'US'),
      ],
      debugShowCheckedModeBanner: false,
      routes: MainNavigation().routes,
      initialRoute: MainNavigation().initialRoute(model?.isAuth == true),
      onGenerateRoute: MainNavigation().onGenerateRoute,
    );
  }
}

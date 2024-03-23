import 'package:flutter/material.dart';
import 'package:themoviedb/library/provider.dart';
import 'package:themoviedb/ui/auth/auth_model.dart';
import 'package:themoviedb/ui/auth/auth_widget.dart';
import 'package:themoviedb/ui/main_screen/main_screen_model.dart';
import 'package:themoviedb/ui/main_screen/main_screen_widget.dart';
import 'package:themoviedb/ui/movie_details/movie_details_model.dart';
import 'package:themoviedb/ui/movie_details/movie_detais_widget.dart';
import 'package:themoviedb/ui/movie_trailer/movie_trailer_widget.dart';

abstract class MainNavigationRoutesName {
  static const auth = "auth";
  static const mainScreen = "/";
  static const movieDetails = "/movie_details";
  static const movieTrailer = "/movie_details/trailer";
}

class MainNavigation {
  Map<String, WidgetBuilder> routes = {
    MainNavigationRoutesName.auth: (context) =>
        NotifierProvider(create: () => AuthModel(), child: const AuthWidget()),
    MainNavigationRoutesName.mainScreen: (context) => NotifierProvider(
        create: () => MainScreenModel(), child: const MainScreenWidget()),
  };

  String initialRoute(bool isAuth) => isAuth
      ? MainNavigationRoutesName.mainScreen
      : MainNavigationRoutesName.auth;

  Route<Object> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case MainNavigationRoutesName.movieDetails:
        final arguments = settings.arguments;
        final movieId = arguments is int ? arguments : 0;
        return MaterialPageRoute(
            builder: (context) => NotifierProvider(
                create: () => MovieDetailsModel(movieId),
                child: MovieDetailsWidget()));
      case MainNavigationRoutesName.movieTrailer:
        final arguments = settings.arguments;
        final youtubeKey = arguments is String ? arguments : '';
        return MaterialPageRoute(
            builder: (context) => MovieTrailerWidget(
                  trailerKey: youtubeKey,
                ));
      default:
        const widget = Text('Navigation error!!!');
        return MaterialPageRoute(builder: (context) => widget);
    }
  }
}

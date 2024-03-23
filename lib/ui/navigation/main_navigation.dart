import 'package:flutter/material.dart';
import 'package:themoviedb/domain/screen_factory/screen_factory.dart';

abstract class MainNavigationRoutesName {
  static const loaderWidget = "/";
  static const auth = "/auth";
  static const mainScreen = "/main_screen";
  static const movieDetails = "/main_screen/movie_details";
  static const movieTrailer = "/main_screen/movie_details/trailer";
}

class MainNavigation {
  Map<String, WidgetBuilder> routes = {
    MainNavigationRoutesName.loaderWidget: (_) => ScreenFactory().makeloader(),
    MainNavigationRoutesName.auth: (_) => ScreenFactory().makeAuth(),
    MainNavigationRoutesName.mainScreen: (_) => ScreenFactory.makeMainScreen(),
  };

  Route<Object> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case MainNavigationRoutesName.movieDetails:
        final arguments = settings.arguments;
        final movieId = arguments is int ? arguments : 0;
        return MaterialPageRoute(
            builder: (_) => ScreenFactory.makeMovieDetails(movieId));
      case MainNavigationRoutesName.movieTrailer:
        final arguments = settings.arguments;
        final youtubeKey = arguments is String ? arguments : '';
        return MaterialPageRoute(
            builder: (_) => ScreenFactory.makeMovieTrailer(youtubeKey));
      default:
        const widget = Text('Navigation error!!!');
        return MaterialPageRoute(builder: (context) => widget);
    }
  }

  static resetNavigation(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
        MainNavigationRoutesName.loaderWidget, (route) => false);
  }
}

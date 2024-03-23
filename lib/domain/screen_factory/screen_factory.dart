import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:themoviedb/ui/auth/auth_model.dart';
import 'package:themoviedb/ui/auth/auth_widget.dart';
import 'package:themoviedb/ui/loader_widget/loader_view_model.dart';
import 'package:themoviedb/ui/loader_widget/loader_widget.dart';
import 'package:themoviedb/ui/main_screen/main_screen_model.dart';
import 'package:themoviedb/ui/main_screen/main_screen_widget.dart';
import 'package:themoviedb/ui/movie_details/movie_details_model.dart';
import 'package:themoviedb/ui/movie_details/movie_detais_widget.dart';
import 'package:themoviedb/ui/movie_list/movie_list.dart';
import 'package:themoviedb/ui/movie_list/movie_list_model.dart';
import 'package:themoviedb/ui/movie_trailer/movie_trailer_widget.dart';

abstract class ScreenFactory {
  static Widget makeloader() {
    return Provider(
      create: (context) => LoaderViewModel(context),
      lazy: false,
      child: const LoaderWidget(),
    );
  }

  static Widget makeAuth() {
    return ChangeNotifierProvider(
      create: (context) => AuthModel(),
      child: const AuthWidget(),
    );
  }

  static Widget makeMainScreen() {
    return ChangeNotifierProvider(
      create: (context) => MainScreenModel(),
      child: const MainScreenWidget(),
    );
  }

  static Widget makeMovieDetails(movieId) {
    return ChangeNotifierProvider(
      create: (context) => MovieDetailsModel(movieId),
      child: const MovieDetailsWidget(),
    );
  }

  static Widget makeMovieTrailer(trailerKey) {
    return MovieTrailerWidget(
      trailerKey: trailerKey,
    );
  }

  static Widget makeMovieList() {
    return ChangeNotifierProvider(
      create: (context) => MovieListModel(),
      child: const MovieListWidget(),
    );
  }

  static Widget makeFavoriteScreen() {
    return const Center(
      child: Text(
        'Понравившиеся',
      ),
    );
  }
}

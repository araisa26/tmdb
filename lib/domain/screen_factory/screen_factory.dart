import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:themoviedb/domain/blocs/auth_bloc.dart';
import 'package:themoviedb/domain/blocs/movie_list_bloc.dart';
import 'package:themoviedb/ui/auth/auth_view_cubit.dart';
import 'package:themoviedb/ui/auth/auth_widget.dart';
import 'package:themoviedb/ui/loader_widget/loader_view_cubit.dart';
import 'package:themoviedb/ui/loader_widget/loader_widget.dart';
import 'package:themoviedb/ui/main_screen/main_screen_model.dart';
import 'package:themoviedb/ui/main_screen/main_screen_widget.dart';
import 'package:themoviedb/ui/movie_details/movie_details_model.dart';
import 'package:themoviedb/ui/movie_details/movie_detais_widget.dart';
import 'package:themoviedb/ui/movie_list/movie_list.dart';
import 'package:themoviedb/ui/movie_trailer/movie_trailer_widget.dart';

class ScreenFactory {
  AuthBloc? authB;
  Widget makeloader() {
    final authBloc = authB ?? AuthBloc(AuthProgressState());
    return BlocProvider<LoaderViewCubit>(
      create: (context) =>
          LoaderViewCubit(LoaderViewCubitState.unknown, authBloc),
      lazy: false,
      child: const LoaderWidget(),
    );
  }

  Widget makeAuth() {
    final authBloc = authB ?? AuthBloc(AuthProgressState());
    return BlocProvider<AuthViewCubit>(
      create: (context) {
        return AuthViewCubit(AuthScreenState(null), authBloc);
      },
      lazy: false,
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

  Widget makeMovieList() {
    return BlocProvider<MovieListBloc>(
      create: (context) {
        return MovieListBloc(context, MovieListState());
      },
      lazy: false,
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

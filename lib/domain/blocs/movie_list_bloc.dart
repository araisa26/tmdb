// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:themoviedb/domain/entity/movie.dart';
import 'package:themoviedb/domain/entity/movie_response.dart';
import 'package:themoviedb/services/date_services.dart';
import 'package:themoviedb/services/movie_services.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';

abstract class MovieListEvent {}

class MovieListToNextScreenEvent extends MovieListEvent {}

class MovieListSetupLocal extends MovieListEvent {
  final BuildContext context;

  MovieListSetupLocal(this.context);
}

class MovieListLoadMovieEvent extends MovieListEvent {
  MovieListState state;
  MovieListLoadMovieEvent({
    required this.state,
  });
}

class MovieListLoadReserEvent extends MovieListEvent {}

class MovieListSearchMovieEvent extends MovieListEvent {
  MovieListState state;
  MovieListSearchMovieEvent({
    required this.state,
  });
}

class MovieListState {
  String? searchText;
  List<Movie> movies = <Movie>[];
  int currentPage = 0;
  int totalPage = 1;
  var isLoadingProgress = false;
  String locale = '';
  Timer? searchTimer;

  @override
  bool operator ==(Object other) =>
      other is MovieListState &&
      runtimeType == other.runtimeType &&
      searchText == other.searchText &&
      movies == other.movies &&
      currentPage == other.currentPage &&
      totalPage == other.totalPage &&
      locale == other.locale;

  MovieListState copyWith({
    searchText,
    movies,
    currentPage,
    totalPage,
    isLoadingProgress,
    locale,
    searchTimer,
  }) {
    return MovieListState()
      ..searchText = searchText ?? this.searchText
      ..movies = movies ?? this.movies
      ..currentPage = currentPage ?? this.currentPage
      ..totalPage = totalPage ?? this.totalPage
      ..isLoadingProgress = isLoadingProgress ?? this.isLoadingProgress
      ..locale = locale ?? this.locale
      ..searchTimer = searchTimer ?? this.searchTimer;
  }
}

class MovieListBloc extends Bloc<MovieListEvent, MovieListState> {
  BuildContext context;
  MovieListBloc(this.context, MovieListState initialState)
      : super(initialState) {
    Future.microtask(
      () {
        on<MovieListEvent>((event, emit) async {
          if (event is MovieListSetupLocal) {
            await setupLocal(event.context);
          } else if (event is MovieListLoadMovieEvent) {
            emit(event.state);
          } else if (event is MovieListSearchMovieEvent) {
            emit(event.state);
          }
        }, transformer: sequential());
        add(MovieListSetupLocal(context));
      },
    );
  }

  Future<void> setupLocal(BuildContext context) async {
    final locale = Localizations.localeOf(context).toLanguageTag();
    if (locale == state.locale) return;
    state.locale = locale;
    DateConvert.locale = locale;
    await resetList();
  }

  Future<void> resetList() async {
    state.currentPage = 0;
    state.totalPage = 1;
    state.movies.clear();
    await loadCurrentPage();
  }

  Future<void> loadCurrentPage() async {
    if (state.isLoadingProgress || state.currentPage >= state.totalPage) return;
    state.isLoadingProgress = true;
    int nextPage = state.currentPage + 1;
    if (state.searchText != '' && state.searchText != null) {
      final PopularMovieResponse movieResponse =
          await MovieServices.searchPopualrMovies(
              state.searchText, nextPage, state.locale);

      final movies = List<Movie>.from(state.movies)
        ..addAll(movieResponse.movies);
      final newstate = state.copyWith(
          currentPage: movieResponse.page,
          totalPage: movieResponse.totalPages,
          movies: movies,
          isLoadingProgress: false);
      add(MovieListSearchMovieEvent(state: newstate));
    } else {
      final PopularMovieResponse movieResponse =
          await MovieServices.getPopularMovies(nextPage, state.locale);
      final movies = List<Movie>.from(state.movies)
        ..addAll(movieResponse.movies);
      final newstate = state.copyWith(
          currentPage: movieResponse.page,
          totalPage: movieResponse.totalPages,
          movies: movies,
          isLoadingProgress: false);
      add(MovieListLoadMovieEvent(state: newstate));
    }
  }

  void onMovieTap(BuildContext context, int index) {
    Navigator.of(context).pushNamed(MainNavigationRoutesName.movieDetails,
        arguments: state.movies[index].id);
  }

  Future<void> showMovieAtindex(int index) async {
    if (index < state.movies.length - 1) return;
    await loadCurrentPage();
  }

  Future<void> searchMovies(text) async {
    state.searchTimer?.cancel();
    state.searchTimer = Timer(const Duration(seconds: 1), () async {
      state.searchText = text;
      await resetList();
    });
  }
}

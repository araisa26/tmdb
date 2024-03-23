import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:themoviedb/domain/api_client.dart';
import 'package:themoviedb/domain/entity/movie.dart';
import 'package:themoviedb/domain/entity/movie_response.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';

class MovieListModel extends ChangeNotifier {
  String? searchText;
  final List<Movie> movies = <Movie>[];
  late DateFormat dateFormat;
  late int currentPage;
  late int totalPage;
  var isLoadingProgress = false;
  String _locale = '';
  Timer? searchTimer;
  String stringFromDate(DateTime? date) =>
      date != null ? dateFormat.format(date) : "";

  Future<void> setupLocal(BuildContext context) async {
    final locale = Localizations.localeOf(context).toLanguageTag();
    if (locale == _locale) return;
    _locale = locale;
    dateFormat = DateFormat.yMMMMd(locale);
    await resetList();
  }

  Future<void> resetList() async {
    currentPage = 0;
    totalPage = 1;
    movies.clear();
    await loadCurrentPage();
  }

  Future<PopularMovieResponse> loadMovies(int page, String locale) async {
    if (searchText != '' && searchText != null) {
      return await searchPopularMovies(searchText, locale, page);
    } else {
      return await getPopulatMovie(page, locale);
    }
  }

  Future<void> loadCurrentPage() async {
    if (isLoadingProgress || currentPage >= totalPage) return;
    isLoadingProgress = true;
    int nextPage = currentPage + 1;
    final movieResponse = await loadMovies(nextPage, _locale);
    currentPage = movieResponse.page;
    totalPage = movieResponse.total_pages;
    movies.addAll(movieResponse.movies);
    isLoadingProgress = false;
    notifyListeners();
  }

  void onMovieTap(BuildContext context, int index) {
    final _movieId = movies[index].id;
    Navigator.pushNamed(context, MainNavigationRoutesName.movieDetails,
        arguments: _movieId);
  }

  Future<void> showMovieAtindex(int index) async {
    if (index < movies.length - 1) return;
    await loadCurrentPage();
  }

  Future<void> searchMovies(text) async {
    searchTimer?.cancel();
    searchTimer = Timer(Duration(seconds: 1), () async {
      searchText = text;
      await resetList();
    });
  }
}

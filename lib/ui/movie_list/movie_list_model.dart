import 'dart:async';
import 'package:flutter/material.dart';
import 'package:themoviedb/domain/entity/movie.dart';
import 'package:themoviedb/services/date_services.dart';
import 'package:themoviedb/services/movie_services.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';

class MovieListModel extends ChangeNotifier {
  String? searchText;
  final List<Movie> movies = <Movie>[];
  late int currentPage;
  late int totalPage;
  var isLoadingProgress = false;
  String _locale = '';
  Timer? searchTimer;

  Future<void> setupLocal(BuildContext context) async {
    final locale = Localizations.localeOf(context).toLanguageTag();
    if (locale == _locale) return;
    _locale = locale;
    DateConvert.locale = locale;
    await resetList();
  }

  Future<void> resetList() async {
    currentPage = 0;
    totalPage = 1;
    movies.clear();
    await loadCurrentPage();
  }

  Future<void> loadCurrentPage() async {
    if (isLoadingProgress || currentPage >= totalPage) return;
    isLoadingProgress = true;
    int nextPage = currentPage + 1;
    final movieResponse = (searchText != '' && searchText != null)
        ? await MovieServices.searchPopualrMovies(searchText, nextPage, _locale)
        : await MovieServices.getPopularMovies(nextPage, _locale);
    currentPage = movieResponse.page;
    totalPage = movieResponse.totalPages;
    movies.addAll(movieResponse.movies);
    isLoadingProgress = false;
    notifyListeners();
  }

  void onMovieTap(BuildContext context, int index) {
    Navigator.of(context).pushNamed(MainNavigationRoutesName.movieDetails,
        arguments: movies[index].id);
  }

  Future<void> showMovieAtindex(int index) async {
    if (index < movies.length - 1) return;
    await loadCurrentPage();
  }

  Future<void> searchMovies(text) async {
    searchTimer?.cancel();
    searchTimer = Timer(const Duration(seconds: 1), () async {
      searchText = text;
      await resetList();
    });
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:themoviedb/domain/api_client.dart';
import 'package:themoviedb/domain/data_providers/session_data_provider.dart';
import 'package:themoviedb/domain/entity/movie_details.dart';

class MovieDetailsModel extends ChangeNotifier {
  final icon = Icon(Icons.favorite);
  final int movieId;
  final String imgUrlBackdropth =
      'https://media.themoviedb.org/t/p/w1000_and_h450_multi_faces';
  final String imgUrlPosterPath =
      'https://media.themoviedb.org/t/p/w220_and_h330_multi_faces';
  bool videoIsPlaying = false;
  MovieDetailsModel(
    this.movieId,
  );
  MovieDetails? movieDetails;
  String _locale = '';
  late DateFormat dateFormat;
  bool? isFavorite;

  String stringFromDate(DateTime? date) =>
      date != null ? dateFormat.format(date) : "";

  Future<void> setupLocal(BuildContext context) async {
    final locale = Localizations.localeOf(context).toLanguageTag();
    if (locale == _locale) return;
    _locale = locale;
    dateFormat = DateFormat.yMMMMd(locale);
    movieDetails = await getMovieDetails(movieId, locale);
    await checkIsFavoriteMovie(context);
    notifyListeners();
  }

  Future<void> checkIsFavoriteMovie(context) async {
    final sessionProvider = SessionDataProvider();
    final response = await accountStates(
        movieId, await sessionProvider.getSessionId(), context);
    response?.favorite != null ? isFavorite = response?.favorite : null;
    notifyListeners();
  }

  Future<void> addOrDeleteFavoriteMovie() async {
    final sessionProvider = SessionDataProvider();
    isFavorite = !isFavorite!;
    await postFavoriteMovie(movieId, await sessionProvider.getSessionId(),
        isFavorite, await sessionProvider.getAccountId());
    notifyListeners();
  }
}

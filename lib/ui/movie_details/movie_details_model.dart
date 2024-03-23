import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:themoviedb/configuration/configuration.dart';
import 'package:themoviedb/domain/entity/movie_details.dart';
import 'package:themoviedb/domain/entity/movie_details_videos.dart';
import 'package:themoviedb/services/date_services.dart';
import 'package:themoviedb/services/movie_services.dart';

class MovieDetailsModel extends ChangeNotifier {
  MovieDetailsModel(this.movieId);
  final int movieId;
  bool videoIsPlaying = false;
  MovieDetails? movieDetails;
  String _locale = '';
  late DateFormat dateFormat;
  bool isFavorite = false;
  String? trailerKey;
  List<MovieVideoResult> videoList = [];

  Future<void> setupLocal(BuildContext context) async {
    final locale = Localizations.localeOf(context).toLanguageTag();
    if (locale == _locale) return;
    _locale = locale;
    DateConvert.locale = locale;
    movieDetails = await MovieServices.getMoviedetails(movieId, _locale);
    isFavorite = await MovieServices.checkIsFavoriteMovie(movieId, context);
    getVideo();
    notifyListeners();
  }

  Future<void> addOrDeleteFavoriteMovie() async {
    isFavorite = !isFavorite;
    await MovieServices.addOrDeleteFavoriteMovie(
        movieId, MediaType.movie, isFavorite);
    notifyListeners();
  }

  void getVideo() {
    movieDetails?.videos.results.forEach(
      (element) {
        if (element.site.contains('YouTube') == true &&
            element.type.contains('Trailer')) {
          videoList.add(element);
        }
      },
    );
    videoList.isNotEmpty == true
        ? trailerKey = videoList.first.key
        : trailerKey = null;
  }
}

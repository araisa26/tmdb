import 'package:flutter/material.dart';
import 'package:themoviedb/configuration/configuration.dart';
import 'package:themoviedb/domain/api_client/account_api_client.dart';
import 'package:themoviedb/domain/api_client/movie_api_client.dart';
import 'package:themoviedb/domain/data_providers/session_data_provider.dart';

abstract class MovieServices {
  static Future getPopularMovies(page, locale) async {
    return await MovieApiClient.getPopulatMovie(page, locale);
  }

  static Future searchPopualrMovies(searchText, page, locale) async {
    return await MovieApiClient.searchPopularMovies(searchText, locale, page);
  }

  static Future getMoviedetails(movieId, locale) async {
    return await MovieApiClient.movieDetails(movieId, locale);
  }

  static Future<bool> checkIsFavoriteMovie(
      movieId, BuildContext context) async {
    final response = await AccountApiClient.accountState(
        movieId, await SessionDataProvider.getSessionId(), context);
    return response?.favorite != null ? response!.favorite : false;
  }

  static Future addOrDeleteFavoriteMovie(movieId, mediaType, isFavorite) async {
    await AccountApiClient.favoriteMovie(
        movieId,
        await SessionDataProvider.getSessionId(),
        MediaType.movie,
        isFavorite,
        await SessionDataProvider.getAccountId());
  }
}

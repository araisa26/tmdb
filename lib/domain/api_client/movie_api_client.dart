import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:themoviedb/configuration/configuration.dart';
import 'package:themoviedb/domain/entity/movie_details.dart';
import 'package:themoviedb/domain/entity/movie_response.dart';

abstract class MovieApiClient {
  static Future<PopularMovieResponse> getPopulatMovie(int id, loc) async {
    final urlPopularMovie = Uri.parse(
      "https://api.themoviedb.org/3/movie/popular?language=$loc&page=$id",
    );
    final requestPopularMovie =
        await http.get(urlPopularMovie, headers: Configuration.headers);
    final Map<String, dynamic> responsePopularMovie =
        jsonDecode(requestPopularMovie.body);
    return PopularMovieResponse.fromJson(responsePopularMovie);
  }

  static Future<PopularMovieResponse> searchPopularMovies(
      text, loc, pageId) async {
    final urlSearchPopularMovie = Uri.parse(
      "https://api.themoviedb.org/3/search/movie?query=$text&include_adult=false&language=$loc&page=$pageId",
    );
    final requestSearchPopularMovie =
        await http.get(urlSearchPopularMovie, headers: Configuration.headers);
    final Map<String, dynamic> responseSearchPopularMovie =
        jsonDecode(requestSearchPopularMovie.body);
    return PopularMovieResponse.fromJson(responseSearchPopularMovie);
  }

  static Future<MovieDetails> movieDetails(int id, String loc) async {
    final urlMovieDetails = Uri.parse(
      "https://api.themoviedb.org/3/movie/$id?append_to_response=credits,videos&language=$loc",
    );
    final requestMovieDetail =
        await http.get(urlMovieDetails, headers: Configuration.headers);
    final Map<String, dynamic> responseMovieDetails =
        jsonDecode(requestMovieDetail.body);
    return MovieDetails.fromJson(responseMovieDetails);
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:themoviedb/domain/data_providers/session_data_provider.dart';
import 'package:themoviedb/domain/entity/account_states.dart';
import 'package:themoviedb/domain/entity/movie_details.dart';
import 'package:themoviedb/domain/entity/movie_response.dart';
import 'package:themoviedb/library/provider.dart';
import 'package:themoviedb/ui/my_app/my_app_model.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';

abstract class ApiClient {
  static const _accesToken =
      "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxM2ZhNWRmMGUyYjIxMDNkODI4YjJiZmM0ZDUzYzRhNSIsInN1YiI6IjY1NWRiOWViZTk0MmVlMDEzOGM1ZjU3YyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.sJCv9RLozLrBei5RDmx5rqum8kGioZZJsGXDXHfP6vo";
  static const _headers = {
    'Authorization': '${ApiClient._accesToken}',
    "Content-Type": "application/json"
  };
  static String imageUrl(String url, String path) {
    return url + path;
  }
}

Future<String?> makeToken() async {
  final urlMakeToken =
      Uri.parse('https://api.themoviedb.org/3/authentication/token/new');
  final responseRequestToken =
      await http.get(urlMakeToken, headers: ApiClient._headers);
  final requestTokenDecode = jsonDecode(responseRequestToken.body);
  switch (requestTokenDecode['status_code']) {
    case (34):
      throw "Неверный API";
  }
  return requestTokenDecode['request_token'];
}

Future<String?> validateToken(login, password) async {
  final urlValidateToken = Uri.parse(
      'https://api.themoviedb.org/3/authentication/token/validate_with_login');
  String? validateToken = await makeToken().then((value) => value);
  final validTokenBody = jsonEncode({
    'username': '$login',
    'password': '$password',
    'request_token': '$validateToken',
  });
  final responseValidateToken = await http.post(urlValidateToken,
      headers: ApiClient._headers, body: validTokenBody);
  final validateTokenDecode = jsonDecode(responseValidateToken.body);
  switch (validateTokenDecode['status_code']) {
    case (34):
      throw "Неверный API";
    case (30):
      throw "Неверный логин или пароль";
  }
  return validateTokenDecode['request_token'];
}

Future<String?>? makeSessionId(login, password) async {
  final urlValidateToken =
      Uri.parse('https://api.themoviedb.org/3/authentication/session/new');
  String? token = await validateToken(login, password).then((value) => value);
  final body = jsonEncode({
    'request_token': '$token',
  });

  final sessionId = await http.post(urlValidateToken,
      headers: ApiClient._headers, body: body);
  final sessionIdDecode = jsonDecode(sessionId.body);
  return sessionIdDecode['session_id'];
}

Future<int> getAccountId(String? sessionId) async {
  final urlAccountId = Uri.parse(
      'https://api.themoviedb.org/3/account/1?session_id=${sessionId}');
  final requestAccountId =
      await http.get(urlAccountId, headers: ApiClient._headers);
  final Map<String, dynamic> responseAccountIdBody =
      jsonDecode(requestAccountId.body);
  return responseAccountIdBody['id'];
}

Future<PopularMovieResponse> getPopulatMovie(int id, loc) async {
  final urlMovieId = Uri.parse(
    "https://api.themoviedb.org/3/movie/popular?language=${loc}&page=${id}",
  );
  final requestPopularMovie =
      await http.get(urlMovieId, headers: ApiClient._headers);
  final Map<String, dynamic> responsePopularMovieBody =
      jsonDecode(requestPopularMovie.body);
  PopularMovieResponse responsePopularMovie =
      PopularMovieResponse.fromJson(responsePopularMovieBody);
  return responsePopularMovie;
}

Future<PopularMovieResponse> searchPopularMovies(text, loc, id) async {
  final urlMovieId = Uri.parse(
    "https://api.themoviedb.org/3/search/movie?query=${text}&include_adult=false&language=${loc}&page=${id}",
  );
  final requestPopularMovie =
      await http.get(urlMovieId, headers: ApiClient._headers);
  final Map<String, dynamic> responsePopularMovieBody =
      jsonDecode(requestPopularMovie.body);
  PopularMovieResponse responsePopularMovie =
      PopularMovieResponse.fromJson(responsePopularMovieBody);
  return responsePopularMovie;
}

Future<MovieDetails> getMovieDetails(int id, String loc) async {
  final urlMovieId = Uri.parse(
    "https://api.themoviedb.org/3/movie/${id}?append_to_response=credits,videos&language=${loc}",
  );
  final requestMovieDetail =
      await http.get(urlMovieId, headers: ApiClient._headers);
  final Map<String, dynamic> responseMovieDetailsBody =
      jsonDecode(requestMovieDetail.body);
  MovieDetails responseMovieDetail =
      MovieDetails.fromJson(responseMovieDetailsBody);
  return responseMovieDetail;
}

Future<void> postFavoriteMovie(
    int id, String? sessionId, bool? isFavorite, String? accountId) async {
  bool? addOrDelete = isFavorite;
  final urlMovieId = Uri.parse(
    "https://api.themoviedb.org/3/account/${int.tryParse(accountId!)}/favorite?session_id=${sessionId}",
  );

  final body = jsonEncode(<String, dynamic>{
    "media_type": "movie",
    "media_id": id,
    "favorite": addOrDelete
  });
  await http.post(urlMovieId, headers: ApiClient._headers, body: body);
}

Future<AccountStates?> accountStates(
    int id, String? sessionId, BuildContext context) async {
  final urlMovieId = Uri.parse(
    "https://api.themoviedb.org/3/movie/${id}/account_states?session_id=${sessionId}",
  );
  final requestAccountStates =
      await http.get(urlMovieId, headers: ApiClient._headers);
  final Map<String, dynamic> responseAccountStatesBody =
      jsonDecode(requestAccountStates.body);
  AccountStates? responseAccountStates;
  if (responseAccountStatesBody['status_message'] ==
      'Authentication failed: You do not have permissions to access the service.') {
    await resetSession(context);
  } else {
    responseAccountStates = AccountStates?.fromJson(responseAccountStatesBody);
  }
  return responseAccountStates;
}

Future<void> resetSession(BuildContext context) async {
  final sessionProvier = SessionDataProvider();
  await sessionProvier.setSessonId(null);
  await sessionProvier.setAccountId(null);
  context.getInheritedWidgetOfExactType<Provider<MyAppModel>>()?.model.isAuth =
      false;
  Navigator.of(context).restorablePushNamedAndRemoveUntil(
      MainNavigationRoutesName.auth, (route) => false);
}

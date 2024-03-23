import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:themoviedb/configuration/configuration.dart';

abstract class AuthApiClient {
  static Future<String?> makeToken() async {
    final urlToken =
        Uri.parse('https://api.themoviedb.org/3/authentication/token/new');
    final requestToken =
        await http.get(urlToken, headers: Configuration.headers);
    final responseMakeToken = jsonDecode(requestToken.body);
    switch (responseMakeToken['status_code']) {
      //обработка ошибок написана для примера, поэтому не дополнена на все случаи
      case (34):
        throw "Неверный API";
    }
    return responseMakeToken['request_token'];
  }

  static Future<String?> validateToken(login, password) async {
    final urlValidToken = Uri.parse(
        'https://api.themoviedb.org/3/authentication/token/validate_with_login');
    String? responseMakeToken = await makeToken();
    final validTokenBody = jsonEncode({
      'username': '$login',
      'password': '$password',
      'request_token': '$responseMakeToken',
    });
    final requestValidToken = await http.post(urlValidToken,
        headers: Configuration.headers, body: validTokenBody);
    final responseValidToken = jsonDecode(requestValidToken.body);
    switch (responseValidToken['status_code']) {
      //обработка ошибок написана для примера, поэтому не дополнена на все случаи
      case (34):
        throw "Неверный API";
      case (30):
        throw "Неверный логин или пароль";
    }
    return responseValidToken['request_token'];
  }

  static Future<String?> makeSessionId(login, password) async {
    final urlSessionId =
        Uri.parse('https://api.themoviedb.org/3/authentication/session/new');
    String? responseValidToken = await validateToken(login, password);
    final body = jsonEncode({
      'request_token': '$responseValidToken',
    });

    final sessionId = await http.post(urlSessionId,
        headers: Configuration.headers, body: body);
    final sessionIdDecode = jsonDecode(sessionId.body);
    return sessionIdDecode['session_id'];
  }

  static Future<int?> getAccountId(String? sessionId) async {
    final urlAccountId = Uri.parse(
        'https://api.themoviedb.org/3/account/1?session_id=$sessionId');
    final requestAccountId =
        await http.get(urlAccountId, headers: Configuration.headers);
    final Map<String, dynamic> responseAccountIdBody =
        jsonDecode(requestAccountId.body);
    return responseAccountIdBody['id'];
  }
}

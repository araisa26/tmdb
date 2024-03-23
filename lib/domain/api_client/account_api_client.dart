import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:themoviedb/configuration/configuration.dart';
import 'package:themoviedb/services/auth_services.dart';
import 'package:themoviedb/domain/entity/account_states.dart';

abstract class AccountApiClient {
  static Future<void> favoriteMovie(int id, String? sessionId,
      MediaType mediaType, bool isFavorite, String? accountId) async {
    final urlFavoriteMovie = Uri.parse(
      "https://api.themoviedb.org/3/account/${int.tryParse(accountId!)}/favorite?session_id=$sessionId",
    );

    final body = jsonEncode(<String, dynamic>{
      "media_type": mediaType.asString(),
      "media_id": id,
      "favorite": isFavorite
    });
    await http.post(urlFavoriteMovie,
        headers: Configuration.headers, body: body);
  }

  static Future<AccountStates?> accountState(
      int id, String? sessionId, BuildContext context) async {
    final urlAccountState = Uri.parse(
      "https://api.themoviedb.org/3/movie/$id/account_states?session_id=$sessionId",
    );
    final requestAccountState =
        await http.get(urlAccountState, headers: Configuration.headers);
    final Map<String, dynamic> responseAccountState =
        jsonDecode(requestAccountState.body);
    switch (responseAccountState['status_message']) {
      //обработка ошибок написана для примера, поэтому не дополнена на все случаи
      case 'Authentication failed: You do not have permissions to access the service.':
        await AuthServices.resetSession(context);
        return null;
    }
    return AccountStates?.fromJson(responseAccountState);
  }
}

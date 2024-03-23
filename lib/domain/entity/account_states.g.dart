// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_states.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountStates _$AccountStatesFromJson(Map<String, dynamic> json) =>
    AccountStates(
      id: json['id'] as int,
      favorite: json['favorite'] as bool,
      rated: json['rated'] as bool,
      watchlist: json['watchlist'] as bool,
    );

Map<String, dynamic> _$AccountStatesToJson(AccountStates instance) =>
    <String, dynamic>{
      'id': instance.id,
      'favorite': instance.favorite,
      'rated': instance.rated,
      'watchlist': instance.watchlist,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PopularMovieResponse _$PopularMovieResponseFromJson(
        Map<String, dynamic> json) =>
    PopularMovieResponse(
      page: json['page'] as int,
      movies: (json['results'] as List<dynamic>)
          .map((e) => Movie.fromJson(e as Map<String, dynamic>))
          .toList(),
      total_pages: json['total_pages'] as int,
      total_results: json['total_results'] as int,
    );

Map<String, dynamic> _$PopularMovieResponseToJson(
        PopularMovieResponse instance) =>
    <String, dynamic>{
      'page': instance.page,
      'results': instance.movies.map((e) => e.toJson()).toList(),
      'total_pages': instance.total_pages,
      'total_results': instance.total_results,
    };

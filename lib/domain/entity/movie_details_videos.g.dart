// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_details_videos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieDetailsVideos _$MovieDetailsVideosFromJson(Map<String, dynamic> json) =>
    MovieDetailsVideos(
      results: (json['results'] as List<dynamic>)
          .map((e) => MovieVideoResult.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MovieDetailsVideosToJson(MovieDetailsVideos instance) =>
    <String, dynamic>{
      'results': instance.results.map((e) => e.toJson()).toList(),
    };

MovieVideoResult _$MovieVideoResultFromJson(Map<String, dynamic> json) =>
    MovieVideoResult(
      iso639: json['iso_639_1'] as String,
      iso3166: json['iso_3166_1'] as String,
      name: json['name'] as String,
      key: json['key'] as String,
      site: json['site'] as String,
      size: json['size'] as int,
      type: json['type'] as String,
      official: json['official'] as bool,
      publishedAt: json['published_at'] as String,
      id: json['id'] as String,
    );

Map<String, dynamic> _$MovieVideoResultToJson(MovieVideoResult instance) =>
    <String, dynamic>{
      'iso_639_1': instance.iso639,
      'iso_3166_1': instance.iso3166,
      'name': instance.name,
      'key': instance.key,
      'site': instance.site,
      'size': instance.size,
      'type': instance.type,
      'official': instance.official,
      'published_at': instance.publishedAt,
      'id': instance.id,
    };

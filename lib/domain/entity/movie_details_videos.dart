import 'package:json_annotation/json_annotation.dart';

part 'movie_details_videos.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class MovieDetailsVideos {
  final List<MovieVideoResult> results;
  MovieDetailsVideos({
    required this.results,
  });
  factory MovieDetailsVideos.fromJson(Map<String, dynamic> json) =>
      _$MovieDetailsVideosFromJson(json);

  Map<String, dynamic> toJson() => _$MovieDetailsVideosToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class MovieVideoResult {
  @JsonKey(name: 'iso_639_1')
  final String iso639;
  @JsonKey(name: 'iso_3166_1')
  final String iso3166;
  final String name;
  final String key;
  final String site;
  final int size;
  final String type;
  final bool official;
  final String publishedAt;
  final String id;
  MovieVideoResult({
    required this.iso639,
    required this.iso3166,
    required this.name,
    required this.key,
    required this.site,
    required this.size,
    required this.type,
    required this.official,
    required this.publishedAt,
    required this.id,
  });
  factory MovieVideoResult.fromJson(Map<String, dynamic> json) =>
      _$MovieVideoResultFromJson(json);

  Map<String, dynamic> toJson() => _$MovieVideoResultToJson(this);
}

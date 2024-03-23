import 'package:json_annotation/json_annotation.dart';
import 'package:themoviedb/domain/entity/movie.dart';

part 'movie_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class PopularMovieResponse {
  int page;
  @JsonKey(
    name: 'results',
  )
  List<Movie> movies;
  int totalPages;
  int totalResults;
  PopularMovieResponse(
      {required this.page,
      required this.movies,
      required this.totalPages,
      required this.totalResults});

  factory PopularMovieResponse.fromJson(Map<String, dynamic> json) =>
      _$PopularMovieResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PopularMovieResponseToJson(this);
}

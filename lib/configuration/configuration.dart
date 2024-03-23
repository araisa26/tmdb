abstract class Configuration {
  static const accesToken =
      "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxM2ZhNWRmMGUyYjIxMDNkODI4YjJiZmM0ZDUzYzRhNSIsInN1YiI6IjY1NWRiOWViZTk0MmVlMDEzOGM1ZjU3YyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.sJCv9RLozLrBei5RDmx5rqum8kGioZZJsGXDXHfP6vo";
  static const headers = {
    'Authorization': accesToken,
    "Content-Type": "application/json"
  };
}

enum MediaType { movie, tv }

extension MediaTypeAsString on MediaType {
  String asString() {
    switch (this) {
      case MediaType.movie:
        return 'movie';
      case MediaType.tv:
        return 'tv';
    }
  }
}

abstract class ImageUrl {
  static const imgMovieList = 'https://image.tmdb.org/t/p/w260_and_h390_bestv2';
  static const imgUrlBackdropthMovieDetails =
      'https://media.themoviedb.org/t/p/w1000_and_h450_multi_faces';
  static const imgUrlPosterPathMovieDetails =
      'https://media.themoviedb.org/t/p/w220_and_h330_multi_faces';
  static const imgUrlActorPathMovieDetails =
      'https://media.themoviedb.org/t/p/w120_and_h133_face';
}

import 'package:flutter/material.dart';
import 'package:themoviedb/domain/api_client.dart';
import 'package:themoviedb/library/provider.dart';
import 'package:themoviedb/ui/movie_list/movie_list_model.dart';

class MovieListWidget extends StatelessWidget {
  const MovieListWidget();
  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<MovieListModel>(context);
    if (model == null) return const SizedBox.shrink();
    return Stack(children: [
      ListView.builder(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: EdgeInsets.only(top: 70),
        itemCount: model.movies.length,
        itemExtent: 163,
        itemBuilder: (BuildContext context, int index) {
          model.showMovieAtindex(index);
          final movie = model.movies[index];
          String imgUrl = 'https://image.tmdb.org/t/p/w260_and_h390_bestv2';
          final posterPath = movie.posterPath;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Stack(children: [
              Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  border: Border.all(
                    color: Colors.black.withOpacity(0.2),
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: Row(
                  children: [
                    AspectRatio(
                      aspectRatio: 260 / 390,
                      child: posterPath != null
                          ? Image.network(
                              ApiClient.imageUrl(imgUrl, posterPath))
                          : SizedBox.shrink(),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            movie.title,
                            style: TextStyle(fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            model.stringFromDate(movie.releaseDate),
                            style: TextStyle(color: Colors.grey),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            movie.overview,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    )
                  ],
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => model.onMovieTap(context, index),
                  borderRadius: BorderRadius.circular(10),
                ),
              )
            ]),
          );
        },
      ),
      Padding(
        padding: EdgeInsets.all(10),
        child: TextField(
          onChanged: (text) {
            model.searchMovies(text);
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white.withAlpha(235),
            border: OutlineInputBorder(),
            label: Text('Поиск'),
          ),
        ),
      ),
    ]);
  }
}

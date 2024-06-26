import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:themoviedb/configuration/configuration.dart';
import 'package:themoviedb/domain/api_client/image_loader.dart';
import 'package:themoviedb/domain/blocs/movie_list_bloc.dart';
import 'package:themoviedb/services/date_services.dart';

class MovieListWidget extends StatefulWidget {
  const MovieListWidget({super.key});
  @override
  State<StatefulWidget> createState() => MovieListWidgetState();
}

class MovieListWidgetState extends State<MovieListWidget> {
  @override
  void didChangeDependencies() {
    context.watch<MovieListBloc>().setupLocal(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<MovieListBloc>();

    return BlocListener<MovieListBloc, MovieListState>(
        listenWhen: (prev, current) {
          return current == prev;
        },
        listener: (context, state) {},
        child: Stack(children: [
          ListView.builder(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.only(top: 70),
            itemCount: bloc.state.movies.length,
            itemExtent: 163,
            itemBuilder: (BuildContext context, int index) {
              bloc.showMovieAtindex(index);
              final movie = bloc.state.movies[index];

              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                          child: movie.posterPath != null
                              ? Image.network(ImageLoader.imageUrl(
                                  ImageUrl.imgMovieList,
                                  movie.posterPath as String))
                              : const SizedBox.shrink(),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                movie.title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                DateConvert.stringFromDate(movie.releaseDate),
                                style: const TextStyle(color: Colors.grey),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(
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
                        const SizedBox(
                          width: 10,
                        )
                      ],
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => bloc.onMovieTap(context, index),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  )
                ]),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              onChanged: (text) {
                bloc.searchMovies(text);
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white.withAlpha(235),
                border: const OutlineInputBorder(),
                label: const Text('Поиск'),
              ),
            ),
          ),
        ]));
  }
}

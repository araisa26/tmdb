import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:themoviedb/configuration/configuration.dart';
import 'package:themoviedb/domain/api_client/image_loader.dart';
import 'package:themoviedb/ui/movie_details/movie_details_model.dart';

class MovieDetailsMainScreenCastWidget extends StatelessWidget {
  const MovieDetailsMainScreenCastWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<MovieDetailsModel>();
    return ColoredBox(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              'В главных ролях',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
          ),
          SizedBox(
            height: 300,
            child: Scrollbar(
              child: ListView.builder(
                itemCount: model.movieDetails?.credits.cast.length,
                itemExtent: 120,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DecoratedBox(
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
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          clipBehavior: Clip.hardEdge,
                          child: Column(
                            children: [
                              model.movieDetails?.credits.cast[index]
                                          .profilePath !=
                                      null
                                  ? Image.network(ImageLoader.imageUrl(
                                      ImageUrl.imgUrlActorPathMovieDetails,
                                      model.movieDetails!.credits.cast[index]
                                          .profilePath as String))
                                  : const SizedBox.shrink(),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      model.movieDetails?.credits.cast[index]
                                              .name ??
                                          '',
                                      maxLines: 2,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w800),
                                    ),
                                    const SizedBox(
                                      height: 7,
                                    ),
                                    Text(
                                      model.movieDetails?.credits.cast[index]
                                              .character ??
                                          '',
                                      maxLines: 4,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ));
                },
              ),
            ),
          ),
          TextButton(
              onPressed: () {},
              child: const Text('Полный актёрский и съёмочный состав'))
        ],
      ),
    );
  }
}

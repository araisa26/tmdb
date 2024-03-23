import 'package:flutter/material.dart';
import 'package:themoviedb/domain/api_client.dart';
import 'package:themoviedb/library/provider.dart';
import 'package:themoviedb/ui/movie_details/movie_details_model.dart';

class MovieDetailsMainScreenCastWidget extends StatelessWidget {
  const MovieDetailsMainScreenCastWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<MovieDetailsModel>(context);
    final cast = model?.movieDetails?.credits.cast;
    final imgUrlPosterPath =
        'https://media.themoviedb.org/t/p/w120_and_h133_face';

    return ColoredBox(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              'В главных ролях',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
          ),
          SizedBox(
            height: 300,
            child: Scrollbar(
              child: ListView.builder(
                itemCount: cast?.length,
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
                              cast?[index].profilePath != null
                                  ? Image.network(ApiClient.imageUrl(
                                      imgUrlPosterPath,
                                      cast![index].profilePath!))
                                  : SizedBox.shrink(),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      cast?[index].name ?? '',
                                      maxLines: 2,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800),
                                    ),
                                    SizedBox(
                                      height: 7,
                                    ),
                                    Text(
                                      cast?[index].character ?? '',
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
              child: Text('Полный актёрский и съёмочный состав'))
        ],
      ),
    );
  }
}

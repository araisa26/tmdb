import 'package:flutter/material.dart';
import 'package:themoviedb/domain/api_client.dart';
import 'package:themoviedb/domain/entity/movie_details_videos.dart';
import 'package:themoviedb/library/provider.dart';
import 'package:themoviedb/ui/elements/radial_percent_widget.dart';
import 'package:themoviedb/ui/movie_details/movie_details_model.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';

class MovieDetailsMainInfoWidget extends StatelessWidget {
  const MovieDetailsMainInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TopPosterWidget(),
          Padding(
            padding: const EdgeInsets.all(20),
            child: _MovieNameWidget(),
          ),
          _ScoreWidget(),
          _SummeryWidget(),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: _OverviewWidget(),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: _DescriptionWidget(),
          ),
          _PeopleWidget(),
        ],
      ),
    ]);
  }
}

class _TopPosterWidget extends StatelessWidget {
  const _TopPosterWidget({super.key});
  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<MovieDetailsModel>(context);
    final backdropPath = model?.movieDetails?.backdropPath;
    final posterPath = model?.movieDetails?.posterPath;
    final String imgUrlBackdropth =
        'https://media.themoviedb.org/t/p/w1000_and_h450_multi_faces';
    final String imgUrlPosterPath =
        'https://media.themoviedb.org/t/p/w220_and_h330_face';

    return AspectRatio(
      aspectRatio: 430 / 193.5,
      child: Stack(
        children: [
          backdropPath != null
              ? Image.network(
                  ApiClient.imageUrl(imgUrlBackdropth, backdropPath))
              : SizedBox.shrink(),
          Positioned(
            top: 20,
            left: 20,
            bottom: 20,
            child: posterPath != null
                ? Image.network(
                    ApiClient.imageUrl(imgUrlPosterPath, posterPath))
                : SizedBox.shrink(),
          ),
          Positioned(
              top: 5,
              right: 5,
              child: IconButton(
                onPressed: () {
                  model?.addOrDeleteFavoriteMovie();
                },
                icon: model?.isFavorite == true
                    ? Icon(
                        Icons.favorite,
                        color: Colors.red,
                      )
                    : Icon(
                        Icons.favorite_border,
                        color: Colors.red,
                      ),
              )),
        ],
      ),
    );
  }
}

class _MovieNameWidget extends StatelessWidget {
  const _MovieNameWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<MovieDetailsModel>(context);
    final title = model?.movieDetails?.title;
    String? year = model?.movieDetails?.releaseDate?.year.toString();
    year = year != null ? ' (${year})' : '';
    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        maxLines: 3,
        text: TextSpan(children: [
          TextSpan(
            text: title,
            style: TextStyle(
                fontWeight: FontWeight.w600, fontSize: 21, color: Colors.white),
          ),
          TextSpan(
            text: year,
            style: TextStyle(
                fontWeight: FontWeight.w400, fontSize: 16, color: Colors.grey),
          ),
        ]),
      ),
    );
  }
}

class _ScoreWidget extends StatelessWidget {
  const _ScoreWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final movieDetails =
        NotifierProvider.watch<MovieDetailsModel>(context)?.movieDetails;
    double voteAverage = movieDetails?.voteAverage ?? 0;

    List<MovieVideoResult> videosList = [];
    movieDetails?.videos.results.forEach(
      (element) {
        if (element.site.contains('YouTube') == true &&
            element.type.contains('Trailer')) {
          videosList.add(element);
        }
      },
    );
    String? trailerKey;
    videosList.isNotEmpty == true
        ? trailerKey = videosList.first.key
        : trailerKey = null;
    voteAverage = voteAverage * 10;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () {},
          child: Row(
            children: [
              SizedBox(
                width: 40,
                height: 40,
                child: RadialPercentWidget(
                  percent: voteAverage / 100,
                  fillColor: const Color.fromARGB(255, 10, 23, 25),
                  lineColor: const Color.fromARGB(255, 37, 203, 103),
                  freeColor: const Color.fromARGB(255, 25, 54, 31),
                  lineWidth: 3,
                  child: Text(voteAverage.toStringAsFixed(0)),
                ),
              ),
              const SizedBox(width: 10),
              const Text('User Score'),
            ],
          ),
        ),
        trailerKey != null
            ? Container(width: 1, height: 15, color: Colors.grey)
            : SizedBox.shrink(),
        trailerKey != null
            ? TextButton.icon(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                      MainNavigationRoutesName.movieTrailer,
                      arguments: trailerKey);
                },
                icon: const Icon(Icons.play_arrow),
                label: Text('Play Trailer'),
              )
            : SizedBox.shrink(),
      ],
    );
  }
}

class _SummeryWidget extends StatelessWidget {
  const _SummeryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<MovieDetailsModel>(context);
    if (model == null) return SizedBox.shrink();
    late final releaseDate;
    if (model.movieDetails?.releaseDate != null) {
      releaseDate = model.stringFromDate(model.movieDetails?.releaseDate);
    }
    late final productCountry =
        model.movieDetails?.productionCountries?.first.iso;

    int hours = 0;
    int minutes = 0;
    void runTime() {
      if (model.movieDetails?.runtime != null) {
        hours = model.movieDetails!.runtime! ~/ 60;
        minutes = model.movieDetails!.runtime! - hours * 60;
      }
      ;
    }

    runTime();

    List genresList = <String>[];
    model.movieDetails?.genres.forEach((element) {
      genresList.add(element.name);
    });

    String genresString = genresList.join(', ');
    return ColoredBox(
      color: Color.fromARGB(26, 11, 10, 1),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Text(
          '${releaseDate} (${productCountry}) ${hours}h ${minutes}m, ${genresString}',
          maxLines: 3,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w400, fontSize: 16),
        ),
      ),
    );
  }
}

class _OverviewWidget extends StatelessWidget {
  const _OverviewWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      'Обзор',
      style: TextStyle(
          color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16),
    );
  }
}

class _DescriptionWidget extends StatelessWidget {
  const _DescriptionWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<MovieDetailsModel>(context);
    model == null ? SizedBox.shrink() : model;
    String? overview = model?.movieDetails?.overview;
    return Text(
      overview == null ? '' : overview,
      style: TextStyle(
          color: Colors.white, fontWeight: FontWeight.w400, fontSize: 16),
    );
  }
}

class _PeopleWidget extends StatelessWidget {
  const _PeopleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<MovieDetailsModel>(context);
    final crew = model?.movieDetails?.credits.crew;
    final namestyle = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w800,
      fontSize: 16,
    );
    final jobtitlestyle = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w400,
      fontSize: 16,
    );
    return Padding(
      padding: EdgeInsets.only(left: 10, top: 30, bottom: 30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      crew?[0].name ?? '',
                      style: namestyle,
                    ),
                    Text(
                      crew?[0].job ?? '',
                      style: jobtitlestyle,
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      crew?[1].name ?? '',
                      style: namestyle,
                    ),
                    Text(
                      crew?[1].job ?? '',
                      style: jobtitlestyle,
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            width: 40,
          ),
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      crew?[2].name ?? '',
                      style: namestyle,
                    ),
                    Text(
                      crew?[2].job ?? '',
                      style: jobtitlestyle,
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      crew?[3].name ?? '',
                      style: namestyle,
                    ),
                    Text(
                      crew?[3].job ?? '',
                      style: jobtitlestyle,
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

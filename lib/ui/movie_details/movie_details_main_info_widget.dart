import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:themoviedb/configuration/configuration.dart';
import 'package:themoviedb/domain/api_client/image_loader.dart';
import 'package:themoviedb/services/date_services.dart';
import 'package:themoviedb/ui/movie_details/elements/radial_percent_widget.dart';
import 'package:themoviedb/ui/movie_details/movie_details_model.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';

class MovieDetailsMainInfoWidget extends StatelessWidget {
  const MovieDetailsMainInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Stack(children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TopPosterWidget(),
          Padding(
            padding: EdgeInsets.all(20),
            child: _MovieNameWidget(),
          ),
          _ScoreWidget(),
          _SummeryWidget(),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: _OverviewWidget(),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: _DescriptionWidget(),
          ),
          _PeopleWidget(),
        ],
      ),
    ]);
  }
}

class _TopPosterWidget extends StatelessWidget {
  const _TopPosterWidget();
  @override
  Widget build(BuildContext context) {
    final model = context.watch<MovieDetailsModel>();
    return AspectRatio(
      aspectRatio: 430 / 193.5,
      child: Stack(
        children: [
          model.movieDetails?.backdropPath != null
              ? Image.network(ImageLoader.imageUrl(
                  ImageUrl.imgUrlBackdropthMovieDetails,
                  model.movieDetails!.backdropPath!))
              : const SizedBox.shrink(),
          Positioned(
            top: 20,
            left: 20,
            bottom: 20,
            child: model.movieDetails?.posterPath != null
                ? Image.network(ImageLoader.imageUrl(
                    ImageUrl.imgUrlPosterPathMovieDetails,
                    model.movieDetails!.posterPath!))
                : const SizedBox.shrink(),
          ),
          Positioned(
              top: 5,
              right: 5,
              child: IconButton(
                onPressed: () {
                  model.addOrDeleteFavoriteMovie();
                },
                icon: model.isFavorite == true
                    ? const Icon(
                        Icons.favorite,
                        color: Colors.red,
                      )
                    : const Icon(
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
  const _MovieNameWidget();

  @override
  Widget build(BuildContext context) {
    final model = context.watch<MovieDetailsModel>();
    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        maxLines: 3,
        text: TextSpan(children: [
          TextSpan(
            text: model.movieDetails?.title,
            style: const TextStyle(
                fontWeight: FontWeight.w600, fontSize: 21, color: Colors.white),
          ),
          TextSpan(
            text: model.movieDetails?.releaseDate?.year.toString() != null
                ? ' (${model.movieDetails?.releaseDate?.year.toString()})'
                : '',
            style: const TextStyle(
                fontWeight: FontWeight.w400, fontSize: 16, color: Colors.grey),
          ),
        ]),
      ),
    );
  }
}

class _ScoreWidget extends StatelessWidget {
  const _ScoreWidget();

  @override
  Widget build(BuildContext context) {
    final model = context.watch<MovieDetailsModel>();
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
                  percent: model.movieDetails?.voteAverage != null
                      ? model.movieDetails!.voteAverage * 10 / 100
                      : 0,
                  fillColor: const Color.fromARGB(255, 10, 23, 25),
                  lineColor: const Color.fromARGB(255, 37, 203, 103),
                  freeColor: const Color.fromARGB(255, 25, 54, 31),
                  lineWidth: 3,
                  child: model.movieDetails?.voteAverage != null
                      ? Text((model.movieDetails!.voteAverage * 10)
                          .toStringAsFixed(0))
                      : const Text('0'),
                ),
              ),
              const SizedBox(width: 10),
              const Text('User Score'),
            ],
          ),
        ),
        model.trailerKey != null
            ? Container(width: 1, height: 15, color: Colors.grey)
            : const SizedBox.shrink(),
        model.trailerKey != null
            ? TextButton.icon(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                      MainNavigationRoutesName.movieTrailer,
                      arguments: model.trailerKey);
                },
                icon: const Icon(Icons.play_arrow),
                label: const Text('Play Trailer'),
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}

class _SummeryWidget extends StatelessWidget {
  const _SummeryWidget();

  @override
  Widget build(BuildContext context) {
    final model = context.watch<MovieDetailsModel>();
    final releaseDate = model.movieDetails?.releaseDate != null
        ? DateConvert.stringFromDate(model.movieDetails?.releaseDate)
        : null;
    final productCountry = model.movieDetails?.productionCountries?.first.iso;

    final hours = model.movieDetails?.runtime != null
        ? model.movieDetails!.runtime! ~/ 60
        : null;

    final minutes = model.movieDetails?.runtime != null
        ? model.movieDetails!.runtime! - hours! * 60
        : null;

    final List genresList = <String>[];
    model.movieDetails?.genres.forEach((element) {
      genresList.add(element.name);
    });

    String genresString = genresList.join(', ');
    return ColoredBox(
      color: const Color.fromARGB(26, 11, 10, 1),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Text(
          '$releaseDate ($productCountry) ${hours}h ${minutes}m, $genresString',
          maxLines: 3,
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.w400, fontSize: 16),
        ),
      ),
    );
  }
}

class _OverviewWidget extends StatelessWidget {
  const _OverviewWidget();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Обзор',
      style: TextStyle(
          color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16),
    );
  }
}

class _DescriptionWidget extends StatelessWidget {
  const _DescriptionWidget();

  @override
  Widget build(BuildContext context) {
    final model = context.watch<MovieDetailsModel>();
    return Text(
      model.movieDetails?.overview != null ? model.movieDetails!.overview : '',
      style: const TextStyle(
          color: Colors.white, fontWeight: FontWeight.w400, fontSize: 16),
    );
  }
}

class _PeopleWidget extends StatelessWidget {
  const _PeopleWidget();

  @override
  Widget build(BuildContext context) {
    final model = context.watch<MovieDetailsModel>();
    const namestyle = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w800,
      fontSize: 16,
    );
    const jobtitlestyle = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w400,
      fontSize: 16,
    );
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 30, bottom: 30),
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
                      model.movieDetails?.credits.crew[0].name ?? '',
                      style: namestyle,
                    ),
                    Text(
                      model.movieDetails?.credits.crew[0].job ?? '',
                      style: jobtitlestyle,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.movieDetails?.credits.crew[1].name ?? '',
                      style: namestyle,
                    ),
                    Text(
                      model.movieDetails?.credits.crew[1].job ?? '',
                      style: jobtitlestyle,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
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
                      model.movieDetails?.credits.crew[2].name ?? '',
                      style: namestyle,
                    ),
                    Text(
                      model.movieDetails?.credits.crew[2].job ?? '',
                      style: jobtitlestyle,
                    ),
                    const SizedBox(
                      height: 20,
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.movieDetails?.credits.crew[3].name ?? '',
                      style: namestyle,
                    ),
                    Text(
                      model.movieDetails?.credits.crew[3].job ?? '',
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

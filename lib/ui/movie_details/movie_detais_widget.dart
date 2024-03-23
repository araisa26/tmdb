import 'package:flutter/material.dart';
import 'package:themoviedb/library/provider.dart';
import 'package:themoviedb/ui/movie_details/movie_details_model.dart';
import 'movie_details_main_info_widget.dart';
import 'movie_details_main_screen_cast_widget.dart';

class MovieDetailsWidget extends StatefulWidget {
  const MovieDetailsWidget({super.key});

  @override
  State<MovieDetailsWidget> createState() => MovieDetailsWidgetState();
}

class MovieDetailsWidgetState extends State<MovieDetailsWidget> {
  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<MovieDetailsModel>(context);
    model!.setupLocal(context);
    final movieDetails = model.movieDetails;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          (movieDetails?.title == null) ? '' : movieDetails!.title,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ColoredBox(
        color: Color.fromRGBO(31, 10, 10, 1),
        child: _BodyWidget(),
      ),
    );
  }
}

class _BodyWidget extends StatelessWidget {
  const _BodyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<MovieDetailsModel>(context);
    final movieDetails = model?.movieDetails;
    if (movieDetails == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return ListView(
      children: [
        const MovieDetailsMainInfoWidget(),
        const SizedBox(height: 30),
        const MovieDetailsMainScreenCastWidget(),
      ],
    );
  }
}

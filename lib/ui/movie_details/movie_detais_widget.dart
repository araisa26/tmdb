import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:themoviedb/ui/movie_details/movie_details_model.dart';
import 'package:themoviedb/ui/movie_details/movie_details_main_info_widget.dart';
import 'package:themoviedb/ui/movie_details/movie_details_main_screen_cast_widget.dart';

class MovieDetailsWidget extends StatefulWidget {
  const MovieDetailsWidget({super.key});

  @override
  State<MovieDetailsWidget> createState() => MovieDetailsWidgetState();
}

class MovieDetailsWidgetState extends State<MovieDetailsWidget> {
  @override
  void didChangeDependencies() {
    context.read<MovieDetailsModel>().setupLocal(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final model = context.watch<MovieDetailsModel>();
    final movieDetails = model.movieDetails;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          (movieDetails?.title == null) ? '' : movieDetails!.title,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: const ColoredBox(
        color: Color.fromRGBO(31, 10, 10, 1),
        child: _BodyWidget(),
      ),
    );
  }
}

class _BodyWidget extends StatelessWidget {
  const _BodyWidget();

  @override
  Widget build(BuildContext context) {
    final model = context.watch<MovieDetailsModel>();
    final movieDetails = model.movieDetails;
    if (movieDetails == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return ListView(
      children: const [
        MovieDetailsMainInfoWidget(),
        SizedBox(height: 30),
        MovieDetailsMainScreenCastWidget(),
      ],
    );
  }
}

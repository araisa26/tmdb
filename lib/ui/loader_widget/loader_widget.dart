import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:themoviedb/ui/loader_widget/loader_view_cubit.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';

class LoaderWidget extends StatelessWidget {
  const LoaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoaderViewCubit, LoaderViewCubitState>(
      listenWhen: (prev, current) => current != LoaderViewCubitState.unknown,
      listener: (context, state) {
        final screen = state == LoaderViewCubitState.authorized
            ? MainNavigationRoutesName.mainScreen
            : MainNavigationRoutesName.auth;
        Navigator.of(context).pushReplacementNamed(screen);
      },
      child: const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

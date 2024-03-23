import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:themoviedb/domain/blocs/auth_bloc.dart';

enum LoaderViewCubitState {
  unknown,
  authorized,
  notAuthotized,
}

class LoaderViewCubit extends Cubit<LoaderViewCubitState> {
  final AuthBloc authBloc;
  late final StreamSubscription<AuthState> authBlocSubscriptioin;
  LoaderViewCubit(LoaderViewCubitState initialState, this.authBloc)
      : super(initialState) {
    authBloc.add(CheckAuthEvent());
    authBlocSubscriptioin = authBloc.stream.listen((AuthState state) {
      if (state is AuthAuthorizedState) {
        emit(LoaderViewCubitState.authorized);
      } else if (state is AuthUnAuthorizedState) {
        emit(LoaderViewCubitState.notAuthotized);
      }
    });
  }

  @override
  Future<void> close() {
    authBlocSubscriptioin.cancel();
    return super.close();
  }
}

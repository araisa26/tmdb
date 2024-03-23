import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:themoviedb/domain/blocs/auth_bloc.dart';

class DataAuth {
  String login = '';
  String password = '';
}

abstract class AuthCubitState {
  TextEditingController login = TextEditingController();
  TextEditingController password = TextEditingController();
  String? errorText;
  bool canAuthStart;
  AuthCubitState(this.errorText, [this.canAuthStart = false]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthCubitState &&
          runtimeType == other.runtimeType &&
          errorText == other.errorText &&
          canAuthStart == other.canAuthStart &&
          login == other.login &&
          password == other.password;

  @override
  int get hashCode => 0;
}

class AuthScreenState extends AuthCubitState {
  AuthScreenState(super.errorText, [super.canAuthStart = false]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthScreenState && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}

class AuthProgressScreenState extends AuthCubitState {
  AuthProgressScreenState(super.errorText, [super.canAuthStart = false]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthProgressScreenState && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}

class AuthFailureScreenState extends AuthCubitState {
  AuthFailureScreenState(super.errorText, [super.canAuthStart = false]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthFailureScreenState && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}

class AuthViewCubit extends Cubit<AuthCubitState> {
  final AuthBloc authBloc;
  late final StreamSubscription<AuthState> authBlocSubscription;
  AuthViewCubit(AuthCubitState initialState, this.authBloc)
      : super(initialState) {
    authBlocSubscription = authBloc.stream.listen((AuthState state) {
      if (state is AuthUnAuthorizedState) {
        emit(AuthScreenState(null));
      } else if (state is AuthAuthorizedState) {
        emit(AuthProgressScreenState(null, true));
        authBlocSubscription.cancel();
      } else if (state is AuthFaliureState) {
        emit(AuthFailureScreenState(state.failure.toString()));
      }
    });
  }
  Future<void> auth({required String login, required String password}) async {
    authBloc.add(AuthLoginEvent(login, password));
  }

  @override
  Future<void> close() {
    authBlocSubscription.cancel();
    return super.close();
  }
}

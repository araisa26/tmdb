import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:themoviedb/domain/api_client/auth_api_client.dart';
import 'package:themoviedb/domain/data_providers/session_data_provider.dart';

abstract class AuthEvent {}

class CheckAuthEvent extends AuthEvent {}

class AuthLoginEvent extends AuthEvent {
  String login;
  String password;
  AuthLoginEvent(this.login, this.password);
}

class AuthLogoutEvent extends AuthEvent {}

abstract class AuthState {}

class AuthUnAuthorizedState extends AuthState {
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthUnAuthorizedState && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}

class AuthAuthorizedState extends AuthState {
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthAuthorizedState && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}

class AuthFaliureState extends AuthState {
  final Object failure;

  AuthFaliureState(this.failure);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthFaliureState &&
          runtimeType == other.runtimeType &&
          failure == other.failure;

  @override
  int get hashCode => failure.hashCode;
}

class AuthProgressState extends AuthState {
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthProgressState && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthState initialState) : super(initialState) {
    on<AuthEvent>((event, emit) async {
      if (event is CheckAuthEvent) {
        await onCheckAuthEvent(emit);
      } else if (event is AuthLoginEvent) {
        await onAuthLoginEvent(event, emit);
      } else if (event is AuthLogoutEvent) {
        await onAuthLogoutEvent(emit);
      }
    }, transformer: sequential());
  }
  Future<void> onCheckAuthEvent(Emitter<AuthState> emit) async {
    await SessionDataProvider.getSessionId() != null
        ? emit(AuthAuthorizedState())
        : emit(AuthUnAuthorizedState());
  }

  Future<void> onAuthLoginEvent(
      AuthLoginEvent event, Emitter<AuthState> emit) async {
    try {
      if (event.login.isEmpty || event.password.isEmpty) {
        emit(AuthFaliureState('Заполните логин или пароль'));
      } else {
        await SessionDataProvider.setSessonId(
            await AuthApiClient.makeSessionId(event.login, event.password));
        await SessionDataProvider.setAccountId(await AuthApiClient.getAccountId(
            await SessionDataProvider.getSessionId()));
        emit(AuthAuthorizedState());
      }
    } catch (e) {
      emit(AuthFaliureState(e));
    }
  }

  Future<void> onAuthLogoutEvent(Emitter<AuthState> emit) async {
    try {
      await SessionDataProvider.setSessonId(null);
      await SessionDataProvider.setAccountId(null);
      emit(AuthUnAuthorizedState());
    } catch (e) {
      emit(AuthFaliureState(e));
    }
  }
}

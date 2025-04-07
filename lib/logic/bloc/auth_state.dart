part of 'auth_bloc.dart';

abstract class AuthState {}

class AuthInitialState extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthSuccessState extends AuthState {
  final String userId;
  AuthSuccessState(this.userId);
}

class AuthFailureState extends AuthState {
  final String error;
  AuthFailureState(this.error);
}


class ForgotPasswordSuccessState extends AuthState {}

class ForgotPasswordFailureState extends AuthState {
  final String error;
  ForgotPasswordFailureState(this.error);
}

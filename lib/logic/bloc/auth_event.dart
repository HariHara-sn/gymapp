part of 'auth_bloc.dart';

abstract class AuthEvent {}

class SignInEvent extends AuthEvent {
  final String email;
  final String password;

  SignInEvent({required this.email, required this.password});
}

class SignUpEvent extends AuthEvent {
  final String email;
  final String password;
  final Map<String, dynamic> userData;

  SignUpEvent({ required this.email, required this.password, required this.userData});
}

class SignOutEvent extends AuthEvent {}


class ForgotPasswordEvent extends AuthEvent {
  final String email;

  ForgotPasswordEvent({required this.email});
}


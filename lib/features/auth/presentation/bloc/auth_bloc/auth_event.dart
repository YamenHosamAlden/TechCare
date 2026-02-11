part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class CheckSavedTokenAuthEvent extends AuthEvent {}

class AuthenticationStatusChanged extends AuthEvent {
  const AuthenticationStatusChanged(this.status);

  final AuthenticationStatus status;
}

// class LogoutEvent extends AuthEvent {}




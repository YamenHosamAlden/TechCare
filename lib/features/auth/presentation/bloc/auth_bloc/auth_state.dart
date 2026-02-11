part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoadingState extends AuthState {
  final User? user;

  AuthLoadingState({this.user});

  @override
  List<Object?> get props => [this.user];
}

class AuthenticatedState extends AuthState {
  final User user;
  AuthenticatedState({required this.user});

  @override
  List<Object?> get props => [this.user];
}

class UnauthenticatedState extends AuthState {}

final class AuthErrorMsgState extends AuthState {
  final TranslatableValue errorMsg;
  AuthErrorMsgState({required this.errorMsg});
}

part of 'login_bloc.dart';

sealed class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

final class LoginInitial extends LoginState {}

final class LoginLoadingState extends LoginState {}

final class LoginErrorMsgState extends LoginState {
  final TranslatableValue errorMsg;
  LoginErrorMsgState({required this.errorMsg});
}

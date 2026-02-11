part of 'login_bloc.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}



final class LoginFormSubmittedEvent extends LoginEvent {
  final String userNamr;
  final String passWord;
  LoginFormSubmittedEvent({
    required this.userNamr,
    required this.passWord,
  });
}
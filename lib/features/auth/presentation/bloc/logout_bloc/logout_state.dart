// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'logout_bloc.dart';

class LogoutState extends Equatable {
  final bool isLoading;

  const LogoutState({this.isLoading = false});

  LogoutState.init() : this(isLoading: false);

  LogoutState copyWith({
    bool? isLoading,
  }) =>
      LogoutState(
        isLoading: isLoading ?? this.isLoading,
      );

  @override
  List<Object> get props => [isLoading];
}

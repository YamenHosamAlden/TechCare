part of 'app_launch_bloc.dart';

abstract class AppLaunchState extends Equatable {
  const AppLaunchState();

  @override
  List<Object> get props => [];
}

class AppLaunchInitialState extends AppLaunchState {}

class UpdatingService extends AppLaunchState {}

class NewUpdate extends AppLaunchState {
  final VersionStatus versionStatus;
  NewUpdate({required this.versionStatus});
}

// class AppLaunchingErorr extends AppLaunchState {
//   final TranslatableValue errorMsg;
//   AppLaunchingErorr({required this.errorMsg});
// }

class AppLaunchingComplete extends AppLaunchState {}

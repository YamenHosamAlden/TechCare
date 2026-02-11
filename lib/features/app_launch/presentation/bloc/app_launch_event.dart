part of 'app_launch_bloc.dart';

abstract class AppLaunchEvent extends Equatable {
  const AppLaunchEvent();

  @override
  List<Object> get props => [];
}

class AppLaunchInitialEvent extends AppLaunchEvent{}

class SkipUpdateEvent extends AppLaunchEvent{}


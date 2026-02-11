part of 'delete_device_bloc.dart';

class DeleteDeviceState extends Equatable {
  final bool isLoading;
  final bool isComplete;

  const DeleteDeviceState({
    this.isLoading = false,
    this.isComplete = false,
  });

  DeleteDeviceState.init() : this(isLoading: false, isComplete: false);

  DeleteDeviceState copyWith({bool? isLoading, bool? isComplete}) =>
      DeleteDeviceState(
          isLoading: isLoading ?? this.isLoading,
          isComplete: isComplete ?? this.isComplete);

  @override
  List<Object> get props => [isLoading, isComplete];
}

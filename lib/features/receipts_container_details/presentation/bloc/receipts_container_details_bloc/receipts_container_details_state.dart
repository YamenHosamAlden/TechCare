part of 'receipts_container_details_bloc.dart';

class ReceiptsContainerDetailsState extends Equatable {
  final ContainerDetails? containerDetails;
  final bool pageLoading;

  const ReceiptsContainerDetailsState({
    this.containerDetails,
    this.pageLoading = false,
  });

  ReceiptsContainerDetailsState.initial() : this(pageLoading: true);

  ReceiptsContainerDetailsState copyWith({
    ContainerDetails? containerDetails,
    bool? pageLoading,
  }) {
    return ReceiptsContainerDetailsState(
        pageLoading: pageLoading ?? this.pageLoading,
        containerDetails: containerDetails ?? this.containerDetails);
  }

  @override
  List<Object?> get props => [
        containerDetails,
        containerDetails?.devices.length,
        pageLoading,
      ];
}

class ReceiptsContainerDetailsErrorState extends ReceiptsContainerDetailsState {
  final TranslatableValue errorMessage;
  ReceiptsContainerDetailsErrorState({required this.errorMessage});
}

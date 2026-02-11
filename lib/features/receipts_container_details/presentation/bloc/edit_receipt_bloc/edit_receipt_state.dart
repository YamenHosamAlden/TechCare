part of 'edit_receipt_bloc.dart';

class EditReceiptState extends Equatable {
  final bool isLoading;
  final bool editCompleted;
  final double? uploadProgress;
  final ContainerDetails? containerDetails;
  final String countryCode;

  const EditReceiptState(
      {this.isLoading = false,
      this.uploadProgress,
      this.containerDetails,
      this.editCompleted = false,
      this.countryCode="+963"});

  EditReceiptState.init({ContainerDetails? containerDetails})
      : this(
          isLoading: false,
          editCompleted: false,
          containerDetails: containerDetails,
        );
  EditReceiptState copyWith({
    bool? isLoading,
    double? uploadProgress,
    ContainerDetails? containerDetails,
    bool? editCompleted,
    String? countryCode,
  }) =>
      EditReceiptState(
        isLoading: isLoading ?? this.isLoading,
        uploadProgress: uploadProgress,
        containerDetails: containerDetails ?? this.containerDetails,
        editCompleted: editCompleted ?? this.editCompleted,
        countryCode: countryCode ?? this.countryCode,
      );
  @override
  List<Object?> get props => [
        isLoading,
        containerDetails,
        uploadProgress,
        editCompleted,
        countryCode,
      ];
}

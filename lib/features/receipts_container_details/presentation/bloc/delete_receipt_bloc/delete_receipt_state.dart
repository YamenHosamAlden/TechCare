part of 'delete_receipt_bloc.dart';

class DeleteReceiptState extends Equatable {
  final bool isLoading;
  const DeleteReceiptState({
    this.isLoading = false,
  });

  DeleteReceiptState.init() : this(isLoading: false);
  DeleteReceiptState copyWith({
    bool? isLoading,
  }) =>
      DeleteReceiptState(
        isLoading: isLoading ?? this.isLoading,
      );
  @override
  List<Object> get props => [
        isLoading,
      ];
}

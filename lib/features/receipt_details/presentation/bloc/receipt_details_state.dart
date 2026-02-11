part of 'receipt_details_bloc.dart';

class ReceiptDetailsState extends Equatable {
  final bool isLoading;
  final ReceiptDetails? receiptDetails;

  const ReceiptDetailsState({
    this.isLoading = false,
    this.receiptDetails,
  });

  const ReceiptDetailsState.initState() : this(isLoading: true);

  ReceiptDetailsState copyWith({
    bool? isLoading,
    ReceiptDetails? receiptDetails,
  }) =>
      ReceiptDetailsState(
        isLoading: isLoading ?? this.isLoading,
        receiptDetails: receiptDetails ?? this.receiptDetails,
      );

  @override
  List<Object?> get props => [
        isLoading,
        receiptDetails,
      ];
}

class ReceiptDetailsErrorState extends ReceiptDetailsState {
  final TranslatableValue errorMessage;
  ReceiptDetailsErrorState({
    required this.errorMessage,
  });
}

class ReceiptReceivedState extends ReceiptDetailsState {
  ReceiptReceivedState({required super.receiptDetails, super.isLoading = true});
}

part of 'finished_receipts_bloc.dart';

 class FinishedReceiptsState extends Equatable {
  final bool isLoading;
  final bool loadMore;
  final List<ReceiptContainer> finishedReceiptsList;

  const FinishedReceiptsState(
      {this.isLoading = false,
      this.finishedReceiptsList = const [],
      this.loadMore = false});

  FinishedReceiptsState.initial()
      : this(finishedReceiptsList: [], isLoading: true, loadMore: false);

  FinishedReceiptsState copyWith({
    bool? isLoading,
    bool? loadMore,
    List<ReceiptContainer>? finishedReceiptsList,
  }) {
    return FinishedReceiptsState(
        isLoading: isLoading ?? this.isLoading,
        finishedReceiptsList: finishedReceiptsList ?? this.finishedReceiptsList,
        loadMore: loadMore ?? this.loadMore);
  }

  @override
  List<Object> get props => [isLoading, finishedReceiptsList, loadMore];
}

class FinishedReceiptsErrorState extends FinishedReceiptsState {
  final TranslatableValue errorMessage;

  FinishedReceiptsErrorState({required this.errorMessage});
}

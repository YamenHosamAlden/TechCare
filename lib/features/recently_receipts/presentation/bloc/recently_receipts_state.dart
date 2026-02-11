part of 'recently_receipts_bloc.dart';

class RecentlyReceiptsState extends Equatable {
  final bool isLoading;
  final bool loadMore;
  final List<ReceiptContainer> recentlyReceiptsList;

  const RecentlyReceiptsState({
    this.isLoading = false,
    this.loadMore = false,
    this.recentlyReceiptsList = const [],
  });

  RecentlyReceiptsState.init()
      : this(isLoading: true, loadMore: false, recentlyReceiptsList: []);

  RecentlyReceiptsState copyWith(
          {bool? isLoading,
          bool? loadMore,
          List<ReceiptContainer>? recentlyReceiptsList}) =>
      RecentlyReceiptsState(
          isLoading: isLoading ?? this.isLoading,
          loadMore: loadMore ?? this.loadMore,
          recentlyReceiptsList:
              recentlyReceiptsList ?? this.recentlyReceiptsList);
  @override
  List<Object> get props => [isLoading, recentlyReceiptsList, loadMore];
}

class RecentlyReceiptsErrorState extends RecentlyReceiptsState {
  final TranslatableValue errorMessage;

  RecentlyReceiptsErrorState({required this.errorMessage});
}

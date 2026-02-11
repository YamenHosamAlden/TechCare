part of 'recently_receipts_bloc.dart';

sealed class RecentlyReceiptsEvent extends Equatable {
  const RecentlyReceiptsEvent();

  @override
  List<Object> get props => [];
}

class GetRecentlyReceipts extends RecentlyReceiptsEvent {}
 class ReloadRecentlyReceipts extends RecentlyReceiptsEvent {}
 class LoadMoreRecentlyReceipts extends RecentlyReceiptsEvent {}

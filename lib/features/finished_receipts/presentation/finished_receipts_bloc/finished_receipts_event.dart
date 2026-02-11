part of 'finished_receipts_bloc.dart';

abstract class FinishedReceiptsEvent extends Equatable {
  const FinishedReceiptsEvent();

  @override
  List<Object> get props => [];
}

final class LoadFinishedReceiptsList extends FinishedReceiptsEvent {}

final class ReloadFinishedReceipts extends FinishedReceiptsEvent {}
final class LoadMoreFinishedReceipts extends FinishedReceiptsEvent {}


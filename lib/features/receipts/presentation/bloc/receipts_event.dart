part of 'receipts_bloc.dart';

sealed class ReceiptsEvent extends Equatable {
  const ReceiptsEvent();

  @override
  List<Object> get props => [];
}

class LoadReceivedList extends ReceiptsEvent {}

class LoadMaintenanceList extends ReceiptsEvent {}

class LoadQualityList extends ReceiptsEvent {}

//____________________________________________________

class ReloadReceivedList extends ReceiptsEvent {}

class ReloadMaintenanceList extends ReceiptsEvent {}

class ReloadQualityList extends ReceiptsEvent {}

//____________________________________________________

class LoadMoreReceivedReceipts extends ReceiptsEvent {}

class LoadMoreMaintenanceReceipts extends ReceiptsEvent {}

class LoadMoreQualityReceipts extends ReceiptsEvent {}

class LoadAllReceipts extends ReceiptsEvent {}

class AddToReceivedList extends ReceiptsEvent {}

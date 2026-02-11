part of 'delete_receipt_bloc.dart';

class DeleteReceiptEvent extends Equatable {
  final int containerId;
  const DeleteReceiptEvent({required this.containerId});

  @override
  List<Object> get props => [containerId];
}

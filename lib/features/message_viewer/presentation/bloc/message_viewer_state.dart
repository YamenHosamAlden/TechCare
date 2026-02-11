part of 'message_viewer_bloc.dart';

abstract class MessageViewerState extends Equatable {
  MessageViewerState();

  @override
  List<Object> get props => [];
}

class MessageViewerInitial extends MessageViewerState {}

class SnackbarMsgState extends MessageViewerState {
  final SnackBarMessageConfig snackBarMessageConfig;

  SnackbarMsgState({
    required this.snackBarMessageConfig,
  });

  @override
  List<Object> get props => [snackBarMessageConfig, Random().nextInt(100)];
}

class DialogMsgState extends MessageViewerState {
  final DialogMessageConfig dialogMessageConfig;

  DialogMsgState({
    required this.dialogMessageConfig,
  });

  @override
  List<Object> get props => [dialogMessageConfig];
}

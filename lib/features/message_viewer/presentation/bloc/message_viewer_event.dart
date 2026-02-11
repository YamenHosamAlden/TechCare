part of 'message_viewer_bloc.dart';

abstract class MessageViewerEvent extends Equatable {
  const MessageViewerEvent();

  @override
  List<Object> get props => [];
}

class ShowSnackbarMessageEvent extends MessageViewerEvent {
  final SnackBarMessageConfig snackBarMessageConfig;

  ShowSnackbarMessageEvent({required this.snackBarMessageConfig});
}

class ShowDialogMessageEvent extends MessageViewerEvent {
  final DialogMessageConfig dialogMessageConfig;

  ShowDialogMessageEvent({required this.dialogMessageConfig});
}

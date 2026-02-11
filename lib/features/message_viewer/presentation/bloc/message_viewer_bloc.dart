import 'dart:async';
import 'dart:ffi';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tech_care_app/features/message_viewer/domain/entities/dialog_message_config.dart';

import 'package:tech_care_app/features/message_viewer/domain/entities/snackbar_message_config.dart';
import 'package:tech_care_app/features/message_viewer/domain/usecases/message_viewer_stream_usecase.dart';

part 'message_viewer_event.dart';
part 'message_viewer_state.dart';

class MessageViewerBloc extends Bloc<MessageViewerEvent, MessageViewerState> {
  final MessageViewerStreamUsecase messageViewerStreamUsecase;
  late StreamSubscription<MessageViewerEvent> _messageStreamSubscription;

  MessageViewerBloc({
    required this.messageViewerStreamUsecase,
  }) : super(MessageViewerInitial()) {

    on<ShowSnackbarMessageEvent>(_onShowSnackbarMessage);
    on<ShowDialogMessageEvent>(_onDialogMessage);

    messageViewerStreamUsecase(Void)
        .then((value) => value.fold((l) => null, (messageViewerStream) {
              _messageStreamSubscription = messageViewerStream
                  .listen((messageViewerEvent) => add(messageViewerEvent),);
            }));
  }

  @override
  Future<void> close() {
    _messageStreamSubscription.cancel();
    return super.close();
  }

  FutureOr<void> _onShowSnackbarMessage(
      ShowSnackbarMessageEvent event, Emitter<MessageViewerState> emit) {
    emit(SnackbarMsgState(snackBarMessageConfig: event.snackBarMessageConfig));

  }

  FutureOr<void> _onDialogMessage(
      ShowDialogMessageEvent event, Emitter<MessageViewerState> emit) {

    emit(DialogMsgState(dialogMessageConfig: event.dialogMessageConfig));


 
  }
}

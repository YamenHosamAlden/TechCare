import 'dart:async';
import 'dart:ffi';

import 'package:dartz/dartz.dart';
import 'package:tech_care_app/core/error/failures.dart';
import 'package:tech_care_app/features/message_viewer/domain/entities/dialog_message_config.dart';
import 'package:tech_care_app/features/message_viewer/domain/entities/snackbar_message_config.dart';
import 'package:tech_care_app/features/message_viewer/domain/repositories/message_viewer_repository.dart';
import 'package:tech_care_app/features/message_viewer/presentation/bloc/message_viewer_bloc.dart';

class MessageViewerRepositoryImpl extends MessageViewerRepository {
  StreamController<MessageViewerEvent>? _streamController;

  @override
  Future<Either<Failure, Stream<MessageViewerEvent>>>
      get messageViewerEventStream {
    if (_streamController != null) {
      _streamController?.close();
    }
    _streamController = StreamController<MessageViewerEvent>();

    return Future.value(Right(_streamController!.stream));
  }

  @override
  Future<Either<Failure, void>> viewSnackBarMsg(
      SnackBarMessageConfig snackBarMessageConfig) {
    _sinkEvent(
        ShowSnackbarMessageEvent(snackBarMessageConfig: snackBarMessageConfig));
    return Future.value(Right(Void));
  }

  void _sinkEvent(MessageViewerEvent event) {
    if (_streamController?.hasListener == true) {
      _streamController?.sink.add(event);
    }
  }

  @override
  Future<Either<Failure, void>> viewDialogMsg(
      DialogMessageConfig dialogMessageConfig) {
    _sinkEvent(
        ShowDialogMessageEvent(dialogMessageConfig: dialogMessageConfig));
    return Future.value(Right(Void));
  }
}

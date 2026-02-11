import 'package:dartz/dartz.dart';
import 'package:tech_care_app/core/error/failures.dart';
import 'package:tech_care_app/features/message_viewer/domain/entities/dialog_message_config.dart';
import 'package:tech_care_app/features/message_viewer/domain/entities/snackbar_message_config.dart';
import 'package:tech_care_app/features/message_viewer/presentation/bloc/message_viewer_bloc.dart';

abstract class MessageViewerRepository {
  Future<Either<Failure, Stream<MessageViewerEvent>>>
      get messageViewerEventStream;

  Future<Either<Failure, void>> viewSnackBarMsg(
      SnackBarMessageConfig snackBarMessageConfig);
  Future<Either<Failure, void>> viewDialogMsg(
      DialogMessageConfig dialogMessageConfig);
}

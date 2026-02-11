import 'package:dartz/dartz.dart';
import 'package:tech_care_app/core/error/failures.dart';
import 'package:tech_care_app/core/usecases/usecase.dart';
import 'package:tech_care_app/features/message_viewer/domain/repositories/message_viewer_repository.dart';
import 'package:tech_care_app/features/message_viewer/presentation/bloc/message_viewer_bloc.dart';

class MessageViewerStreamUsecase
    extends Usecase<Stream<MessageViewerEvent>, void> {
  final MessageViewerRepository repository;
  MessageViewerStreamUsecase({required this.repository});

  @override
  Future<Either<Failure, Stream<MessageViewerEvent>>> call(Void) async {
    return await repository.messageViewerEventStream;
  }
}

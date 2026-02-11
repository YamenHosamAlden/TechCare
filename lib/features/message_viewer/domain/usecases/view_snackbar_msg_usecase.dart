import 'package:dartz/dartz.dart';
import 'package:tech_care_app/core/error/failures.dart';
import 'package:tech_care_app/core/usecases/usecase.dart';
import 'package:tech_care_app/features/message_viewer/domain/entities/snackbar_message_config.dart';
import 'package:tech_care_app/features/message_viewer/domain/repositories/message_viewer_repository.dart';

class ViewSnackBarMsgUsecase extends Usecase<void, SnackBarMessageConfig> {
  final MessageViewerRepository repository;
  ViewSnackBarMsgUsecase({required this.repository});

  @override
  Future<Either<Failure, void>> call(snackBarMessageConfig) async {
    return await repository.viewSnackBarMsg(snackBarMessageConfig);
  }
}

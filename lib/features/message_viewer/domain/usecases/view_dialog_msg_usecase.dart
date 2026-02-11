import 'package:dartz/dartz.dart';
import 'package:tech_care_app/core/error/failures.dart';
import 'package:tech_care_app/core/usecases/usecase.dart';
import 'package:tech_care_app/features/message_viewer/domain/entities/dialog_message_config.dart';
import 'package:tech_care_app/features/message_viewer/domain/repositories/message_viewer_repository.dart';

class ViewDialogMsgUsecase extends Usecase<void, DialogMessageConfig> {
  final MessageViewerRepository repository;
  ViewDialogMsgUsecase({required this.repository});

  @override
  Future<Either<Failure, void>> call(dialogMessageConfig) async {
    return await repository.viewDialogMsg(dialogMessageConfig);
  }
}

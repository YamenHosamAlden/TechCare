import 'package:dartz/dartz.dart';
import 'package:tech_care_app/core/error/failures.dart';
import 'package:tech_care_app/core/usecases/usecase.dart';
import 'package:tech_care_app/features/device_details/domain/entities/process_report.dart';
import 'package:tech_care_app/features/device_details/domain/repositories/device_details_repository.dart';

class AddNoteUsecase extends Usecase<ProcessReport, AddNoteParams> {
  final DeviceDetailsRepository deviceDetailsRepository;

  AddNoteUsecase({required this.deviceDetailsRepository});

  @override
  Future<Either<Failure, ProcessReport>> call(AddNoteParams params) {
    return deviceDetailsRepository.addNote(params.deviceID, params.note);
  }
}

class AddNoteParams {
  final int deviceID;
  final String note;
  AddNoteParams({required this.deviceID, required this.note});
}

import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:tech_care_app/core/error/failures.dart';
import 'package:tech_care_app/core/usecases/usecase.dart';
import 'package:tech_care_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:tech_care_app/features/auth/domain/repositories/user_repository.dart';
import 'package:tech_care_app/features/create_receipt/domain/repositories/create_receipt_repository.dart';
import 'package:tech_care_app/features/create_receipt/domain/repositories/load_resources_repository.dart';
import 'package:tech_care_app/features/quality_report/domain/repository/quality_report_repository.dart';
import 'package:tech_care_app/features/receipts/domain/repositories/receipts_repository.dart';

class LogoutUsecase implements Usecase<void, NoParams> {
  final AuthRepository authRepository;
  final UserRepository userRepository;
  final ReceiptsRepository receiptsRepository;
  final LoadResourcesRepository loadResourcesRepository;
  final CreateReceiptRepository createReceiptRepository;
  final QualityReportRepository qualityReportRepository;
  LogoutUsecase({
    required this.authRepository,
    required this.userRepository,
    required this.receiptsRepository,
    required this.loadResourcesRepository,
    required this.createReceiptRepository,
    required this.qualityReportRepository,
  });

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await authRepository
        .logout()
        .then((value) => value.fold((failure) => Left(failure), (r) {
              receiptsRepository.reset();
              loadResourcesRepository.reset();
              createReceiptRepository.reset();
              qualityReportRepository.reset();

              return Right(userRepository.removeUser());
            }));
  }
}

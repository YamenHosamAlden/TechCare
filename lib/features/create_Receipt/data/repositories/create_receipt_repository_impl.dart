import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:tech_care_app/core/error/exceptions.dart';
import 'package:tech_care_app/core/error/failures.dart';
import 'package:tech_care_app/core/network/network_info.dart';
import 'package:tech_care_app/features/create_receipt/data/datasources/craete_receipt_remote_data_source.dart';
import 'package:tech_care_app/features/create_receipt/data/models/new_receipt_model.dart';
import 'package:tech_care_app/features/create_receipt/domain/entities/maintenance_group.dart';
import 'package:tech_care_app/features/create_receipt/domain/entities/new_receipt.dart';
import 'package:tech_care_app/features/create_receipt/domain/repositories/create_receipt_repository.dart';

class CreateReceiptRepositoryImpl implements CreateReceiptRepository {
  final CreateReceiptRemoteDateSource remoteDataSource;
  final NetworkInfo networkInfo;

  List<MaintenanceGroup>? maintenanceGroups;

  CreateReceiptRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, String>> createReceipt(NewReceipt newReceipt,
      {void Function(int, int)? onSendProgress}) async {
    if (await networkInfo.isConnected) {
      try {
        final receiptUrl = await remoteDataSource.createReceipt(
            NewRerceiptModel.fromEntity(newReceipt),
            onSendProgress: onSendProgress);
        return Right(receiptUrl);
      } on DioException catch (error) {
        return Left(DioFailure(error: error));
      } on ServerException {
        return Left(ServerFailure());
      } catch (e) {
        print(e);
        return Left(UnknownFailure());
      }
    } else {
      return Left(InternetConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, List<MaintenanceGroup>>> loadResources() async {
    if (maintenanceGroups == null) {
      if (await networkInfo.isConnected) {
        try {
          maintenanceGroups = await remoteDataSource.getMaintenanceGroups();
          return Right(maintenanceGroups!);
        } on DioException catch (error) {
          return Left(DioFailure(error: error));
        } on ServerException {
          return Left(ServerFailure());
        } catch (e) {
          print(e);
          return Left(UnknownFailure());
        }
      } else {
        return Left(InternetConnectionFailure());
      }
    } else {
      return Right(maintenanceGroups!);
    }
  }

  @override
  void reset() {
    maintenanceGroups?.clear();
    maintenanceGroups = null;
  }
}

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:tech_care_app/core/error/exceptions.dart';
import 'package:tech_care_app/core/error/failures.dart';
import 'package:tech_care_app/core/network/network_info.dart';
import 'package:tech_care_app/features/finished_receipts/data/datasources/finished_receipts_remote_data_source.dart';
import 'package:tech_care_app/features/finished_receipts/data/models/checkout_form_data_model.dart';
import 'package:tech_care_app/features/finished_receipts/domain/entities/checkout_form_data.dart';
import 'package:tech_care_app/features/finished_receipts/domain/entities/finishing_report.dart';
import 'package:tech_care_app/features/finished_receipts/domain/repositories/finished_receipts_repository.dart';
import 'package:tech_care_app/features/saerch/domain/entity/receipt_container.dart';

class FinishedReceiptsRepositoryImpl implements FinishedReceiptsRepository {
  final NetworkInfo networkInfo;
  final FinishedReceiptsRemoteDataSource remoteDataSource;

  FinishedReceiptsRepositoryImpl({
    required this.networkInfo,
    required this.remoteDataSource,
  });
  int _finishedReceiptsPage = 1;
  List<ReceiptContainer>? _finishedReceiptsList;

  @override
  Future<Either<Failure, List<ReceiptContainer>>> getFinishedReceipts() async {
    if (_finishedReceiptsList == null || _finishedReceiptsList!.isEmpty) {
      if (await networkInfo.isConnected) {
        try {
          _finishedReceiptsList =
              await remoteDataSource.getFinishedReceipts(_finishedReceiptsPage);
          _finishedReceiptsPage++;
        } on DioException catch (error) {
          return Left(DioFailure(error: error));
        } catch (e) {
          // print(e);
          return Left(UnknownFailure());
        }
      } else {
        return Left(InternetConnectionFailure());
      }
    }

    return Right(_finishedReceiptsList ?? []);
  }

  @override
  Future<Either<Failure, List<ReceiptContainer>>>
      loadMoreFinishedReceipts() async {
    if (await networkInfo.isConnected) {
      try {
        final tempPage = _finishedReceiptsPage;
        List<ReceiptContainer> finishedReceipts =
            await remoteDataSource.getFinishedReceipts(_finishedReceiptsPage);

        if (finishedReceipts.isNotEmpty) {
          _checkForDuplication(
              baseList: _finishedReceiptsList!,
              newFinishedReceipts: finishedReceipts);
          _finishedReceiptsPage = tempPage + 1;
        }
      } on DioException catch (error) {
        return Left(DioFailure(error: error));
      } on ServerException {
        return Left(ServerFailure());
      } catch (e) {
        return Left(UnknownFailure());
      }
    } else {
      return Left(InternetConnectionFailure());
    }

    return Right(_finishedReceiptsList ?? []);
  }

  @override
  Future<Either<Failure, List<ReceiptContainer>>> reloadFinishedReceipts() {
    _finishedReceiptsList?.clear();
    _finishedReceiptsPage = 1;
    return getFinishedReceipts();
  }

  @override
  Future<Either<Failure, FinishingReport>> getFinishingReport(
      int conteainerId) async {
    if (await networkInfo.isConnected) {
      try {
        final FinishingReport finishingReport =
            await remoteDataSource.getFinishingReport(conteainerId);
        return Right(finishingReport);
      } on DioException catch (error) {
        return Left(DioFailure(error: error));
      } catch (e) {
        print(e);
        return Left(UnknownFailure());
      }
    } else {
      return Left(InternetConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, void>> checkout(
      int containerId, CheckoutFormData checkoutFormData) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.checkout(containerId,
            CheckoutFormDataModel.fromEntity(checkoutFormData));

        return Right(true);
      } on DioException catch (error) {
        return Left(DioFailure(error: error));
      } catch (e) {
        // print(e);
        return Left(UnknownFailure());
      }
    } else {
      return Left(InternetConnectionFailure());
    }
  }

  void _checkForDuplication(
      {required List<ReceiptContainer> baseList,
      required List<ReceiptContainer> newFinishedReceipts}) {
    newFinishedReceipts.forEach((newFinishedReceipt) {
      if (baseList.contains(newFinishedReceipt)) {
        return;
      }
      baseList.add(newFinishedReceipt);
    });
  }

  @override
  void resetFinishedReceipts() {
    _finishedReceiptsList?.clear();
    _finishedReceiptsPage = 1;
  }
}

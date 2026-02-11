import 'dart:async';
import 'dart:ffi';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:tech_care_app/core/error/exceptions.dart';
import 'package:tech_care_app/core/error/failures.dart';
import 'package:tech_care_app/core/network/network_info.dart';
import 'package:tech_care_app/features/receipts/data/datasources/receipts_remote_data_source.dart';
import 'package:tech_care_app/features/receipts/domain/entities/receipt.dart';
import 'package:tech_care_app/features/receipts/domain/repositories/receipts_repository.dart';
import 'package:tech_care_app/features/receipts/presentation/bloc/receipts_bloc.dart';
import 'package:tech_care_app/features/receipts/presentation/widgets/receipt_card.dart';

class ReceiptsRepositoryImpl implements ReceiptsRepository {
  final ReceiptsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ReceiptsRepositoryImpl(
      {required this.networkInfo, required this.remoteDataSource});

  List<Receipt>? receivedList;
  List<Receipt>? maintenanceList;
  List<Receipt>? qualityList;

  int receivedPage = 1;
  int maintenancePage = 1;
  int qualityPage = 1;

  StreamController<ReceiptsEvent>? _receiptsStreamController;

  @override
  Future<Either<Failure, Stream<ReceiptsEvent>>> get receiptsEventStream async {
    if (_receiptsStreamController != null) {
      _receiptsStreamController?.close();
    }
    _receiptsStreamController = StreamController<ReceiptsEvent>();
    return Right(_receiptsStreamController!.stream);
  }

  void _sinkEvent(ReceiptsEvent event) {
    if (_receiptsStreamController?.hasListener == true) {
      _receiptsStreamController?.sink.add(event);
    }
  }

  @override
  Future<Either<Failure, void>> addToReceivedList(
      {Receipt? newReceipt,
      required ReceiptDisplayType receiptDisplayType}) async {
    if (receiptDisplayType == ReceiptDisplayType.maintenance) {
      _fromTo(
          source: maintenanceList!,
          target: receivedList!,
          newReceipt: newReceipt!);
    } else if (receiptDisplayType == ReceiptDisplayType.quality) {
      _fromTo(
          source: qualityList!, target: receivedList!, newReceipt: newReceipt!);
    }

    _sinkEvent(AddToReceivedList());

    return Right(Void);
  }

  void _fromTo({
    required List<Receipt> source,
    required List<Receipt> target,
    required Receipt newReceipt,
  }) {
    source.removeWhere((element) => element.id == newReceipt.id);
    target.removeWhere((element) => element.id == newReceipt.id);
    if (!target.contains(newReceipt)) {
      target.insert(0, newReceipt);
    }
  }

  @override
  Future<Either<Failure, List<Receipt>>> getReceivedList() async {
    if (receivedList == null || receivedList!.isEmpty) {
      if (await networkInfo.isConnected) {
        try {
          receivedList = await remoteDataSource.getReceivedList(receivedPage);
          receivedPage++;
        } on DioException catch (error) {
          return Left(DioFailure(error: error));
        } on ServerException {
          return Left(ServerFailure());
        } catch (e) {
          // print("what is the $e");
          return Left(UnknownFailure());
        }
      } else {
        return Left(InternetConnectionFailure());
      }
    }

    return Right(receivedList ?? []);
  }

  @override
  Future<Either<Failure, List<Receipt>>> getMaintenanceList() async {
    if (maintenanceList == null || maintenanceList!.isEmpty) {
      if (await networkInfo.isConnected) {
        try {
          maintenanceList =
              await remoteDataSource.getMaintenanceList(maintenancePage);
          maintenancePage++;
        } on DioException catch (error) {
          return Left(DioFailure(error: error));
        } on ServerException {
          return Left(ServerFailure());
        } catch (e) {
          // print(e);
          return Left(UnknownFailure());
        }
      } else {
        return Left(InternetConnectionFailure());
      }
    }

    return Right(maintenanceList ?? []);
  }

  @override
  Future<Either<Failure, List<Receipt>>> getQualityList() async {
    if (qualityList == null || qualityList!.isEmpty) {
      if (await networkInfo.isConnected) {
        try {
          qualityList = await remoteDataSource.getQualityList(qualityPage);
          qualityPage++;
        } on DioException catch (error) {
          return Left(DioFailure(error: error));
        } on ServerException {
          return Left(ServerFailure());
        } catch (e) {
          // print(e);
          return Left(UnknownFailure());
        }
      } else {
        return Left(InternetConnectionFailure());
      }
    }
    // _sinkEvent(LoadQualityList());
    return Right(qualityList ?? []);
  }

  @override
  Future<Either<Failure, List<Receipt>>> reloadReceivedList() async {
    receivedList?.clear();
    receivedPage = 1;
    return getReceivedList();
  }

  @override
  Future<Either<Failure, List<Receipt>>> reloadMaintenanceList() {
    maintenanceList?.clear();
    maintenancePage = 1;
    return getMaintenanceList();
  }

  @override
  Future<Either<Failure, List<Receipt>>> reloadQualityList() {
    qualityList?.clear();
    qualityPage = 1;
    return getQualityList();
  }

  @override
  Future<Either<Failure, List<Receipt>>> loadMoreReceivedReceipts() async {
    if (await networkInfo.isConnected) {
      try {
        int tempPage = receivedPage;
        final newReceipts =
            await remoteDataSource.getReceivedList(receivedPage);

        if (newReceipts.isNotEmpty) {
          _checkForDuplication(
              baseList: receivedList!, newReceipts: newReceipts);
          receivedPage = tempPage + 1;
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
    return Right(receivedList ?? []);
  }

  @override
  Future<Either<Failure, List<Receipt>>> loadMoreMaintenanceReceipts() async {
    if (await networkInfo.isConnected) {
      try {
        int tempPage = maintenancePage;
        final newReceipts =
            await remoteDataSource.getMaintenanceList(maintenancePage);
        if (newReceipts.isNotEmpty) {
          _checkForDuplication(
              baseList: maintenanceList!, newReceipts: newReceipts);
          maintenancePage = tempPage + 1;
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
    return Right(maintenanceList ?? []);
  }

  @override
  Future<Either<Failure, List<Receipt>>> loadMoreQualityReceipts() async {
    if (await networkInfo.isConnected) {
      try {
        int tempPage = qualityPage;
        final newReceipts = await remoteDataSource.getQualityList(qualityPage);

        if (newReceipts.isNotEmpty) {
          _checkForDuplication(
              baseList: qualityList!, newReceipts: newReceipts);
          qualityPage = tempPage + 1;
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
    return Right(qualityList ?? []);
  }

  void _checkForDuplication(
      {required List<Receipt> baseList, required List<Receipt> newReceipts}) {
    newReceipts.forEach((newReceipt) {
      if (baseList.contains(newReceipt)) {
        return;
      }
      baseList.add(newReceipt);
    });
  }

  @override
  void reset() {
    receivedList?.clear();
    maintenanceList?.clear();
    qualityList?.clear();
    receivedPage = 1;
    maintenancePage = 1;
    qualityPage = 1;
  }
}

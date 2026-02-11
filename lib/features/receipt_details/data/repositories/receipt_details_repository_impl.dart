import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:tech_care_app/core/error/failures.dart';
import 'package:tech_care_app/core/network/network_info.dart';
import 'package:tech_care_app/features/receipt_details/data/datasources/receipt_details_remote_data_source.dart';
import 'package:tech_care_app/features/receipt_details/domain/entities/device_info.dart';
import 'package:tech_care_app/features/receipt_details/domain/entities/receipt_details.dart';
import 'package:tech_care_app/features/receipt_details/domain/repositories/receipt_details_repository.dart';
import 'package:tech_care_app/features/receipt_details/presentation/bloc/receipt_details_bloc.dart';
import 'package:tech_care_app/features/receipts/domain/entities/receipt.dart';
import 'package:tech_care_app/features/receipts/presentation/widgets/receipt_card.dart';

class ReceiptDetailsRepostioryImpl implements ReceiptDetailsRepostiory {
  final NetworkInfo networkInfo;
  final ReceiptDetailsRemoteDataSource remoteDataSource;

  ReceiptDetailsRepostioryImpl({
    required this.networkInfo,
    required this.remoteDataSource,
  });
  StreamController<ReceiptDetailsEvent>? _streamController;
  ReceiptDetails? _receiptDetails;

  @override
  Future<Either<Failure, Stream<ReceiptDetailsEvent>>>
      get receiptDetailsStream {
    if (_streamController == null) {
      _streamController?.close();
    }
    _streamController = StreamController<ReceiptDetailsEvent>();

    return Future.value(Right(_streamController!.stream));
  }

  void _sinkEvent(ReceiptDetailsEvent event) {
    if (_streamController?.hasListener == true) {
      _streamController?.sink.add(event);
    }
  }

  @override
  void removeDeviceFromReceiptDetails(int deviceId) {
    _sinkEvent(RemoveFromDeviceReceiptDetails(deviceId: deviceId));
  }

  @override
  void editDeviceFromReceiptDetails(int deviceId, DeviceInfo deviceInfo) {
    _sinkEvent(EditDevice(deviceId: deviceId, deviceInfo: deviceInfo));
  }

  @override
  Future<Either<Failure, ReceiptDetails>> getReceiptDetailsByReceiptId(
      int receiptID, ReceiptDisplayType receiptDisplayType) async {
    if (await networkInfo.isConnected) {
      try {
        _receiptDetails = await remoteDataSource.receiptDetailsById(
            receiptID, receiptDisplayType);
        return Right(_receiptDetails!);
      } on DioException catch (error) {
        return Left(DioFailure(error: error));
      } catch (e) {
        print("what is the e $e");
        return Left(UnknownFailure());
      }
    } else {
      return Left(InternetConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, ReceiptDetails>> getReceiptDetailsByDeviceCode(
      String deviceCode, ReceiptDisplayType receiptDisplayType) async {
    if (await networkInfo.isConnected) {
      try {
        final ReceiptDetails receiptDetails = await remoteDataSource
            .receiptDetailsByDeviceCode(deviceCode, receiptDisplayType);
        return Right(receiptDetails);
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

  @override
  Future<Either<Failure, Receipt>> receiveDevices(
      List<String> deviceCodes) async {
    if (await networkInfo.isConnected) {
      try {
        final Receipt receipt =
            await remoteDataSource.ReceiveDevices(deviceCodes);
        return Right(receipt);
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
}

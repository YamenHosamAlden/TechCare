import 'dart:async';
import 'dart:ffi';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:tech_care_app/core/error/exceptions.dart';
import 'package:tech_care_app/core/error/failures.dart';
import 'package:tech_care_app/core/network/network_info.dart';
import 'package:tech_care_app/features/receipts_container_details/data/datasources/container-details_remote_data_source.dart';
import 'package:tech_care_app/features/receipts_container_details/data/models/container_details_model.dart';
import 'package:tech_care_app/features/receipts_container_details/data/models/device_details_model.dart';
import 'package:tech_care_app/features/receipts_container_details/domain/entities/container_details.dart';
import 'package:tech_care_app/features/receipts_container_details/domain/entities/device_details.dart';
import 'package:tech_care_app/features/receipts_container_details/domain/entities/device_info.dart';
import 'package:tech_care_app/features/receipts_container_details/domain/entities/device_payment_details.dart';
import 'package:tech_care_app/features/receipts_container_details/domain/repositories/container_details_repository.dart';
import 'package:tech_care_app/features/receipts_container_details/presentation/bloc/receipts_container_details_bloc/receipts_container_details_bloc.dart';
import 'package:tech_care_app/features/receipts_container_details/presentation/pages/receipts_container_details_page.dart';

class ContainerDetailsRepositoryImpl implements ContainerDetailsRepository {
  final NetworkInfo networkInfo;
  final ContainerDetailsRemoteDataSource remoteDataSource;

  ContainerDetailsRepositoryImpl({
    required this.networkInfo,
    required this.remoteDataSource,
  });
  late ContainerDetails _containerDetails;
  StreamController<ReceiptsContainerDetailsEvent>? _receiptsStreamController;

  @override
  Future<Either<Failure, Stream<ReceiptsContainerDetailsEvent>>>
      get receiptsContainerDetailsEventStream {
    if (_receiptsStreamController != null) {
      _receiptsStreamController?.close();
    }
    _receiptsStreamController =
        StreamController<ReceiptsContainerDetailsEvent>();
    return Future.value(Right(_receiptsStreamController!.stream));
  }

  void _sinkEvent(ReceiptsContainerDetailsEvent event) {
    if (_receiptsStreamController?.hasListener == true) {
      _receiptsStreamController?.sink.add(event);
    }
  }

  @override
  Future<Either<Failure, ContainerDetails>> getContainerDetails(
      int containerId, ContainerDisplayType displayType) async {
    if (await networkInfo.isConnected) {
      try {
        _containerDetails = await remoteDataSource.getContainerDetails(
            containerId, displayType);

        return Right(_containerDetails);
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
  Future<Either<Failure, void>> deleteReceipt(int containerId) async {
    if (await networkInfo.isConnected) {
      try {
        remoteDataSource.deleteReceipt(containerId);
        return Right(Void);
      } on DioException catch (error) {
        return Left(DioFailure(error: error));
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(InternetConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, void>> editReceiptDetails(
    ContainerDetails containerDetails,
    void Function(int, int)? onSendProgress,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.editReceiptDetails(
          ContainerDetailsModel.fromEntity(containerDetails),
          onSendProgress,
        );

        return Right(Void);
      } on DioException catch (error) {
        return Left(DioFailure(error: error));
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(InternetConnectionFailure());
    }
  }

  @override
  void editDeviceFromReceiptContainerDetails(
      int deviceId, DeviceInfo deviceInfo) {
    _sinkEvent(EditDevice(deviceId: deviceId, deviceInfo: deviceInfo));
  }

  @override
  Future<Either<Failure, void>> deleteDevice(int deviceId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteDevice(deviceId);
        removeDeviceFromReceiptContainerDetails(deviceId);
        return Right(Void);
      } on DioException catch (error) {
        return Left(DioFailure(error: error));
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(InternetConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, void>> editDevice(
    int deviceId,
    DeviceDetails deviceDetails,
    final void Function(int, int)? onSendProgress,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.editDevice(
          deviceId,
          DeviceDetailsModel.fromEntity(deviceDetails),
          onSendProgress,
        );
        return Right(Void);
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
  void removeDeviceFromReceiptContainerDetails(int deviceId) {
    _sinkEvent(RemoveFromDeviceList(deviceId: deviceId));
  }

  @override
  Future<Either<Failure, DeviceDetails>> getDeviceDetailsById(
      int deviceId) async {
    if (await networkInfo.isConnected) {
      try {
        final deviceDetails =
            await remoteDataSource.getDeviceDetailsById(deviceId);
        return Right(deviceDetails);
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
  void editReceiptFromReceiptContainerDetails(
      ContainerDetails containerDetails) {
    _sinkEvent(EditReceipt(containerDetails: containerDetails));
  }

  @override
  Future<Either<Failure, DevicePaymentDetails>> getDevicePaymentDetails(int deviceId) async{
     if (await networkInfo.isConnected) {
      try {
        final deviceDetails =
            await remoteDataSource.getDevicePaymentDetails(deviceId);
        return Right(deviceDetails);
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
}

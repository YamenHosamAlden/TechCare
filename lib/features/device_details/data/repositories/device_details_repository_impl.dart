import 'dart:async';
import 'dart:ffi';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:tech_care_app/core/error/failures.dart';
import 'package:tech_care_app/core/network/network_info.dart';
import 'package:tech_care_app/features/device_details/data/datasources/device_details_remote_data_source.dart';
import 'package:tech_care_app/features/device_details/domain/entities/device_details.dart';
import 'package:tech_care_app/features/device_details/domain/entities/process_report.dart';
import 'package:tech_care_app/features/device_details/domain/repositories/device_details_repository.dart';
import 'package:tech_care_app/features/device_details/presentation/bloc/device_details_bloc/device_details_bloc.dart';

class DeviceDetailsRepositoryImpl implements DeviceDetailsRepository {
  final DeviceDetailsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  StreamController<DeviceDetailsEvent>? _streamController;

  DeviceDetailsRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Stream<DeviceDetailsEvent>>> get eventStream {
    if (_streamController != null) {
      _streamController?.close();
    }
    _streamController = StreamController<DeviceDetailsEvent>();

    return Future.value(Right(_streamController!.stream));
  }

  @override
  Future<Either<Failure, DeviceDetails>> GetDeviceDetailsById(
      int deviceID) async {
    if (await networkInfo.isConnected) {
      try {
        final DeviceDetails deviceDetails =
            await remoteDataSource.DeviceDetailsById(deviceID);
        return Right(deviceDetails);
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
  Future<Either<Failure, DeviceDetails>> GetDeviceDetailsByCode(
      String deviceCode) async {
    if (await networkInfo.isConnected) {
      try {
        final DeviceDetails deviceDetails =
            await remoteDataSource.DeviceDetailsByCode(deviceCode);
        return Right(deviceDetails);
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
  Future<Either<Failure, void>> pauseTimer(int deviceID) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.puseTimer(deviceID);
        return Right(Void);
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
  Future<Either<Failure, void>> startTimer(int deviceID) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.startTimer(deviceID);
        return Right(Void);
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
  Future<Either<Failure, ProcessReport>> addNote(
      int deviceID, String note) async {
    if (await networkInfo.isConnected) {
      try {
        final ProcessReport report =
            await remoteDataSource.addNote(deviceID, note);

        return Right(report.copyWith(isRecentlyAdded: true));
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
  void addReport(ProcessReport report) {
    _sinkEvent(AddReport(report: report));
  }

  void _sinkEvent(DeviceDetailsEvent event) {
    if (_streamController?.hasListener == true) {
      _streamController?.sink.add(event);
    }
  }

  @override
  Future<Either<Failure, ProcessReport>> unreceiveDevice(
      int deviceID, String reason) async {
    if (await networkInfo.isConnected) {
      try {
        final report = await remoteDataSource.unreceiveDevice(deviceID, reason);
        return Right(report.copyWith(isRecentlyAdded: true));
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

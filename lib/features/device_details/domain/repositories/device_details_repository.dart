import 'package:dartz/dartz.dart';
import 'package:tech_care_app/core/error/failures.dart';
import 'package:tech_care_app/features/device_details/domain/entities/device_details.dart';
import 'package:tech_care_app/features/device_details/domain/entities/process_report.dart';
import 'package:tech_care_app/features/device_details/presentation/bloc/device_details_bloc/device_details_bloc.dart';

abstract class DeviceDetailsRepository {
  Future<Either<Failure, Stream<DeviceDetailsEvent>>> get eventStream;
  Future<Either<Failure, DeviceDetails>> GetDeviceDetailsById(int deviceID);
  Future<Either<Failure, DeviceDetails>> GetDeviceDetailsByCode(
      String deviceCode);
  Future<Either<Failure, void>> startTimer(int deviceID);
  Future<Either<Failure, void>> pauseTimer(int deviceID);
  Future<Either<Failure, ProcessReport>> addNote(int deviceID, String note);
  Future<Either<Failure, ProcessReport>> unreceiveDevice(
      int deviceID, String reason);
  void addReport(ProcessReport report);
}

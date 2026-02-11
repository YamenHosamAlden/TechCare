import 'package:dartz/dartz.dart';
import 'package:tech_care_app/core/error/failures.dart';
import 'package:tech_care_app/features/saerch/domain/entity/device_info.dart';
import 'package:tech_care_app/features/saerch/domain/entity/receipt_container.dart';

abstract class SearchRepository {
  Future<Either<Failure, List<ReceiptContainer>>> searchByReceipt(String term);
  Future<Either<Failure, List<DeviceInfo>>> searchByDevice(String term);

  Future<Either<Failure, List<ReceiptContainer>>> loadMoreSearchByReceipt(
      String term, int page);
  Future<Either<Failure, List<DeviceInfo>>> loadMoreSearchByDevice(
      String term, int page);
}

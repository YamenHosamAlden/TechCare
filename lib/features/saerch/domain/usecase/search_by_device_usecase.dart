import 'package:dartz/dartz.dart';
import 'package:tech_care_app/core/error/failures.dart';
import 'package:tech_care_app/core/usecases/usecase.dart';
import 'package:tech_care_app/features/saerch/domain/entity/device_info.dart';
import 'package:tech_care_app/features/saerch/domain/repository/search_repository.dart';

class SearchByDeviceUsecase extends Usecase<List<DeviceInfo>, String> {
  final SearchRepository repository;
  SearchByDeviceUsecase({required this.repository});

  @override
  Future<Either<Failure, List<DeviceInfo>>> call(String term) {
    return repository.searchByDevice(term);
  }
}

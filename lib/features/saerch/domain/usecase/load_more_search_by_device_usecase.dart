

import 'package:dartz/dartz.dart';
import 'package:tech_care_app/core/error/failures.dart';
import 'package:tech_care_app/core/usecases/usecase.dart';
import 'package:tech_care_app/features/saerch/domain/entity/device_info.dart';
import 'package:tech_care_app/features/saerch/domain/repository/search_repository.dart';

class LoadMoreSearchByDeviceUsecase extends Usecase<List<DeviceInfo>, SearchByDeviceParams> {
  final SearchRepository repository;
  LoadMoreSearchByDeviceUsecase({required this.repository});

  @override
  Future<Either<Failure, List<DeviceInfo>>> call(SearchByDeviceParams searchByDeviceParams) {
    return repository.loadMoreSearchByDevice(searchByDeviceParams.trem,searchByDeviceParams.page);
  }
}










class SearchByDeviceParams {
  final int page;
  final String trem;
  SearchByDeviceParams({
    required this.page,
    required this.trem,
  });
}

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:tech_care_app/core/error/failures.dart';
import 'package:tech_care_app/core/network/network_info.dart';
import 'package:tech_care_app/features/saerch/data/datasource/search_remote_data_source.dart';
import 'package:tech_care_app/features/saerch/data/model/device_info_model.dart';
import 'package:tech_care_app/features/saerch/domain/entity/device_info.dart';
import 'package:tech_care_app/features/saerch/domain/entity/receipt_container.dart';
import 'package:tech_care_app/features/saerch/domain/repository/search_repository.dart';

class SearchRepositoryImpl implements SearchRepository {
  final NetworkInfo networkInfo;
  final SearchRemoteDataSource remoteDataSource;

  SearchRepositoryImpl(
      {required this.networkInfo, required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ReceiptContainer>>> searchByReceipt(
      String term) async {
    if (await networkInfo.isConnected) {
      try {
        final List<ReceiptContainer> receipts =
            await remoteDataSource.searchByReceipt(term, 1);
        return Right(receipts);
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
  Future<Either<Failure, List<DeviceInfo>>> searchByDevice(String term) async {
    if (await networkInfo.isConnected) {
      try {
        final List<DeviceInfoModel> devices =
            await remoteDataSource.searchByDevice(term, 1);
        return Right(devices);
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
  Future<Either<Failure, List<DeviceInfo>>> loadMoreSearchByDevice(
      String term, int page) async {
    if (await networkInfo.isConnected) {
      try {
        final List<DeviceInfoModel> devices =
            await remoteDataSource.searchByDevice(term, page);
        return Right(devices);
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
  Future<Either<Failure, List<ReceiptContainer>>> loadMoreSearchByReceipt(
      String term, int page) async {
    if (await networkInfo.isConnected) {
      try {
        final List<ReceiptContainer> receipts =
            await remoteDataSource.searchByReceipt(term, page);
        return Right(receipts);
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

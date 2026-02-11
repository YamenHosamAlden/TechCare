import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:tech_care_app/core/error/exceptions.dart';
import 'package:tech_care_app/core/error/failures.dart';
import 'package:tech_care_app/core/network/network_info.dart';
import 'package:tech_care_app/features/create_receipt/domain/repositories/load_resources_repository.dart';
import 'package:tech_care_app/features/create_receipt/data/datasources/craete_receipt_remote_data_source.dart';
import 'package:tech_care_app/features/create_receipt/domain/entities/collection.dart';
import 'package:tech_care_app/features/create_receipt/domain/entities/device_resoucres.dart';
import 'package:tech_care_app/features/create_receipt/domain/entities/company.dart';
import 'package:tech_care_app/features/create_receipt/domain/entities/device_type.dart';

class LoadResourcesRepositoryImpl implements LoadResourcesRepository {
  final CreateReceiptRemoteDateSource remoteDataSource;
  final NetworkInfo networkInfo;

  LoadResourcesRepositoryImpl(
      {required this.remoteDataSource, required this.networkInfo});

  List<Company>? companies;
  List<DeviceType>? deviceTypes;

  bool _resourcesLoaded() {
    return (companies != null && deviceTypes != null) &&
        (companies!.isNotEmpty && deviceTypes!.isNotEmpty);
  }

  Future<Either<Failure, List<Company>>> _loadCompanies() async {
    if (companies == null) {
      try {
        final _companies = await remoteDataSource.getCompanies();
        return Right(_companies);
      } on ServerException {
        return Left(ServerFailure());
      } on DioException catch (error) {
        return Left(DioFailure(error: error));
      } catch (e) {
        print("-- :" + e.toString());
        return Left(UnknownFailure());
      }
    } else {
      return Right(companies!);
    }
  }

  Future<Either<Failure, List<DeviceType>>> _loadDeviceTypes() async {
    if (deviceTypes == null) {
      try {
        final _deviceTypes = await remoteDataSource.getDeviceTypes();
        return Right(_deviceTypes);
      } on DioException catch (error) {
        return Left(DioFailure(error: error));
      } on ServerException {
        return Left(ServerFailure());
      } catch (e) {
        print("-- :" + e.toString());

        return Left(UnknownFailure());
      }
    } else {
      return Right(deviceTypes!);
    }
  }

  @override
  Future<Either<Failure, DeviceResources>> loadResources() async {

    if (!_resourcesLoaded()) {
     
      if (await networkInfo.isConnected) {
        late final Either<Failure, List<Company>> loadCompaniesResult;
        late final Either<Failure, List<DeviceType>> loadTypesResult;
        await Future.wait([
          _loadCompanies()..then((value) => loadCompaniesResult = value),
          _loadDeviceTypes()..then((value) => loadTypesResult = value)
        ]);

        Failure? _tempFailure;

        loadCompaniesResult.fold((failure) => _tempFailure = failure,
            (_companies) => companies = _companies);

        loadTypesResult.fold((failure) => _tempFailure = failure,
            (types) => deviceTypes = types);

        if (_tempFailure != null) {
          return Left(_tempFailure!);
        }
      } else {
        return Left(InternetConnectionFailure());
      }
    }
    return Right(
        DeviceResources(companies: companies ?? [], types: deviceTypes ?? []));
  }

  @override
  Future<Either<Failure, bool>> checkDeviceCodeFromCollection(
    String deviceCode,
    List<Collection> collectionList,
    String? codeFromEdit,
  ) async {
    bool valid =
        collectionList.any((collection) => collection.devices.any((device) {
              if (codeFromEdit != null && deviceCode == codeFromEdit) {
                return !(device.deviceCode == deviceCode);
              }
              return device.deviceCode == deviceCode;
            }));

    return Right(valid);
  }

  @override
  Future<Either<Failure, bool>> checkDeviceCodeFromApi(
      String deviceCode) async {
    try {
      bool valid = await remoteDataSource.checkDeviceCode(deviceCode);
      return Right(!valid);
    } on ServerException {
      return Left(ServerFailure());
    } on DioException catch (error) {
      return Left(DioFailure(error: error));
    } catch (e) {
      print("-- :" + e.toString());
      return Left(UnknownFailure());
    }
  }

  @override
  void reset() {
    companies?.clear();
    deviceTypes?.clear();
    companies = null;
    deviceTypes = null;
  }
}

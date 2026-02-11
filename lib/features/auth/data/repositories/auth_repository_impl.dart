import 'dart:async';
import 'dart:ffi';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:tech_care_app/core/error/exceptions.dart';
import 'package:tech_care_app/core/error/failures.dart';
import 'package:tech_care_app/core/network/network_info.dart';
import 'package:tech_care_app/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:tech_care_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:tech_care_app/features/auth/domain/repositories/auth_repository.dart';

typedef _FailureOrType<T> = Future<Either<Failure, T>>;

class AuthRepositoryImpl implements AuthRepository {
  final NetworkInfo networkInfo;
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final _controller = StreamController<AuthenticationStatus>();

  String? token;

  AuthRepositoryImpl({
    required this.networkInfo,
    required this.remoteDataSource,
    required this.localDataSource,
  });

  void _sinkUnauthenticatedStatus() =>
      _controller.sink.add(AuthenticationStatus.unauthenticated);

  void _sinkAuthenticatedStatus() =>
      _controller.sink.add(AuthenticationStatus.authenticated);

  @override
  Future<Either<Failure, Stream<AuthenticationStatus>>> get status {
    return Future.value(Right(_statusStream));
  }

  Stream<AuthenticationStatus> get _statusStream async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield AuthenticationStatus.unknown;
    yield* _controller.stream;
  }

  @override
  _FailureOrType<void> login(String userName, String passWord) async {
    if (await networkInfo.isConnected) {
      try {
        token = await remoteDataSource.login(userName, passWord);
        await localDataSource.cacheToken(token!);

        _setAuthorizationHeader(token);
        _sinkAuthenticatedStatus();
        return Right(Void);
      } on LoginExcption catch (loginExcption) {
        return Left(LoginFailure(msg: loginExcption.msg));
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

  @override
  _FailureOrType<void> logout() async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.logout();
        await localDataSource.deleteCachedToken();
        token = null;
        _sinkUnauthenticatedStatus();
      } on DioException catch (error) {
        return Left(DioFailure(error: error));
      } catch (e) {
        // print("logout catch exiption :$e");
        return Left(UnknownFailure());
      }
      return Right(Void);
    } else {
      return Left(InternetConnectionFailure());
    }
  }

  @override
  _FailureOrType<void> validateSavedToken() async {
    if (await networkInfo.isConnected) {
      try {
        token = await localDataSource.getCachedToken();
        await remoteDataSource.validateToken(token!);
        _setAuthorizationHeader(token);
        _sinkAuthenticatedStatus();
      } on UnauthenticatedException {
        _sinkUnauthenticatedStatus();
      } on CacheException {
        _sinkUnauthenticatedStatus();
      } on ServerException {
        return Left(ServerFailure());
      } on DioException catch (error) {
          return Left(DioFailure(error: error));
        }
      catch (e) {
        // print(e);
        return Left((UnknownFailure()));
      }
      return Right(Void);
    } else {
      return Left(InternetConnectionFailure());
    }
  }

  void _setAuthorizationHeader(String? token) {
    (remoteDataSource as AuthRemoteDataSourceImpl)
        .dio
        .options
        .headers['Authorization'] = 'Bearer $token';
  }
}

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:tech_care_app/core/entities/translatable_value.dart';

abstract class Failure extends Equatable {
  @override
  List<Object?> get props => [];
}

class ServerFailure extends Failure {}

class CacheFailure extends Failure {}

class InternetConnectionFailure extends Failure {}

class UnknownFailure extends Failure {}

class NotFoundFailure extends Failure {}

class DioFailure extends Failure {
  final DioException  error;
  DioFailure({required this.error});
}

class LoginFailure extends Failure {
  final TranslatableValue msg;
  LoginFailure({required this.msg});
}

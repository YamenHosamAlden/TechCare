import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tech_care_app/core/error/failures.dart';

abstract class Usecase<ReturnType, Params> {
  Future<Either<Failure, ReturnType>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}

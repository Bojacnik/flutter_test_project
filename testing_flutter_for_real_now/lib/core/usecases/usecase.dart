import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:testing_flutter_for_real_now/core/error/failures.dart';
import 'package:testing_flutter_for_real_now/features/number_trivia/domain/entities/number_trivia.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, NumberTrivia>> call(Params params);
}

class NoParams extends Equatable {}

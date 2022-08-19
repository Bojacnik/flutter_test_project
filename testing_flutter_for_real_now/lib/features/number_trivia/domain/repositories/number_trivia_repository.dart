import 'package:dartz/dartz.dart';

import 'package:dartz/dartz.dart';
import 'package:testing_flutter_for_real_now/core/error/failures.dart';
import 'package:testing_flutter_for_real_now/features/number_trivia/domain/entities/number_trivia.dart';

abstract class NumberTriviaRepository {
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number);
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia();
}

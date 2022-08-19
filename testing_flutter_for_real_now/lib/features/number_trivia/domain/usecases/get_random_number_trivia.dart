import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:testing_flutter_for_real_now/core/error/failures.dart';
import 'package:testing_flutter_for_real_now/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:testing_flutter_for_real_now/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';

import '../../../../core/usecases/usecase.dart';
import '../repositories/number_trivia_repository.dart';

class GetRandomNumberTrivia implements UseCase<NumberTrivia, NoParams> {
  final NumberTriviaRepository repository;

  GetRandomNumberTrivia(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>> call(NoParams params) async {
    return await repository.getRandomNumberTrivia();
  }
}

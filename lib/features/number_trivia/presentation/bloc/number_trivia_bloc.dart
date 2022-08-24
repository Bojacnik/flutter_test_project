import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/util/input_converter.dart';
import '../../domain/entities/number_trivia.dart';
import '../../domain/usecases/get_concrete_number_trivia.dart';
import '../../domain/usecases/get_random_number_trivia.dart';
import './bloc.dart';

const String serverFailureMessage = 'Server Failure';
const String cacheFailureMessage = 'Cache Failure';
const String invalidInputFailureMessage =
    'Invalid Input - The number must be a positive integer or zero.';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;
  final NumberTriviaState initialState;

  NumberTriviaBloc(
      {@required GetConcreteNumberTrivia concrete,
      @required GetRandomNumberTrivia random,
      @required this.inputConverter,
      NumberTriviaState state = const Empty()})
      : getConcreteNumberTrivia = concrete,
        getRandomNumberTrivia = random,
        initialState = state,
        super(state) {
    on<GetTriviaForConcreteNumber>(_onGetTriviaForConcreteNumberHandler);
    on<GetTriviaForRandomNumber>(_onGetTriviaForRandomNumberHandler);
  }
  Future<void> _onGetTriviaForConcreteNumberHandler(
      GetTriviaForConcreteNumber event, Emitter<NumberTriviaState> emit) async {
    final inputEither =
        inputConverter.stringToUnsignedInteger(event.numberString);

    await inputEither.fold(
      (failure) async {
        emit(const Error(message: invalidInputFailureMessage));
      },
      (integer) async {
        emit(const Loading());
        final failureOrTrivia =
            await getConcreteNumberTrivia(Params(number: integer));
        emit(_eitherLoadedOrErrorState(failureOrTrivia));
      },
    );
  }

  Future<void> _onGetTriviaForRandomNumberHandler(
      GetTriviaForRandomNumber event, Emitter<NumberTriviaState> emit) async {
    emit(const Loading());
    final failureOrTrivia = await getRandomNumberTrivia(NoParams());
    emit(_eitherLoadedOrErrorState(failureOrTrivia));
  }

  NumberTriviaState _eitherLoadedOrErrorState(
    Either<Failure, NumberTrivia> failureOrTrivia,
  ) {
    return failureOrTrivia.fold(
      (failure) => Error(message: _mapFailureToMessage(failure)),
      (trivia) => Loaded(trivia: trivia),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return serverFailureMessage;
      case CacheFailure:
        return cacheFailureMessage;
      default:
        return 'Unexpected error';
    }
  }
}

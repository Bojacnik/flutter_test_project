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

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
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

    inputEither.fold(
      (failure) async {
        emit(const Error(message: INVALID_INPUT_FAILURE_MESSAGE));
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
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected error';
    }
  }
}

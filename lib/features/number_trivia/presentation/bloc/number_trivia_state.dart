import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../domain/entities/number_trivia.dart';

@immutable
abstract class NumberTriviaState extends Equatable {
  const NumberTriviaState() : super();
}

class Empty extends NumberTriviaState {
  const Empty() : super();

  @override
  List<Object> get props => [];
}

class Loading extends NumberTriviaState {
  const Loading() : super();

  @override
  List<Object> get props => [];
}

class Loaded extends NumberTriviaState {
  final NumberTrivia trivia;

  const Loaded({@required this.trivia}) : super();

  @override
  List<Object> get props => [trivia];
}

class Error extends NumberTriviaState {
  final String message;

  const Error({@required this.message}) : super();

  @override
  List<Object> get props => [message];
}

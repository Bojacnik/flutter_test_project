import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class NumberTriviaEvent extends Equatable {
  const NumberTriviaEvent() : super();
}

class GetTriviaForConcreteNumber extends NumberTriviaEvent {
  final String numberString;

  const GetTriviaForConcreteNumber(this.numberString) : super();

  @override
  List<Object> get props => [numberString];
}

class GetTriviaForRandomNumber extends NumberTriviaEvent {
  @override
  List<Object> get props => [];
}

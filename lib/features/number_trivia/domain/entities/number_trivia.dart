import 'package:equatable/equatable.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';

class NumberTrivia extends Equatable {
  final String text;
  final int number;

  const NumberTrivia({
    @required this.text,
    @required this.number,
  }) : super();

  @override
  List<Object> get props => [text, number];
}

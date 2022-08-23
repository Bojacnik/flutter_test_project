import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final List<dynamic> properties;

  const Failure([this.properties = const <dynamic>[]]) : super();
}

//General failures

class ServerFailure extends Failure {
  @override
  List<Object> get props => [properties];
}

class CacheFailure extends Failure {
  @override
  List<Object> get props => [properties];
}

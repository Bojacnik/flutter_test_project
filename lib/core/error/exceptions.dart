class ServerException implements Exception {
  //final String message;
  //if we want it to be descriptive
}

class CacheException implements Exception {}

class UnknownStateException implements Exception {
  final String message;

  UnknownStateException(this.message);
}

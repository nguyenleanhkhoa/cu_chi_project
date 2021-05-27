class CustomException implements Exception {
  final _message;
  final _prefix;
  final _statusCode;

  CustomException([this._message, this._prefix, this._statusCode]);

  String toString() {
    return "$_prefix$_message$_statusCode";
  }
}

class FetchDataException extends CustomException {
  FetchDataException(String message, int statusCode)
      : super(message, "Error During Communication: ", statusCode);
}

class BadRequestException extends CustomException {
  BadRequestException(String message, int statusCode)
      : super(message, "Invalid Request: ", statusCode);
}

class UnauthorisedException extends CustomException {
  UnauthorisedException(String message, int statusCode)
      : super(message, "Unauthorised: ", statusCode);
}

class InvalidInputException extends CustomException {
  InvalidInputException(String message, int statusCode)
      : super(message, "Invalid Input: ", statusCode);
}

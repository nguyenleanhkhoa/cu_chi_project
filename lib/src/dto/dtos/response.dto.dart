class ResponseDto {
  int statusCode;
  dynamic message;
  dynamic result;

  ResponseDto({this.statusCode, this.message, this.result});
}

class ErrorRequest {
  int status;
  String error;
  String exception;
  ErrorRequest({this.status, this.error, this.exception});
  ErrorRequest.fromJson(Map<String, dynamic> json)
      : status = json["status"] == null ? null : (json["status"]),
        error = json["error"] == null ? null : (json["error"]),
        exception = json["exception"] == null ? null : (json["exception"]);
}

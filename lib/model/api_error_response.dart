class ApiErrorResponse {
  bool? success;
  String? message;
  Error? error;

  ApiErrorResponse({this.success, this.message, this.error});

  ApiErrorResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    error = json['error'] != null ? new Error.fromJson(json['error']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.error != null) {
      data['error'] = this.error!.toJson();
    }
    return data;
  }
}

class Error {
  String? message;
  String? code;
  String? time;
  String? requestId;
  int? statusCode;
  bool? retryable;
  double? retryDelay;

  Error(
      {this.message,
        this.code,
        this.time,
        this.requestId,
        this.statusCode,
        this.retryable,
        this.retryDelay});

  Error.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    code = json['code'];
    time = json['time'];
    requestId = json['requestId'];
    statusCode = json['statusCode'];
    retryable = json['retryable'];
    retryDelay = json['retryDelay'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['code'] = this.code;
    data['time'] = this.time;
    data['requestId'] = this.requestId;
    data['statusCode'] = this.statusCode;
    data['retryable'] = this.retryable;
    data['retryDelay'] = this.retryDelay;
    return data;
  }
}

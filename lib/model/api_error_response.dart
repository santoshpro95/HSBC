class ApiErrorResponse {
  Error? error;

  ApiErrorResponse({this.error});

  ApiErrorResponse.fromJson(Map<String, dynamic> json) {
    error = json['error'] != null ? new Error.fromJson(json['error']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.error != null) {
      data['error'] = this.error!.toJson();
    }
    return data;
  }
}

class Error {
  String? code;
  String? message;
  Null? param;
  String? type;

  Error({this.code, this.message, this.param, this.type});

  Error.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    param = json['param'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    data['param'] = this.param;
    data['type'] = this.type;
    return data;
  }
}

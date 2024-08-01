class AvatarVideoResponse {
  String? status;
  String? url;

  AvatarVideoResponse({this.status, this.url});

  AvatarVideoResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['url'] = this.url;
    return data;
  }
}

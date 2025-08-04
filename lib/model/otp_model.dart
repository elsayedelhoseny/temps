class OTPModel {
  String? error;
  String? otp;

  OTPModel({this.error, this.otp});

  OTPModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    otp = json['otp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['otp'] = this.otp;
    return data;
  }
}

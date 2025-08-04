
class RemoteJsonHashValue {
  String? value;
  String? expiryDate;
  bool? isBlocked;

  RemoteJsonHashValue({
    required this.value,
    required this.expiryDate,
    required this.isBlocked,
  });

  factory RemoteJsonHashValue.fromJson(Map<String, dynamic> json) => RemoteJsonHashValue(
    value: json["value"],
    expiryDate: json["expiry_date"],
    isBlocked: json["is_blocked"],
  );

  Map<String, dynamic> toJson() => {
    "value": value,
    "expiry_date": expiryDate,
    "is_blocked": isBlocked,
  };
}

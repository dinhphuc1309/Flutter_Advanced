class DeviceInfo {
  String model;
  DeviceInfo({required this.model});

  Map<String, dynamic> toJson() {
    return {
      'model': model,
    };
  }

  factory DeviceInfo.fromJson(Map<String, dynamic> json) {
    return DeviceInfo(
      model: json['model'] as String,
    );
  }
}

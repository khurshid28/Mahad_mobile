class DeviceModel {
  final int id;
  final int userId;
  final String role;
  final String deviceName;
  final String deviceType;
  final String deviceIdentifier;
  final String? ipAddress;
  final String? userAgent;
  final bool isActive;
  final DateTime lastActive;
  final String? lastApiEndpoint;
  final String? lastApiMethod;
  final String? appVersion;
  final DateTime createdAt;
  final DateTime updatedAt;

  DeviceModel({
    required this.id,
    required this.userId,
    required this.role,
    required this.deviceName,
    required this.deviceType,
    required this.deviceIdentifier,
    this.ipAddress,
    this.userAgent,
    required this.isActive,
    required this.lastActive,
    this.lastApiEndpoint,
    this.lastApiMethod,
    this.appVersion,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      id: json['id'],
      userId: json['user_id'],
      role: json['role'],
      deviceName: json['device_name'],
      deviceType: json['device_type'],
      deviceIdentifier: json['device_identifier'],
      ipAddress: json['ip_address'],
      userAgent: json['user_agent'],
      isActive: json['is_active'],
      lastActive: DateTime.parse(json['last_active']),
      lastApiEndpoint: json['last_api_endpoint'],
      lastApiMethod: json['last_api_method'],
      appVersion: json['app_version'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

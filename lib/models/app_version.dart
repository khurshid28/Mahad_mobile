class AppVersion {
  final String version;

  AppVersion({
    required this.version,
  });

  factory AppVersion.fromJson(Map<String, dynamic> json) {
    return AppVersion(
      version: json['version'] as String? ?? '1.0.0',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'version': version,
    };
  }
}

class AppInfo {
  String appId;
  String defaultACL;
  bool allowACLOverride;

  AppInfo(
      {required this.appId,
      required this.defaultACL,
      required this.allowACLOverride});

  factory AppInfo.fromJson(Map<String, dynamic> json) {
    return AppInfo(
      appId: json['appId'] ?? '',
      defaultACL: json['defaultACL'] ?? '',
      allowACLOverride: json['allowACLOverride'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appId': appId,
      'defaultACL': defaultACL,
      'allowACLOverride': allowACLOverride,
    };
  }

  @override
  String toString() {
    return 'AppInfo{appId: $appId, defaultACL: $defaultACL, allowACLOverride: $allowACLOverride}';
  }
}

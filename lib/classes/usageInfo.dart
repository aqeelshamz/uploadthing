class UsageInfo {
  int totalBytes;
  int appTotalBytes;
  int filesUploaded;
  int limitBytes;

  UsageInfo({
    required this.totalBytes,
    required this.appTotalBytes,
    required this.filesUploaded,
    required this.limitBytes,
  });

  factory UsageInfo.fromJson(Map<String, dynamic> json) {
    return UsageInfo(
      totalBytes: json['totalBytes'] ?? 0,
      appTotalBytes: json['appTotalBytes'] ?? 0,
      filesUploaded: json['filesUploaded'] ?? 0,
      limitBytes: json['limitBytes'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalBytes': totalBytes,
      'appTotalBytes': appTotalBytes,
      'filesUploaded': filesUploaded,
      'limitBytes': limitBytes,
    };
  }

  @override
  String toString() {
    return 'UsageInfo{totalBytes: $totalBytes, appTotalBytes: $appTotalBytes, filesUploaded: $filesUploaded, limitBytes: $limitBytes}';
  }
}

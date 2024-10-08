class UploadThingFile {
  String id;
  String key;
  String name;
  String customId;
  String status;

  UploadThingFile(
      {required this.id,
      required this.key,
      required this.name,
      required this.customId,
      required this.status});

  factory UploadThingFile.fromJson(Map<String, dynamic> json) {
    return UploadThingFile(
      id: json['id'] ?? '',
      key: json['key'] ?? '',
      name: json['name'] ?? '',
      customId: json['customId'] ?? '',
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'key': key,
      'name': name,
      'customId': customId,
      'status': status,
    };
  }

  @override
  String toString() {
    return 'UploadThingFile{id: $id, key: $key, name: $name, customId: $customId, status: $status}';
  }
}

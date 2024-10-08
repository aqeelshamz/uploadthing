library uploadthing;

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

const String apiUrl = "https://api.uploadthing.com/v6";

/// A class to handle file uploads to the UploadThing API.
class UploadThing {
  /// The API key for authenticating with the UploadThing API.
  final String _apiKey;

  /// The total number of files to be uploaded.
  int totalFiles = 0;

  /// The number of files that have been successfully uploaded.
  int uploadedFiles = 0;

  /// A list to store data about the uploaded files.
  List<Map<String, dynamic>> uploadedFilesData = [];

  /// Creates an instance of [UploadThing] with the given [apiKey].
  UploadThing(this._apiKey);

  /// Uploads a list of [files] to the UploadThing API.
  ///
  /// This method will upload each file in the [files] list and update the
  /// [totalFiles], [uploadedFiles], and [uploadedFilesData] properties
  /// accordingly.
  ///
  /// Throws an [Exception] if the upload fails.
  Future<void> uploadFile(List<File> files) async {
    totalFiles = files.length;
    List<Map<String, dynamic>> filesData = [];

    // Prepare file data for the API request
    for (var file in files) {
      int fileSize = file.lengthSync();
      String fileName = file.path.split("/").last;
      String mimeType = lookupMimeType(file.path)!;

      filesData.add({"name": fileName, "size": fileSize, "type": mimeType});
    }

    var url = Uri.parse("$apiUrl/uploadFiles");
    Map<String, String> headers = {
      "X-Uploadthing-Api-Key": _apiKey,
      "Content-Type": "application/json"
    };

    // Send the initial request to get upload URLs
    var request = await http.post(url,
        headers: headers,
        body: jsonEncode({
          "files": filesData,
          "acl": "public-read",
          "contentDisposition": "inline"
        }));

    if (request.statusCode == 200) {
      Map<String, dynamic> response = jsonDecode(request.body);

      // Upload each file to the provided URLs
      for (Map data in response["data"]) {
        var request = http.MultipartRequest("POST", Uri.parse(data["url"]));
        request.fields["acl"] = "public-read";
        request.fields["bucket"] = data["fields"]["bucket"];
        request.fields["key"] = data["fields"]["key"];
        request.fields["Policy"] = data["fields"]["Policy"];
        File file = files
            .firstWhere((element) => element.path.contains(data["fileName"]));
        request.files.add(http.MultipartFile(
            "file", file.readAsBytes().asStream(), file.lengthSync(),
            filename: data["fileName"],
            contentType: MediaType.parse(lookupMimeType(file.path)!)));
        request.fields["X-Amz-Signature"] = data["fields"]["X-Amz-Signature"];
        request.fields["X-Amz-Algorithm"] = data["fields"]["X-Amz-Algorithm"];
        request.fields["X-Amz-Credential"] = data["fields"]["X-Amz-Credential"];
        request.fields["X-Amz-Date"] = data["fields"]["X-Amz-Date"];
        request.fields["Content-Type"] = lookupMimeType(file.path)!;
        request.fields["Content-Disposition"] =
            'inline; filename="${data["fileName"]}"; filename*=UTF-8\'\'${data["fileName"]}';

        var response = await request.send();

        if (response.statusCode == 204) {
          uploadedFiles++;
          uploadedFilesData.add({
            "url": data["fileUrl"],
            "fileName": data["fileName"],
            "size": file.lengthSync(),
            "type": lookupMimeType(file.path)!
          });
        } else {
          throw Exception("Failed to upload file");
        }
      }
    } else {
      throw Exception("Failed to upload file");
    }
  }
}

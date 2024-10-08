library uploadthing;

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:uploadthing/classes/UploadThingFile.dart';
import 'package:uploadthing/utils/utils.dart';

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
  /// Returns `true` if the upload is successful.
  Future<bool> uploadFile(List<File> files) async {
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

    return true;
  }

  /// Lists the files uploaded to the UploadThing API.
  ///
  /// This method sends a request to the UploadThing API to retrieve a list of files.
  /// The [limit] parameter specifies the maximum number of files to retrieve (default is 500).
  /// The [offset] parameter specifies the number of files to skip before starting to collect the result set (default is 0).
  ///
  /// Throws an [Exception] if the request fails.
  /// Returns a [Future] that completes with a list of [UploadThingFile] objects.
  ///
  /// Example:
  /// ```dart
  /// List<UploadThingFile> files = await uploadThing.listFiles(limit: 100, offset: 0);
  /// print(files);
  /// ```
  Future<List<UploadThingFile>> listFiles(
      {int limit = 500, int offset = 0}) async {
    var url = Uri.parse("$apiUrl/listFiles");
    Map<String, String> headers = {
      "X-Uploadthing-Api-Key": _apiKey,
      "Content-Type": "application/json"
    };

    var request = await http.post(url,
        headers: headers, body: jsonEncode({"limit": limit, "offset": offset}));

    if (request.statusCode == 200) {
      Map<String, dynamic> response = jsonDecode(request.body);
      return List<UploadThingFile>.from(
          response["files"].map((x) => UploadThingFile.fromJson(x)));
    } else {
      throw Exception("Failed to list files");
    }
  }
}

/// Returns the URL for a file given its [key].
///
/// The [key] is a unique identifier for the file.
/// This function constructs the URL using the base URL and the provided [key].
///
/// Example:
/// ```dart
/// String url = getFileUrl("exampleKey");
/// print(url); // Output: https://utfs.io/f/exampleKey
/// ```
String getFileUrl(String key) {
  return "https://utfs.io/f/$key";
}

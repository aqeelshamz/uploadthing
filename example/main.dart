import 'dart:io';
import 'package:uploadthing/uploadthing.dart';

void main() async {
  // Replace with your actual API key
  final uploadThing = UploadThing('your_api_key_here');

  // List of files to upload
  List<File> files = [
    File('path/to/your/file1.png'),
    File('path/to/your/file2.txt'),
  ];

  try {
    // Upload the files
    bool isUploaded = await uploadThing.uploadFiles(files);
    if (isUploaded) {
      print('Upload complete');
      print('Uploaded Files Data: ${uploadThing.uploadedFilesData}');
    }

    // List files with a limit of 10 files
    List<UploadThingFile> fileList = await uploadThing.listFiles(limit: 10);
    print('List of Files:');
    for (var file in fileList) {
      print('File: ${file.name}, Status: ${file.status}');
    }

    // Rename a single file
    bool renameSuccess =
        await uploadThing.renameFile('exampleKey', 'newName.jpg');
    if (renameSuccess) {
      print('File renamed successfully');
    }

    // Rename multiple files
    bool renameMultipleSuccess = await uploadThing.renameFiles([
      {'fileKey': 'exampleKey1', 'newName': 'newName1.jpg'},
      {'fileKey': 'exampleKey2', 'newName': 'newName2.png'},
    ]);
    if (renameMultipleSuccess) {
      print('Multiple files renamed successfully');
    }

    // Delete a single file
    bool deleteSuccess = await uploadThing.deleteFile('exampleKey');
    if (deleteSuccess) {
      print('File deleted successfully');
    }

    // Delete multiple files
    bool deleteMultipleSuccess =
        await uploadThing.deleteFiles(['exampleKey1', 'exampleKey2']);
    if (deleteMultipleSuccess) {
      print('Multiple files deleted successfully');
    }

    // Get app information
    AppInfo appInfo = await uploadThing.getAppInfo();
    print('App Info: ${appInfo.toString()}');

    // Get usage information
    UsageInfo usageInfo = await uploadThing.getUsageInfo();
    print('Usage Info: ${usageInfo.toString()}');

    // Get URL for a specific file
    String fileUrl = uploadThing.getFileUrl('exampleKey');
    print('File URL: $fileUrl');
  } catch (e) {
    print('Error: $e');
  }
}

import 'dart:io';
import 'package:uploadthing/uploadthing.dart';

void main() async {
  // Replace with your actual API key
  final uploadThing = UploadThing('your_api_key_here');

  // List of files to upload
  List<File> files = [
    File('path/to/your/file1.png'),
    File('path/to/your/file2.txt')
  ];

  try {
    // Upload the files
    await uploadThing.uploadFiles(files);
    print('Upload complete');
    print('Uploaded Files Data: ${uploadThing.uploadedFilesData}');
  } catch (e) {
    print('Error: $e');
  }
}

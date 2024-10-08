import 'dart:async';
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

  // Start a timer to print the total and uploaded files every second
  Timer.periodic(const Duration(seconds: 1), (timer) {
    print(
        "Total Files: ${uploadThing.totalFiles}, Uploaded Files: ${uploadThing.uploadedFiles}");
    if (uploadThing.uploadedFiles == uploadThing.totalFiles) {
      timer.cancel(); // Stop the timer when all files are uploaded
    }
  });

  try {
    // Upload the files
    await uploadThing.uploadFile(files);
    print('Upload complete');
    print('Uploaded Files Data: ${uploadThing.uploadedFilesData}');
  } catch (e) {
    print('Error: $e');
  }
}

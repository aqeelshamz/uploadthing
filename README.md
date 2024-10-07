
# UploadThing Dart SDK

An unofficial Dart/Flutter SDK for the [UploadThing API](https://docs.uploadthing.com/api-reference/openapi-spec), providing easy file upload capabilities. This package allows you to integrate file upload features seamlessly into your Dart or Flutter application using the [UploadThing](https://uploadthing.com/) service.

## Features

- Simple and easy-to-use
- Upload single or multiple files with ease
- Track upload progress and manage file data
- Supports various file types

## Installation

Add the following dependency to your `pubspec.yaml` file:

```yaml
dependencies:
  uploadthing: ^1.0.0
```

Then, run:

```bash
flutter pub get
```

## Usage

### Import the package

```dart
import 'package:uploadthing/uploadthing.dart';
import 'dart:io';
```

### Initialize and Upload Files

```dart
void main() async {
  final uploadThing = UploadThing('YOUR_API_KEY');

  List<File> files = [
    File('path/to/file1.jpg'),
    File('path/to/file2.png'),
  ];

  try {
    await uploadThing.uploadFile(files);
    print('Uploaded files: ${uploadThing.uploadedFilesData}');
  } catch (e) {
    print('Error: $e');
  }
}
```

### Handling Upload Progress

You can track the progress of uploaded files using `uploadedFiles` and `totalFiles`:

```dart
print('Uploaded ${uploadThing.uploadedFiles} of ${uploadThing.totalFiles} files');
```

### Uploaded Files Data

Once the files are uploaded, you can access the uploaded file data:

```dart
for (var fileData in uploadThing.uploadedFilesData) {
  print('File URL: ${fileData['url']}');
}
```

## API Reference

### `UploadThing(String apiKey)`

Creates an instance of the `UploadThing` class with the provided API key.

### `Future<void> uploadFile(List<File> files)`

Uploads a list of files to the UploadThing API. 

- **Parameters**:
  - `files`: A list of `File` objects to be uploaded.
  
- **Exceptions**:
  - Throws an exception if the upload fails.

## Configuration

Ensure you replace `'YOUR_API_KEY'` with your UploadThing API key. You can obtain the API key from your [UploadThing dashboard](https://uploadthing.com/dashboard).

## Error Handling

Make sure to handle exceptions properly when calling `uploadFile` to catch any errors during the upload process.

```dart
try {
  await uploadThing.uploadFile(files);
} catch (e) {
  print('Error occurred: $e');
}
```

## Documentation

For more details about UploadThing, refer to the [UploadThing API Documentation](https://docs.uploadthing.com).

## Contributions

Contributions are welcome! Please feel free to submit a pull request or report issues.

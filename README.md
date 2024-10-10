
# UploadThing Dart SDK

An unofficial Dart/Flutter SDK for the [UploadThing API](https://docs.uploadthing.com/api-reference/openapi-spec), providing seamless file upload capabilities. This package allows you to integrate file upload features effortlessly into your Dart or Flutter applications using the [UploadThing](https://uploadthing.com/) service.

## Features

- Upload single or multiple files with ease.
- Track upload progress and manage file data.
- Support for various file types and operations such as renaming and deleting files.
- Retrieve and display app information and usage statistics.


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
    await uploadThing.uploadFiles(files);
    print('Uploaded files: ${uploadThing.uploadedFilesData}');
  } catch (e) {
    print('Error: $e');
  }
}
```

### Tracking Upload Progress

Track the progress of uploaded files using `uploadedFiles` and `totalFiles`:

```dart
print('Uploaded ${uploadThing.uploadedFiles} of ${uploadThing.totalFiles} files');
```

### Access Uploaded Files Data

Access the uploaded file data after the upload process:

```dart
for (var fileData in uploadThing.uploadedFilesData) {
  print('File URL: ${fileData['url']}');
}
```

## API Reference

### Classes

#### `UploadThing`

The main class for handling file uploads and interactions with the UploadThing API.

- **Constructor**: `UploadThing(String apiKey)`
  - Initializes the instance with an API key.

#### Methods

1. **`Future<bool> uploadFiles(List<File> files)`**
   - Uploads a list of files to the API.
   - **Parameters**: 
     - `files`: List of `File` objects.
   - **Returns**: `true` if successful, otherwise throws an `Exception`.

2. **`Future<List<UploadThingFile>> listFiles({int limit = 500, int offset = 0})`**
   - Retrieves a list of uploaded files.
   - **Parameters**: 
     - `limit`: Maximum number of files to retrieve (default is 500).
     - `offset`: Number of files to skip before collecting results.
   - **Returns**: A list of `UploadThingFile` objects.

3. **`Future<bool> renameFile(String fileKey, String newName)`**
   - Renames a file on the server.
   - **Parameters**:
     - `fileKey`: The identifier of the file.
     - `newName`: The new name for the file.
   - **Returns**: `true` if successful, otherwise throws an `Exception`.

4. **`Future<bool> renameFiles(List<Map<String, String>> updates)`**
   - Renames multiple files.
   - **Parameters**:
     - `updates`: List of maps containing file keys and new names.
   - **Returns**: `true` if successful, otherwise throws an `Exception`.

5. **`Future<bool> deleteFile(String fileKey)`**
   - Deletes a file.
   - **Parameters**:
     - `fileKey`: The identifier of the file.
   - **Returns**: `true` if successful, otherwise throws an `Exception`.

6. **`Future<bool> deleteFiles(List<String> fileKeys)`**
   - Deletes multiple files.
   - **Parameters**:
     - `fileKeys`: List of file identifiers.
   - **Returns**: `true` if successful, otherwise throws an `Exception`.

7. **`Future<AppInfo> getAppInfo()`**
   - Retrieves information about the application.
   - **Returns**: An `AppInfo` object with details about the application.

8. **`String getFileUrl(String key)`**
   - Gets the URL for a file given its key.
   - **Parameters**:
     - `key`: Unique identifier for the file.
   - **Returns**: The constructed file URL.

9. **`Future<UsageInfo> getUsageInfo()`**
   - Gets information about the app’s usage.
   - **Returns**: A `UsageInfo` object with usage statistics.

### Classes Details

#### `AppInfo`

Contains information about the application.

- **Attributes**:
  - `appId`: The application ID.
  - `defaultACL`: The default access control list.
  - `allowACLOverride`: Whether ACL override is allowed.

#### `UploadThingFile`

Represents a file uploaded to UploadThing.

- **Attributes**:
  - `id`: The file ID.
  - `key`: The unique identifier for the file.
  - `name`: The file name.
  - `customId`: A custom identifier for the file.
  - `status`: The status of the file.

#### `UsageInfo`

Provides information about the app’s usage statistics.

- **Attributes**:
  - `totalBytes`: Total bytes used.
  - `appTotalBytes`: Total bytes used by the application.
  - `filesUploaded`: Number of files uploaded.
  - `limitBytes`: Byte limit for the application.

## Example Usage

### Upload Multiple Files

```dart
void main() async {
  final uploadThing = UploadThing('YOUR_API_KEY');

  List<File> files = [
    File('path/to/file1.jpg'),
    File('path/to/file2.png'),
  ];

  try {
    bool isUploaded = await uploadThing.uploadFiles(files);
    if (isUploaded) {
      print('Files uploaded successfully');
    }
  } catch (e) {
    print('Upload failed: $e');
  }
}
```

### Listing Files

```dart
void listFiles() async {
  final uploadThing = UploadThing('YOUR_API_KEY');
  try {
    List<UploadThingFile> files = await uploadThing.listFiles(limit: 10);
    files.forEach((file) {
      print('File: ${file.name}, Status: ${file.status}');
    });
  } catch (e) {
    print('Error: $e');
  }
}
```

### Renaming a File

```dart
void renameFileExample() async {
  final uploadThing = UploadThing('YOUR_API_KEY');
  try {
    bool response = await uploadThing.renameFile("exampleKey", "newName.jpg");
    if (response) {
      print('File renamed successfully');
    }
  } catch (e) {
    print('Error: $e');
  }
}
```

### Deleting a File

```dart
void deleteFileExample() async {
  final uploadThing = UploadThing('YOUR_API_KEY');
  try {
    bool response = await uploadThing.deleteFile("exampleKey");
    if (response) {
      print('File deleted successfully');
    }
  } catch (e) {
    print('Error: $e');
  }
}
```

## Configuration

Ensure you replace `'YOUR_API_KEY'` with your UploadThing API key. You can obtain the API key from your [UploadThing dashboard](https://uploadthing.com/dashboard).

## Error Handling

Make sure to handle exceptions properly when calling API methods to catch any errors during operations.

## Documentation

For more details about UploadThing, refer to the [UploadThing API Documentation](https://docs.uploadthing.com).

## Contributions

Contributions are welcome! Please feel free to submit a pull request or report issues.

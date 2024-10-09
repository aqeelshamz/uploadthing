import 'package:flutter/material.dart';
import 'package:uploadthing/uploadthing.dart';

class UploadButton extends StatefulWidget {
  final UploadThing instance;
  const UploadButton({super.key, required this.instance});

  @override
  State<UploadButton> createState() => _UploadButtonState();
}

class _UploadButtonState extends State<UploadButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      child: const Text('Upload'),
    );
  }
}

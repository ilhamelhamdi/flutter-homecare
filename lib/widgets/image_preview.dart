import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImagePreview extends StatefulWidget {
  final Function(File) onImageSelected;

  ImagePreview({required this.onImageSelected});

  @override
  _ImagePreviewState createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  File? _image;

  Future<void> _chooseImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      widget.onImageSelected(_image!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(5),
          ),
          child: _image == null
              ? Center(child: Image.asset('assets/icons/ic_preview.png'))
              : Image.file(_image!, fit: BoxFit.cover),
        ),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Image less than 100MB',
              style: TextStyle(fontSize: 12),
            ),
            SizedBox(height: 10),
            OutlinedButton(
              onPressed: _chooseImage,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Color(0xFF10B981)),
              ),
              child: Text(
                'Choose File',
                style: TextStyle(color: Color(0xFF10B981)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

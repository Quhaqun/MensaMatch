// circular_image_picker.dart

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CircularImagePicker extends StatefulWidget {
  final Function(XFile?) onImageSelected;
  final String? overlayText;

  const CircularImagePicker({
    Key? key,
    required this.onImageSelected,
    this.overlayText,
  }) : super(key: key);

  @override
  _CircularImagePickerState createState() => _CircularImagePickerState();
}

class _CircularImagePickerState extends State<CircularImagePicker> {
  XFile? _image;
  final ImagePicker picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickImage,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[200], // Placeholder color
            ),
            child: _image != null
                ? ClipOval(
                    child: Image.network(
                      _image!.path,
                      width: 180,
                      height: 180,
                      fit: BoxFit.cover,
                    ),
                  )
                : Icon(
                    Icons.camera_alt,
                    size: 50,
                    color: Colors.grey,
                  ),
          ),
          if (widget.overlayText != null)
            Positioned(
              bottom: 8.0,
              child: Text(
                widget.overlayText!,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _pickImage() async {
    XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedImage;
    });

    // Callback to notify the parent widget about the selected image
    widget.onImageSelected(_image);
  }
}

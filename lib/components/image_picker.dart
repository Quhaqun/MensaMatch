// circular_image_picker.dart

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CircularImagePicker extends StatefulWidget {
  final Function(XFile?) onImageSelected;
  final String? overlayText;
  final double imageSize;
  XFile? image = null;


  CircularImagePicker({
    Key? key,
    this.image,
    required this.onImageSelected,
    this.imageSize = 180.0,
    this.overlayText,
  }) : super(key: key);

  @override
  _CircularImagePickerState createState() => _CircularImagePickerState();
}

class _CircularImagePickerState extends State<CircularImagePicker> {
  final ImagePicker picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickImage,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: widget.imageSize,
            height: widget.imageSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[200], // Placeholder color
            ),
            child: widget.image != null
                ? ClipOval(
                    child: Image.network(
                      widget.image!.path,
                      width: widget.imageSize,
                      height: widget.imageSize,
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
    if(pickedImage != null){
      setState(() {
        widget.image = pickedImage;
      });
      // Callback to notify the parent widget about the selected image
      widget.onImageSelected(widget.image);
    }
  }
}

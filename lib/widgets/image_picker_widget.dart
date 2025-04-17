//Material
import 'package:flutter/material.dart';

//Packages
import 'package:image_picker/image_picker.dart';

//Files
import 'dart:io';


class ImagePickerWidget extends StatefulWidget {

  final File? image;
  final ValueChanged<File> imageFileChanged;

  const ImagePickerWidget({
    super.key,
    required this.image,
    required this.imageFileChanged
  });

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {

   //Image picker
  final ImagePicker _picker = ImagePicker();
  File? _image;

  Widget _imagePreview(BuildContext context) {
    final theme = Theme.of(context);

    //Check if there is some _image
    final localImage = _image ?? widget.image;

    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.primary, width: 2),
        color: theme.colorScheme.onPrimary,
      ),
      child: localImage != null
          ? ClipRRect(
              //Zaokręglnie rogów
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                localImage,
                fit: BoxFit.cover,
                width: 150,
                height: 150,
              ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.image,
                    size: 40,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 8),
                  const Text('No Image Selected'),
                ],
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _imagePreview(context),
        const SizedBox(height: 8),
        TextButton(
            onPressed: () async {
              final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
              if (pickedImage != null){
                final File imageFile = File(pickedImage.path);
                setState(() {
                  _image = imageFile;
                });
                widget.imageFileChanged(imageFile);
              }
            },
            child: const Text("Pick image"))
      ],
    );
  }
}

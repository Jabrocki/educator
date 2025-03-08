//Material
import 'package:educator/state/subject_add_state.dart';

//Material
import 'package:flutter/material.dart';


//Packages
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';


class ImagePicker extends StatelessWidget {
  const ImagePicker({
    super.key,
  });
  

  Widget _imagePreview(BuildContext context) {
    final _theme = Theme.of(context);
    final _image = Provider.of<SubjectAddState>(context).imgFile;

    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _theme.colorScheme.primary, width: 2),
        color: _theme.colorScheme.onPrimary,
      ),
      child: _image != null
          ? ClipRRect(
              //Zaokręglnie rogów
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                _image,
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
                    color: _theme.colorScheme.primary,
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
            onPressed: () => Provider.of<SubjectAddState>(context, listen: false).pickImage(ImageSource.gallery),
            child: Text("Pick image"))
      ],
    );
  }
}

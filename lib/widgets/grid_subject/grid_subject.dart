//Material
import 'package:educator/widgets/grid_subject/helper_menu.dart';
import 'package:flutter/material.dart';

//Models
import '../../models/subject_model.dart';

//Internal Packges
import 'dart:io';



class GridSubject extends StatelessWidget {
  final SubjectModel subject;

  const GridSubject({
    required this.subject,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final mainTheme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              color: mainTheme.colorScheme.primaryContainer,
            ),
            child: Column(
              children: [
                Expanded(
                    child:
                        _imagePreview()), // Image takes up all available space
                HelperMenu(subject: subject), // Scalable menu at the bottom
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _imagePreview() {
    return FutureBuilder(
        future: subject.imgPath,
        builder: (context, snapshot) {
          if (snapshot.hasData && subject.imgId != null) {
            return Image.file(
              File(snapshot.data!),
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            );
          }

          return const Center(child: Icon(Icons.image_not_supported, size: 50));
        });
  }
}

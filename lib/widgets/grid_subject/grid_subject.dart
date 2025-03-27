//Material
import 'package:educator/state/layout_state.dart';
import 'package:educator/widgets/grid_subject/helper_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

    return Consumer<LayoutState>(
      builder: (_, layoutState, __) {
        double imageSize = layoutState.refernceGridSize * 0.3;
        double borderRadius = layoutState.refernceGridSize * 0.07;
        double menuHeight = layoutState.refernceGridSize * 0.18;
        return ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Container(
            decoration: BoxDecoration(
              color: mainTheme.colorScheme.primaryContainer,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                    child:
                        _imagePreview(imageSize)), // Image takes up all available space
                SizedBox(
                  height: menuHeight,
                  child: HelperMenu(subject: subject)), // Scalable menu at the bottom
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _imagePreview(double imageSize) {
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

          return Center(child: Icon(Icons.image_not_supported, size: imageSize));
        });
  }
}

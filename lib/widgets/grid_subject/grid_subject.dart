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
        int crossAxisCount = (MediaQuery.of(context).size.width/200).clamp(1,6).toInt();
        double imageSize = (layoutState.maxWidth/900)*50*(7-crossAxisCount)/2;
        double borderRadius = (layoutState.maxWidth/900)*16*(7-crossAxisCount)/2;
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
                HelperMenu(subject: subject), // Scalable menu at the bottom
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

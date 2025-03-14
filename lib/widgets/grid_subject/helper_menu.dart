//Material

import 'package:auto_size_text/auto_size_text.dart';
import 'package:educator/models/subject_model.dart';
import 'package:educator/state/subject_list_state.dart';
import 'package:educator/widgets/custom_pop_up_subject.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HelperMenu extends StatelessWidget {
  const HelperMenu({
    super.key,
    required this.subject,
  });

  final SubjectModel subject;

  @override
  Widget build(BuildContext context) {
    final subjectAddState =
        Provider.of<SubjectListState>(context, listen: false);
    void deleteSubject() {
      subjectAddState.deleteSubject(subjectId: subject.subjectId);
    }

    void editSubject() async {
      subjectAddState.subjectName = subject.subjectName;
      subjectAddState.subjectId = subject.subjectId;
      subjectAddState.isEditing = true;
      showDialog(
          context: context,
          builder: (context) {
            return const CustomPopUpSubject();
          });
      if (subject.imgId != null) {
        subjectAddState.imgFile = (await subject.imgFile)!;
      }
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // Define min & max icon size
        double minIconSize = 8; // Minimum icon size
        double maxIconSize = 28; // Maximum icon size
        double iconSize =
            (constraints.maxWidth * 0.1).clamp(minIconSize, maxIconSize);

        // Define min & max text width
        double minTextWidth = 60; // Minimum width for text
        double maxTextWidth =
            constraints.maxWidth * 0.6; // Maximum width for text

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: FittedBox(
            child: Row(
              children: [
                SizedBox(
                  width: maxTextWidth.clamp(
                      minTextWidth, maxTextWidth), // Text takes up 60% of space
                  child: AutoSizeText(
                    subject.subjectName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    minFontSize: 10,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: editSubject,
                      icon: const Icon(Icons.edit),
                      iconSize: iconSize,
                    ),
                    IconButton(
                      onPressed: deleteSubject,
                      icon: const Icon(Icons.delete),
                      iconSize: iconSize,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}


import 'package:educator/models/subject_model.dart';
import 'package:educator/state/layout_state.dart';
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

    return Consumer<LayoutState>(
      builder: (_, layoutState, __) {
        double iconSize = layoutState.refernceGridSize * 0.08;
        double iconDistance = iconSize * 1.5;
        double fontSize = layoutState.refernceGridSize * 0.05;
        double textPadding =layoutState.refernceGridSize * 0.05;

        return Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 3,
                  spreadRadius: 1,
                )
              ]
            ),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(textPadding),
                    child: Text(
                      subject.subjectName,
                      style: TextStyle(
                          fontSize: fontSize, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Row(
                  mainAxisSize:
                      MainAxisSize.min, // optional, keeps Row as small as possible
                  children: [
                    IconButton(
                      onPressed: editSubject,
                      icon: const Icon(Icons.edit),
                      padding: EdgeInsets.zero, // removes default padding
                      constraints:
                          const BoxConstraints(), // removes default 48x48 constraints
                      iconSize: iconSize,
                    ),
                    IconButton(
                      onPressed: deleteSubject,
                      icon: const Icon(Icons.delete),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(minWidth: iconDistance),
                      iconSize: iconSize,
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

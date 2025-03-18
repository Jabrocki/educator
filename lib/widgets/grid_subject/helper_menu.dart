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
        double iconSize = (constraints.maxWidth * 0.08).clamp(16.0, 32.0);
        double fontSize = (constraints.maxWidth * 0.05).clamp(10.0, 30.0);

        return Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: AutoSizeText(
                  subject.subjectName,
                  style: TextStyle(
                      fontSize: fontSize, fontWeight: FontWeight.bold),
                  maxLines: 3,
                  minFontSize: 8,
                  overflow: TextOverflow.ellipsis,
                ),
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
        );
      },
    );
  }
}

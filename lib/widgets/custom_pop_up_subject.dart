//Material
import 'package:flutter/material.dart';

//Custom widgets
import 'image_picker_widget.dart';

//State
import '../state/subject_list_state.dart';

//External packages
import 'package:provider/provider.dart';

class CustomPopUpSubject extends StatelessWidget {
  const CustomPopUpSubject({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    //State
    final subjectListState = Provider.of<SubjectListState>(context);

    void addSubject() async {
      int? imgId = await subjectListState.saveAddImage();
      subjectListState.addSubject(
        subjectName: subjectListState.subjectNameController.text,
        imgId: imgId,
      );
      subjectListState.clearAddData();
    }

    void editSubject() async {
      int? imgId = await subjectListState.saveAddImage();
      subjectListState.editSubject(
          subjectId: subjectListState.subjectId,
          subjectName: subjectListState.subjectNameController.text,
          imgId: imgId);
      subjectListState.clearAddData();
    }

    void clearImage() async {
      subjectListState.clearAddImage();
    }

    return AlertDialog(
        title: _title(),
        content: _body(subjectListState),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left-aligned Icon
              IconButton(
                onPressed: clearImage,
                icon: const Icon(Icons.clear),
              ),
              // Right-aligned Buttons
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      subjectListState.clearAddData();
                      Navigator.of(context).pop();
                    },
                    child: const Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      if (subjectListState.isEditing) {
                        editSubject();
                      } else {
                        addSubject();
                      }
                    },
                    child: const Text("Ok"),
                  ),
                ],
              ),
            ],
          ),
        ]);
  }

   _title() {
    return const Text(
        "Add Subject",
        style: TextStyle(fontWeight: FontWeight.bold),
      );
  }

  Widget _body(SubjectListState subjectListState) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: subjectListState.subjectNameController,
              decoration: const InputDecoration(
                labelText: "Subject name",
                hintText: "Enter subject name"
              ),
            ),
            const SizedBox(height: 16),
            ImagePickerWidget(
              image: subjectListState.imgFile,
              imageFileChanged: subjectListState.setImage,
            ),
          ],
        ),
      );
  }
}

import 'package:educator/state/subject_add_state.dart';
import 'package:flutter/material.dart';

import '../state/subjects_state.dart';

import 'package:provider/provider.dart';

import 'image_picker.dart';

class CustomPopUpSubject extends StatelessWidget {
  const CustomPopUpSubject({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final subjectAddState = Provider.of<SubjectAddState>(context);
    final subjectsState = Provider.of<SubjectState>(context, listen: false);

    void addSubject() async {
      int? imgId = await subjectAddState.saveImage();
      subjectsState.addSubject(
        userId: subjectsState.userId!,
        subjectName: subjectAddState.subjectNameController.text,
        imgId: imgId,
      );
      subjectAddState.clearData();
    }

    void editSubject() async {
      int? imgId = await subjectAddState.saveImage();
      subjectsState.editSubject(
          subjectId: subjectAddState.subjectId,
          subjectName: subjectAddState.subjectNameController.text,
          imgId: imgId);
      subjectAddState.clearData();
    }

    void clearImage() async {
      subjectAddState.clearImage();
    }

    return AlertDialog(
        title: const Text(
          "Add Subject",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: subjectAddState.subjectNameController,
                decoration: InputDecoration(
                  labelText: "Subject Name",
                  hintText: "Enter subject name",
                  filled: true,
                  fillColor: Colors
                      .grey[100], // Light background for better visibility
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Colors.blueAccent, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.blue, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const ImagePicker(),
            ],
          ),
        ),
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
                      subjectAddState.clearData();
                      Navigator.of(context).pop();
                    },
                    child: const Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      if (subjectAddState.isEditing) {
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
}

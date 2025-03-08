//Material
import 'package:flutter/material.dart';

//Models
import '../models/subject_model.dart';

//State
import '../state/subject_add_state.dart';
import '../state/subjects_state.dart';

//External Packges
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';

//Internal Packges
import 'dart:io';

//Custom widgets
import 'custom_pop_up_subject.dart';

class AnimatedGridSubject extends StatefulWidget {
  final SubjectModel subject;
  final int index; // to know the order in which this item appears

  const AnimatedGridSubject({
    super.key,
    required this.subject,
    required this.index,
  });

  @override
  State<AnimatedGridSubject> createState() => _AnimatedGridSubjectState();
}

class _AnimatedGridSubjectState extends State<AnimatedGridSubject> {
  double _initScale = 0.0;
  double _pressedScale = 1.0;

  // Combine both scale factors
  double get _combinedScale => _initScale * _pressedScale;

  @override
  void initState() {
    super.initState();
    // Add a small delay for each item, so that item #0 starts immediately,
    // item #1 starts 100ms later, item #2 starts 200ms later, etc.
    Future.delayed(Duration(milliseconds: 100 * widget.index), () {
      // Always check if the widget is still mounted before calling setState in an async gap
      if (mounted) {
        setState(() {
          _initScale = 1.0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _combinedScale,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutBack,
      child: InkWell(
          borderRadius: BorderRadius.circular(16),
          // When the user presses down, shrink the widget
          onTapDown: (details) {
            setState(() {
              _pressedScale = 0.95;
            });
          },
          // When the user lifts their finger, return to full scale
          onTapUp: (details) {
            setState(() {
              _pressedScale = 1.0;
            });
          },
          // If the tap is canceled, return to full scale
          onTapCancel: () {
            setState(() {
              _pressedScale = 1.0;
            });
          },
          onTap: () {
            Navigator.of(context).pushNamed(
              '/subjects/menu',
            );
          },
          child: GridSubject(subject: widget.subject)),
    );
  }
}

class GridSubject extends StatelessWidget {
  final SubjectModel subject;

  const GridSubject({
    required this.subject,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[300],
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

class HelperMenu extends StatelessWidget {
  const HelperMenu({
    super.key,
    required this.subject,
  });

  final SubjectModel subject;

  @override
  Widget build(BuildContext context) {
    void deleteSubject() {
      Provider.of<SubjectState>(context, listen: false)
          .deleteSubject(subjectId: subject.subjectId);
    }

    void editSubject() async {
      final subjectAddState =
          Provider.of<SubjectAddState>(context, listen: false);

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

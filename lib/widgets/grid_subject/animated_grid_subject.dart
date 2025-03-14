//Material

import 'package:educator/models/subject_model.dart';
import 'package:educator/widgets/grid_subject/grid_subject.dart';
import 'package:flutter/material.dart';
import '../../state/main_state.dart';

import 'package:provider/provider.dart';

class AnimatedGridSubject extends StatefulWidget {
  final SubjectModel subject;
  final int index; // to know the order in which this item appears

  const AnimatedGridSubject({
    super.key,
    required this.subject,
    required this.index,
  });

  @override
  State<AnimatedGridSubject> createState() => AnimatedGridSubjectState();
}

class AnimatedGridSubjectState extends State<AnimatedGridSubject> {
  double _initScale = 0.0;
  double _pressedScale = 1.0;

  // Combine both scale factors
  double get _combinedScale => _initScale * _pressedScale;

  @override
  void initState() {
    super.initState();
    startAnimation();
  }


  void startAnimation() {
    setState(() {
      _initScale = 0.0;
    });

    Future.delayed(Duration(milliseconds: 100 * widget.index), () {
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
            Provider.of<MainState>(context, listen: false).subjectId =
                widget.subject.subjectId;
            Navigator.of(context).pushNamed(
              '/subjects/menu',
            );
          },
          child: GridSubject(subject: widget.subject)),
    );
  }
}


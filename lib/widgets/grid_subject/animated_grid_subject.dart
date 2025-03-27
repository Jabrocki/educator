import 'package:flutter/material.dart';
import 'package:educator/models/subject_model.dart';
import 'package:educator/widgets/grid_subject/grid_subject.dart';
import 'package:provider/provider.dart';
import '../../state/main_state.dart';
import '../../state/layout_state.dart';

class AnimatedGridSubject extends StatelessWidget {
  final SubjectModel subject;
  final Animation<double> animation;

  const AnimatedGridSubject({
    super.key,
    required this.subject,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<LayoutState>(builder: (_, layoutState, __) {
      //Calulate border radius
      final double borderRadius = layoutState.refernceGridSize * 0.05;
      return AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return Transform.scale(
            scale: animation.value,
            child: child,
          );
        },
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: () {
            Provider.of<MainState>(context, listen: false).subjectId =
                subject.subjectId;
            Navigator.of(context).pushNamed('/subjects/menu');
          },
          child: GridSubject(subject: subject),
        ),
      );
    });
  }
}

import 'package:flutter/material.dart';
import 'package:educator/models/subject_model.dart';
import 'package:educator/widgets/grid_subject/grid_subject.dart';
import 'package:provider/provider.dart';
import '../../state/main_state.dart';

class AnimatedGridSubject extends StatefulWidget {
  final SubjectModel subject;
  final Animation<double> animation;

  const AnimatedGridSubject({
    super.key,
    required this.subject,
    required this.animation,
  });

  @override
  State<AnimatedGridSubject> createState() => _AnimatedGridSubjectState();
}

class _AnimatedGridSubjectState extends State<AnimatedGridSubject>
    with SingleTickerProviderStateMixin {
  late AnimationController _pressController;
  late Animation<double> _pressAnimation;

  @override
  void initState() {
    super.initState();

    _pressController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 150));

    _pressAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
        CurvedAnimation(parent: _pressController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _pressController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _pressController.reverse();
  }

  void _onTapCancel() {
    _pressController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final double borderRadius = constraints.maxWidth * 0.05;

      return AnimatedBuilder(
        animation: Listenable.merge([widget.animation, _pressAnimation]),
        builder: (context, child) {
          final double combinedScale =
              widget.animation.value * _pressAnimation.value;
          return Transform.scale(
            scale: combinedScale,
            child: child,
          );
        },
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: () {
            Provider.of<MainState>(context, listen: false).subjectId =
                widget.subject.subjectId;
            Navigator.of(context).pushNamed('/subjects/menu');
          },
          onTapDown: _onTapDown,
          onTapUp: _onTapUp,
          onTapCancel: _onTapCancel,
          child: GridSubject(subject: widget.subject),
        ),
      );
    });
  }
}

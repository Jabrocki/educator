//Provider

import 'package:educator/models/flashcard_model.dart';
import 'package:educator/widgets/flashcard_edit/flashcard_edit.dart';
import 'package:flutter/material.dart';

class AnimatedFlashcardEdit extends StatelessWidget {
  final FlashcardModel flashcard;
  final Animation<double> animation;

  const AnimatedFlashcardEdit({
    super.key,
    required  this.flashcard,
    required this.animation
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constriants) {
        return AnimatedBuilder(
          animation: animation, 
          builder: (context, child) {
            return Transform.scale(
              scale: animation.value,
              child: child,
            );
          },
          child: FlashcardEdit()
        );
      }
    );
  }
}

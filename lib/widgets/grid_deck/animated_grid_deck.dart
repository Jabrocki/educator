//Material

import 'package:educator/models/deck_model.dart';
import 'package:educator/widgets/grid_deck/grid_deck.dart';
import 'package:flutter/material.dart';



class AnimatedGridDeck extends StatelessWidget {
  final DeckModel deck;
  final Animation<double> animation;

  const AnimatedGridDeck({
    super.key,
    required this.deck,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {

        final double borderRadius = constraints.maxWidth * 0.05;

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
              //TODO transiton to flashcard page
            },
            child: GridDeck(deck: deck),
          ),
        );
      },
    );
  }
}


//Material

import 'package:educator/models/deck_model.dart';
import 'package:educator/widgets/grid_deck/grid_deck.dart';
import 'package:flutter/material.dart';

class AnimatedGridDeck extends StatefulWidget {
  final DeckModel deck;
  final Animation<double> animation;

  const AnimatedGridDeck({
    super.key,
    required this.deck,
    required this.animation,
  });

  @override
  State<AnimatedGridDeck> createState() => _AnimatedGridDeckState();
}

class _AnimatedGridDeckState extends State<AnimatedGridDeck>
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
    return LayoutBuilder(
      builder: (context, constraints) {
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

            },
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            child: GridDeck(deck: widget.deck),
          ),
        );
      },
    );
  }
}

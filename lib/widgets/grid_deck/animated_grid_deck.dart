//Material

import 'package:educator/models/deck_model.dart';
import 'package:educator/widgets/grid_deck/grid_deck.dart';
import 'package:flutter/material.dart';

class AnimatedGridDeck extends StatefulWidget {
  final DeckModel deck;
  final int index; // to know the order in which this item appears

  const AnimatedGridDeck({
    super.key,
    required this.deck,
    required this.index,
  });

  @override
  State<AnimatedGridDeck> createState() => _AnimatedGridDeckState();
}

class _AnimatedGridDeckState extends State<AnimatedGridDeck> {
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
            //Provider.of<MainState>(context).subjectId = widget.deck.deckId;
            /*
            Navigator.of(context).pushNamed(
              '/subjects/menu',
            );
            */
            //TODO: some transition logic
          },
          child: GridDeck(deck: widget.deck)),
    );
  }
}


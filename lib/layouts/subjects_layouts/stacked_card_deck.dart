//Provider

import 'package:educator/widgets/flashcard_edit/flashcard_edit.dart';
import 'package:flutter/material.dart';

class StackedCardDeck extends StatefulWidget {
  const StackedCardDeck({
    super.key,
  });

  @override
  State<StackedCardDeck> createState() => _StackedCardDeckState();
}

class _StackedCardDeckState extends State<StackedCardDeck> {
  //Navigation rail
  bool _isHovered = false;
  
  //Card handling
  int _currentIndex = 0;
  bool _forward = true;

  void _goToNextCard() {
    if (_currentIndex < 9) {
      setState(() {
        _currentIndex++;
        _forward = true;
      });
    }
  }

  void _goToPrevCard() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _forward = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    
    final mainTheme = Theme.of(context);

    return LayoutBuilder(builder: (context, constraints) {
      //Title
      final double titlePadding = constraints.maxWidth * 0.01;
      final double titleFontSize = constraints.maxWidth * 0.02;

      //Distance
      final double distanceToMenu = constraints.maxHeight * 0.02;

      //Distance
      final double distanceBetweenButtons = constraints.maxWidth * 0.3;

      //Cardsize
      final double cardHeight = constraints.maxHeight * 0.8;
      final double cardWidth = constraints.maxWidth * 0.7;

      //Icon size
      final double iconSize = constraints.maxWidth *0.022;

      //Card generator
      Widget cardGenerator(int index) {
        return SizedBox(
          key: ValueKey(index),
          width: cardWidth,
          height: cardHeight,
          child: const FlashcardEdit(),
        );
      }

      final List<Widget> cards = List.generate(10, cardGenerator);

      return Container(
        color: mainTheme.scaffoldBackgroundColor,
        child: Stack(
          children: [
            Positioned(
              top: titlePadding,
              left: titlePadding,
              child: Text(
                "Edit Flashcards",
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(seconds: 1),
                  transitionBuilder: (child, animation) {
                    final inOffset = _forward
                        ? const Offset(2.0, 0.0)
                        : const Offset(-2.0, 0.0);
                    final outOffset = _forward
                        ? const Offset(-2.0, 0.0)
                        : const Offset(2.0, 0.0);

                    final inTilt = _forward ? 0.1 : -0.1;
                    final outTilt = _forward ? -0.1 : 0.1;

                    final bool isIncoming =
                        child.key == ValueKey(_currentIndex);

                    final tiltAnimation = Tween<double>(
                      begin: isIncoming ? inTilt : outTilt,
                      end: 0.0,
                    ).animate(CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeInOut,
                    ));

                    final slideAnimation = Tween<Offset>(
                      begin: isIncoming ? inOffset : outOffset,
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeInOut,
                    ));

                    return SlideTransition(
                      position: slideAnimation,
                      child: RotationTransition(
                        turns: tiltAnimation,
                        child: child,
                      ),
                    );
                  },
                  child: cards[_currentIndex],
                ),
                SizedBox(height: distanceToMenu),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: _goToPrevCard,
                      iconSize: iconSize,
                      icon: const Icon(Icons.arrow_back),
                    ),
                    SizedBox(
                      width: distanceBetweenButtons,
                    ),
                    IconButton(
                      onPressed: _goToNextCard,
                      iconSize: iconSize,
                      icon: const Icon(Icons.arrow_forward),
                    ),
                  ],
                ),
                SizedBox(height: distanceToMenu,)
              ],
            ),
          ],
        ),
      );
    });
  }
}

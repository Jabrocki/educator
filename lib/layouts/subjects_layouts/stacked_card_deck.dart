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
      final double iconSize = constraints.maxWidth * 0.022;

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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _body(titlePadding, titleFontSize, cards, distanceToMenu, iconSize,
                distanceBetweenButtons),
            //Navigation menu
            SizedBox(width: constraints.maxWidth * 0.1),
            CustomNavigationMenu(
              cards: cards,
              width: constraints.maxWidth * 0.2,
              cardHeight: constraints.maxHeight * 0.1,
              cardSeparation: constraints.maxHeight * 0.01,
              cardPadding: constraints.maxWidth * 0.01,
              onCardSelected: (index) {
                setState(() {
                  _forward = index > _currentIndex;
                  _currentIndex = index;
                });
              },
            ),
          ],
        ),
      );
    });
  }

  Stack _body(double titlePadding, double titleFontSize, List<Widget> cards,
      double distanceToMenu, double iconSize, double distanceBetweenButtons) {
    return Stack(
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
                final inOffset =
                    _forward ? const Offset(2.0, 0.0) : const Offset(-2.0, 0.0);
                final outOffset =
                    _forward ? const Offset(-2.0, 0.0) : const Offset(2.0, 0.0);

                final inTilt = _forward ? 0.1 : -0.1;
                final outTilt = _forward ? -0.1 : 0.1;

                final bool isIncoming = child.key == ValueKey(_currentIndex);

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
            SizedBox(
              height: distanceToMenu,
            )
          ],
        ),
      ],
    );
  }
}

class CustomNavigationMenu extends StatelessWidget {
  final List cards;
  final ValueChanged<int> onCardSelected;
  final double width;
  final double cardHeight;
  final double cardSeparation;
  final double cardPadding;

  const CustomNavigationMenu({
    super.key,
    required this.cards,
    required this.width,
    required this.cardHeight,
    required this.cardSeparation,
    required this.cardPadding,
    required this.onCardSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        alignment: Alignment.centerRight,
        width: width,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 1,
              spreadRadius: 1,
            ),
          ],
        ),
        child: ListView.separated(
            itemBuilder: (_, index) {
              return CustomMenuCardItem(
                cardPadding: cardPadding,
                cardHeight: cardHeight,
                cardSeparation: cardSeparation,
                onTap: () => onCardSelected(index),
                card: cards[index],
                index: index,
              );
            },
            separatorBuilder: (_, __) =>
                const Divider(thickness: 0.5, color: Colors.grey),
            itemCount: cards.length),
      ),
    );
  }
}

class CustomMenuCardItem extends StatelessWidget {
  const CustomMenuCardItem({
    super.key,
    required this.cardPadding,
    required this.cardHeight,
    required this.cardSeparation,
    required this.onTap,
    required this.card,
    required this.index,  
  });

  final double cardPadding;
  final double cardHeight;
  final double cardSeparation;
  final VoidCallback onTap;
  final card;
  final int index;  

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(cardPadding),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "${index + 1}",
                  style: TextStyle(
                    fontSize: cardHeight * 0.15,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                )
              
              ],
            ),
            SizedBox(
              height: cardSeparation,
            ),
            Text(
              "Front card",
              maxLines: 1,
              style: TextStyle(
                fontSize: cardHeight * 0.2,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: cardSeparation,
            ),
            CustomCard(cardHeight: cardHeight),
            SizedBox(
              height: cardSeparation,
            ),
            Text(
              "Back card",
              maxLines: 1,
              style: TextStyle(
                fontSize: cardHeight * 0.2,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: cardSeparation,
            ),
            CustomCard(cardHeight: cardHeight)
           ],
        ),
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  const CustomCard({
    super.key,
    required this.cardHeight,
  });

  final double cardHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: cardHeight,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 1,
            spreadRadius: 1,
          ),
        ],
      ),
      
      child: Center(child: Text("Test")),
    );
  }
}

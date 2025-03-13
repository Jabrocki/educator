//Material
import 'package:educator/state/deck_list_state.dart';
import 'package:educator/widgets/custom_pop_up_deck.dart';
import 'package:flutter/material.dart';



//External Packges
import 'package:auto_size_text/auto_size_text.dart';

//Internal Packges
import 'dart:io';
import '../models/deck_model.dart';
import 'package:provider/provider.dart';

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


class HelperMenu extends StatelessWidget {
  const HelperMenu({
    super.key,
    required this.deck,
  });

  final DeckModel deck;

  @override
  Widget build(BuildContext context) {
    final deckState =
        Provider.of<DeckListState>(context, listen: false);
    void deleteDeck() {
      deckState.deleteDeck(deckId: deck.deckId);
    }

    void editDeck() async {
      deckState.deckName = deck.deckName;
      deckState.editedDeckId = deck.deckId;
      deckState.maximumNumberOfCardsToLearn = deck.maximumNumberOfCardsToLearn;
      deckState.maximumNumberOfCardsToReview = deck.maximumNumberOfCardsToReview;
      deckState.isEditing = true;
      showDialog(
          context: context,
          builder: (context) {
            return const CustomPopUpDeck();
          });
      if (deck.imgId != null) {
        deckState.imgFile = (await deck.imgFile)!;
      }
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // Define min & max icon size
        double minIconSize = 8; // Minimum icon size
        double maxIconSize = 28; // Maximum icon size
        double iconSize =
            (constraints.maxWidth * 0.12).clamp(minIconSize, maxIconSize);

        // Define min & max text width
        double minTextWidth = 60; // Minimum width for text
        double maxTextWidth =
            constraints.maxWidth * 0.45; // Maximum width for text

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: FittedBox(
            child: Row(
              children: [
                SizedBox(
                  width: maxTextWidth.clamp(
                      minTextWidth, maxTextWidth), // Text takes up 60% of space
                  child: AutoSizeText(
                    deck.deckName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    minFontSize: 10,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {}, 
                      icon: const Icon(Icons.add),
                      iconSize: iconSize,
                    ),
                    IconButton(
                      onPressed: editDeck,
                      icon: const Icon(Icons.edit),
                      iconSize: iconSize,
                    ),
                    IconButton(
                      onPressed: deleteDeck,
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




class GridDeck extends StatelessWidget {
  final DeckModel deck;

  const GridDeck({
    required this.deck,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final mainTheme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        double containerWidth = constraints.maxWidth * 0.4; // Scales with screen
        double containerHeight = constraints.maxHeight * 0.12; // Scales with screen
        double fontSize = constraints.maxWidth * 0.06; // Text scales dynamically

        return ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Background Container
              Container(
                decoration: BoxDecoration(
                  color: mainTheme.colorScheme.primaryContainer,
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: _imagePreview(),
                    ),
                    HelperMenu(deck: deck),
                  ],
                ),
              ),

              // Floating Number Menu (Top-Left)
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  width: containerWidth,
                  height: containerHeight,
                  padding: EdgeInsets.symmetric(horizontal: containerWidth * 0.05),
                  decoration: BoxDecoration(
                    color: mainTheme.colorScheme.primaryContainer, // Blended background
                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildNumber(deck.numberOfCardsReview.toString(), Colors.blue, fontSize),
                        _buildNumber(deck.numberOfCardsLearn.toString(), Colors.red, fontSize),
                        _buildNumber(deck.numberOfCardsNew.toString(), Colors.green, fontSize),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _imagePreview() {
    return FutureBuilder(
      future: deck.imgPath,
      builder: (context, snapshot) {
        if (snapshot.hasData && deck.imgId != null) {
          return Image.file(
            File(snapshot.data!),
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          );
        }
        return const Center(
          child: Icon(Icons.image_not_supported, size: 50),
        );
      },
    );
  }

  Widget _buildNumber(String number, Color color, double fontSize) {
    return Text(
      number,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: color, // Blends softly
      ),
    );
  }
}

//Material

import 'package:auto_size_text/auto_size_text.dart';
import 'package:educator/models/deck_model.dart';
import 'package:educator/state/deck_list_state.dart';
import 'package:educator/widgets/custom_pop_up_deck.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

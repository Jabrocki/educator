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
    final deckState = Provider.of<DeckListState>(context, listen: false);

    // Methods for IconButton callbacks
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
        builder: (context) => const CustomPopUpDeck(),
      );

      if (deck.imgId != null) {
        deckState.imgFile = (await deck.imgFile)!;
      }
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        double iconSize = (constraints.maxWidth * 0.08).clamp(16.0, 32.0);
        double fontSize = (constraints.maxWidth * 0.05).clamp(10.0, 30.0);
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // LEFT (text)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: AutoSizeText(
                  deck.deckName,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                  ), 
                  maxLines: 3,
                  minFontSize: 8,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),

            // RIGHT (icons)
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
        );
      },
    );
  }
}
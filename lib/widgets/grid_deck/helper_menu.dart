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
      deckState.maximumNumberOfCardsToReview =
          deck.maximumNumberOfCardsToReview;
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
        double iconSize = constraints.maxHeight * 0.5;
        double iconDistance = iconSize * 1.5;
        double fontSize = constraints.maxHeight * 0.35;
        double textPadding = constraints.maxHeight * 0.2;
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 3,
                spreadRadius: 1,
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // LEFT (text)
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(textPadding),
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
                    onPressed: () {                    
                    },
                    icon: const Icon(Icons.add),
                    iconSize: iconSize,
                    padding: EdgeInsets.zero,
                    constraints:
                        BoxConstraints(minWidth: iconDistance), 
                  ),
                  IconButton(
                    onPressed: editDeck,
                    icon: const Icon(Icons.edit),
                    iconSize: iconSize,
                    padding: EdgeInsets.zero,
                    constraints:
                         BoxConstraints(minWidth: iconDistance), 
                  ),
                  IconButton(
                    onPressed: deleteDeck,
                    icon: const Icon(Icons.delete),
                    iconSize: iconSize,
                    padding: EdgeInsets.zero,
                    constraints:
                        BoxConstraints(minWidth: iconDistance), 
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

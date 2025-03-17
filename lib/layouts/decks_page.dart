//Material
import 'package:educator/models/deck_model.dart';
import 'package:educator/state/deck_list_state.dart';
import 'package:educator/state/main_state.dart';
import 'package:educator/widgets/grid_deck/animated_grid_deck.dart';
import 'package:flutter/material.dart';

//Provider
import 'package:provider/provider.dart';


class DecksPage extends StatelessWidget {
  const DecksPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final mainState = Provider.of<MainState>(context);
    final deckState = Provider.of<DeckListState>(context);

    return FutureBuilder(
      future: deckState.decksInit(mainState.subjectId), 
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<DeckModel> deckList = deckState.decks;
          return _body(context, deckList);
        } else {
          return const CircularProgressIndicator();
        }
      }
    );
  }

  Widget _body(
    BuildContext context,
    List<DeckModel> deckList
  ) {
    double screenWidth = MediaQuery.of(context).size.width;
    
    // Dynamically calculate crossAxisCount based on screen width
    int crossAxisCount = (screenWidth / 200).floor().clamp(2, 6); 
    // Ensures a minimum of 2 columns and a maximum of 6 columns
    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Decks",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(8),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              childAspectRatio: 1.0,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return AnimatedGridDeck(
                  deck: deckList[index],
                  index: index,
                  );
              },
              childCount: deckList.length,
            ),
          ),
        ),
      ],
    );
  }
}

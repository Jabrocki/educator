//Material
import 'package:flutter/material.dart';

//Widgets
import 'package:educator/widgets/grid_deck/helper_menu.dart';

//Internal Packges
import 'dart:io';

//Models
import '../../models/deck_model.dart';





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

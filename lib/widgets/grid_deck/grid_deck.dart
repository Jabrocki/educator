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
        double imageSize = constraints.maxWidth * 0.3;
        double borderRadius = constraints.maxWidth * 0.07;
        double menuHeight = constraints.maxWidth * 0.18;
        double fontSize = constraints.maxWidth * 0.05;

        double numbersHeight = constraints.maxWidth * 0.1;
        double numbersWidth = constraints.maxWidth * 0.35;

        return ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
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
                      child: _imagePreview(imageSize),
                    ),
                    SizedBox(height: menuHeight, child: HelperMenu(deck: deck)),
                  ],
                ),
              ),

              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  width: numbersWidth,
                  height: numbersHeight,
                  padding:
                      EdgeInsets.symmetric(horizontal: numbersWidth * 0.08),
                  decoration: BoxDecoration(
                    color: mainTheme
                        .colorScheme.primaryContainer,
                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 2,
                        spreadRadius: 1
                      )
                    ]  
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildNumber(deck.numberOfCardsReview.toString(),
                            Colors.blue, fontSize),
                        _buildNumber(deck.numberOfCardsLearn.toString(),
                            Colors.red, fontSize),
                        _buildNumber(deck.numberOfCardsNew.toString(),
                            Colors.green, fontSize),
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

  Widget _imagePreview(double imageSize) {
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
        return Center(
          child: Icon(Icons.image_not_supported, size: imageSize),
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

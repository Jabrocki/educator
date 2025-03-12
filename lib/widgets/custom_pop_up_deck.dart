//Material
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//Custom widgets
import 'image_picker_widget.dart';

//State
import '../state/deck_list_state.dart';

//External packages
import 'package:provider/provider.dart';

class CustomPopUpDeck extends StatelessWidget {
  const CustomPopUpDeck({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final deckListState = Provider.of<DeckListState>(context);
    return AlertDialog(
        title: const Text(
          "Add Deck",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                //Deck Name
                TextField(
                  controller: deckListState.deckNameController,
                  decoration: const InputDecoration(
                    labelText: "Deck Name",
                    hintText: "Enter deck name",
                  ),
                ),
                const SizedBox(height: 16),

                //Image Picker
                ImagePickerWidget(
                  image: deckListState.imgFile, //subjectListState.imgFile,
                  imageFileChanged: (imgFile) => deckListState.imgFile =
                      imgFile, //subjectListState.setImage,
                ),
                const SizedBox(height: 16),

                //Cards to learn day
                TextField(
                  controller: deckListState.deckNumberLearnController,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly
                  ], // Blocks non-numeric input
                  decoration: const InputDecoration(
                    labelText: "Cards to learn a day",
                    hintText: "Enter number of cards to learn a day",
                  ),
                ),
                const SizedBox(height: 16),

                //Cards to review a day
                TextField(
                  controller: deckListState.deckNumberReviewController,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly
                  ], // Blocks non-numeric input
                  decoration: const InputDecoration(
                    labelText: "Cards to review a day",
                    hintText: "Enter number of cards to review a day",
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left-aligned Icon
              IconButton(
                onPressed: deckListState.clearAddImage, //clearImage,
                icon: const Icon(Icons.clear),
              ),
              // Right-aligned Buttons
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      deckListState.clearAddData();
                      Navigator.of(context).pop();
                    },
                    child: const Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      if (deckListState.isEditing) {
                        deckListState.editDeck();
                      } else {
                        deckListState.addDeck();
                      }
                    },
                    child: const Text("Ok"),
                  ),
                ],
              ),
            ],
          ),
        ]);
  }
}

//Material
import 'package:flutter/material.dart';

//ImagePicker
import '../widgets/image_picker_widget.dart';

class DeckAddPage extends StatelessWidget {
  const DeckAddPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Add Deck",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
        ),
// Form inside a SliverList (wrapped by SliverPadding for spacing)
        SliverPadding(
          padding: const EdgeInsets.all(16.0),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                Form(
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Deck Name',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a deck name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),

                      // Your custom ImagePicker widget
                      // Make sure it calls onImageSelected(path) with the chosen image
                      
                        ImagePickerWidget(
                          image: null,
                          imageFileChanged: (image) {},
                        ),
                      const SizedBox(height: 16.0),

                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Maximum number of cards to learn a day',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty ||
                              int.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),


                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Maximum number of cards to review a day',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty ||
                              int.tryParse(value) == null) {
                            return 'Please enter a valid number for review cards';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),

                      // Button to save the deck
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text('Save Deck'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

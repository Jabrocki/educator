import 'package:flutter/material.dart';

import 'package:flutter_quill/flutter_quill.dart';

class FlashcardEdit extends StatefulWidget {
  const FlashcardEdit({
    super.key,
  });

  @override
  State<FlashcardEdit> createState() => _FlashcardEditState();
}

class _FlashcardEditState extends State<FlashcardEdit> {
  QuillController _controllerFront = QuillController.basic();

  @override
  void dispose() {
    _controllerFront.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        QuillSimpleToolbar(
          controller: _controllerFront,
          config: const QuillSimpleToolbarConfig()
        ),
        Expanded(
          child: QuillEditor.basic(
            controller: _controllerFront,
            config: const QuillEditorConfig(),
          )
        )
      ],
    );
  }
}

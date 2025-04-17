
import 'package:educator/widgets/flashcard_edit/helper_widgets/custom_quill_editor.dart';
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
  final QuillController _frontCardController = QuillController.basic();
  final QuillController _backCardController = QuillController.basic();

  final FocusNode _editorFocusNodeFront = FocusNode();
  final FocusNode _editorFocusNodeBack = FocusNode();

  @override
  void dispose() {
    _frontCardController.dispose();
    _backCardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mainTheme = Theme.of(context);

    return LayoutBuilder(builder: (context, constraints) {
      final double borderRadius = constraints.maxWidth * 0.03;
      final double editorDistance = constraints.maxHeight * 0.02;
      final double editorPadding = constraints.maxWidth * 0.01;

      //Card height
      final double editorHeight = constraints.maxHeight * 0.4;

      //Font size
      final double fontSize = constraints.maxHeight * 0.03;

      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 1,
              spreadRadius: 1,
            ),
          ],
          color: mainTheme.colorScheme.primaryContainer,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Front card
            Align(
              alignment: const Alignment(-0.95, 0),
              child: Text(
                "Front Card",
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(editorPadding),
              child: SizedBox(
                height: editorHeight,
                child: CustomQuillEditor(
                  quillController: _frontCardController,
                  focusNode: _editorFocusNodeFront,
                ),
              ),
            ),
            SizedBox(
              height: editorDistance,
            ),

            //Back card
            Align(
              alignment: const Alignment(-0.95, 0),
              child: Text(
                "Back Card",
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(editorPadding),
              child: SizedBox(
                height: editorHeight,
                child: CustomQuillEditor(
                  quillController: _backCardController,
                  focusNode: _editorFocusNodeBack,
                ),
              ),
            )
          ],
        ),
      );
    });
  }
}

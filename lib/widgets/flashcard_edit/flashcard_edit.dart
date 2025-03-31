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
  QuillController _controllerBack = QuillController.basic();

  @override
  void dispose() {
    _controllerFront.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final editorHeight = constraints.maxHeight * 0.4;
      final editorWidth = constraints.maxWidth * 0.95;
      //final textAlignment
      return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Theme.of(context).cardColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 2,
              )
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Align(
              alignment: Alignment(-0.9, 0),
              child: Text(
                "Frontcard",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              height: editorHeight,
              width: editorWidth,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 2,
                    )
                  ]),
              child: Column(
                children: [
                  QuillSimpleToolbar(
                      controller: _controllerBack,
                      config: const QuillSimpleToolbarConfig(
                          showListCheck: false, showCodeBlock: false)),
                  Expanded(
                      child: QuillEditor.basic(
                    controller: _controllerBack,
                    config: const QuillEditorConfig(),
                  ))
                ],
              ),
            ),
            const Align(
              alignment: Alignment(-0.9, 0),
              child: Text(
                "Backcard",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              height: editorHeight,
              width: editorWidth,
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorLight,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 2,
                    )
                  ]),
              child: Column(
                children: [
                  SizedBox(height: editorHeight*0.05,),
                  Container(
                    width: editorWidth*0.95,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColorLight,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 2,
                          )
                        ]),
                    child: QuillSimpleToolbar(
                        controller: _controllerFront,
                        config: const QuillSimpleToolbarConfig(
                            showListCheck: false, showCodeBlock: false)),
                  ),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: QuillEditor.basic(
                      controller: _controllerFront,
                      config: const QuillEditorConfig(),
                    ),
                  ))
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}

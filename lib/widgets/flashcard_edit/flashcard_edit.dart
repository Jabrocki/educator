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
  final QuillController _controllerFront = QuillController.basic();
  final QuillController _controllerBack = QuillController.basic();

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
      final quillIconSize = constraints.maxWidth * 0.02;
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
        child: Stack(children: [
          Column(
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
              CustomQuillEditor(editorHeight: editorHeight, editorWidth: editorWidth, controllerBack: _controllerFront, iconSize: quillIconSize),
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
              CustomQuillEditor(editorHeight: editorHeight, editorWidth: editorWidth, controllerBack: _controllerBack, iconSize: quillIconSize),
            ],
          ),
          Positioned(
              top: 8,
              right: 8,
              child: Row(
                children: [
                  IconButton(onPressed: () {}, icon: Icon(Icons.save)),
                  IconButton(onPressed: () {}, icon: Icon(Icons.clear)),
                  IconButton(onPressed: () {}, icon: Icon(Icons.delete)),
                ],
              ))
        ]),
      );
    });
  }
}

class CustomQuillEditor extends StatelessWidget {
  const CustomQuillEditor({
    super.key,
    required this.editorHeight,
    required this.editorWidth,
    required QuillController controllerBack,
    required this.iconSize
  }) : _controllerBack = controllerBack;

  final double editorHeight;
  final double editorWidth;
  final QuillController _controllerBack;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    print(iconSize);
    return Container(
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
          SizedBox(
            height: editorHeight * 0.05,
          ),
          Container(
              width: editorWidth * 0.95,
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
                  controller: _controllerBack,
                  config: QuillSimpleToolbarConfig(
                    iconTheme: QuillIconTheme(
                      iconButtonSelectedData: IconButtonData(
                        iconSize: iconSize
                      )
                    ),
                    buttonOptions: QuillSimpleToolbarButtonOptions(
                      base: QuillToolbarBaseButtonOptions(
                        iconSize: iconSize
                      )
                    ),
                    toolbarSize: 20,
                    toolbarRunSpacing: 1,
                      showListCheck: false,
                      showCodeBlock: false,
                      showSearchButton: false,
                      showLink: false,
                      showInlineCode: false,
                      showQuote: false))),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: QuillEditor.basic(
              controller: _controllerBack,
              config: const QuillEditorConfig(),
            ),
          ))
        ],
      ),
    );
  }
}

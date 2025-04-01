import 'package:educator/models/flashcard_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

import 'package:provider/provider.dart';
import '../../state/flashcard_list_state.dart';

class FlashcardEdit extends StatefulWidget {
  final FlashcardModel flashcard;
  const FlashcardEdit({
    super.key,
    required this.flashcard
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
      //Editor size
      final editorHeight = constraints.maxHeight * 0.4;
      final editorWidth = constraints.maxWidth * 0.95;

      //Border radius
      final borderRadius = constraints.maxWidth * 0.02;

      //Quill icon size
      final quillIconSize = constraints.maxWidth * 0.018;
      final quillIconPadding = constraints.maxWidth * 0.007;

      //Font
      final fontSize = constraints.maxWidth * 0.027;

      //Menu
      final iconSize = constraints.maxWidth * 0.03;
      final iconPositioning = constraints.maxWidth * 0.015;
      final iconDistance = constraints.maxWidth * 0.01;

      //flashcard state
      final flashCardState = Provider.of<FlashcardListState>(context, listen: false);

      return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
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
              Align(
                alignment: const Alignment(-0.95, 0),
                child: Text(
                  "Frontcard",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              CustomQuillEditor(
                editorHeight: editorHeight,
                editorWidth: editorWidth,
                quillController: _controllerFront,
                quillIconPadding: quillIconPadding,
                quillIconSize: quillIconSize,
              ),
              Align(
                alignment: const Alignment(-0.95, 0),
                child: Text(
                  "Backcard",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              CustomQuillEditor(
                editorHeight: editorHeight,
                editorWidth: editorWidth,
                quillController: _controllerBack,
                quillIconPadding: quillIconPadding,
                quillIconSize: quillIconSize,
              ),
            ],
          ),
          Positioned(
              top: iconPositioning,
              right: iconPositioning,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.save,
                      size: iconSize,
                    ),
                    padding: EdgeInsets.all(iconDistance),
                    constraints: const BoxConstraints(minWidth: 0),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.clear,
                      size: iconSize,
                    ),
                    padding: EdgeInsets.all(iconDistance),
                    constraints: const BoxConstraints(minWidth: 0),
                  ),
                  IconButton(
                    onPressed: () => flashCardState.deleteFlashcard(flashcard: widget.flashcard),
                    icon: Icon(
                      Icons.delete,
                      size: iconSize,
                    ),
                    padding: EdgeInsets.all(iconDistance),
                    constraints: const BoxConstraints(minWidth: 0),
                  ),
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
    required QuillController quillController,
    required this.quillIconSize,
    required this.quillIconPadding,
  }) : _quillController = quillController;

  final double editorHeight;
  final double editorWidth;
  final double quillIconSize;
  final double quillIconPadding;
  final QuillController _quillController;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: editorHeight,
      width: editorWidth,
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColorLight,
          borderRadius: BorderRadius.circular(8),
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
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 2,
                  )
                ]),
            child: CustomQuillToolBar(
              quillController: _quillController,
              iconPadding: quillIconPadding,
              iconSize: quillIconSize,
            ),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: QuillEditor.basic(
              controller: _quillController,
              config: const QuillEditorConfig(),
            ),
          ))
        ],
      ),
    );
  }
}

class CustomQuillToolBar extends StatelessWidget {
  final double iconSize;
  final double iconPadding;

  const CustomQuillToolBar(
      {super.key,
      required QuillController quillController,
      required this.iconSize,
      required this.iconPadding})
      : _quillController = quillController;

  final QuillController _quillController;

  @override
  Widget build(BuildContext context) {
    return QuillSimpleToolbar(
      controller: _quillController,
      config: QuillSimpleToolbarConfig(
        showCodeBlock: false,
        showListCheck: false,
        showDividers: false,
        showSearchButton: false,
        showLink: false,
        showInlineCode: false,
        showHeaderStyle: false,
        showQuote: false,
        showClearFormat: false,
        showAlignmentButtons: true,
        showIndent: false,
        showFontFamily: false,
        buttonOptions: QuillSimpleToolbarButtonOptions(
          base: QuillToolbarBaseButtonOptions(
            iconSize: iconSize,
            iconTheme: QuillIconTheme(
              iconButtonSelectedData: IconButtonData(
                padding: EdgeInsets.all(iconPadding),
                constraints: const BoxConstraints(minWidth: 0),
              ),
              iconButtonUnselectedData: IconButtonData(
                padding: EdgeInsets.all(iconPadding),
                constraints: const BoxConstraints(minWidth: 0),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

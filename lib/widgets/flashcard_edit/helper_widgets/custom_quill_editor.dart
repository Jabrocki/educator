import 'package:educator/widgets/flashcard_edit/helper_widgets/custom_quill_toolbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'dart:math';

class CustomQuillEditor extends StatefulWidget {
  final QuillController quillController;
  final FocusNode focusNode;

  const CustomQuillEditor({
    super.key,
    required this.quillController,
    required this.focusNode,
  });

  @override
  State<CustomQuillEditor> createState() => _CustomQuillEditorState();
}

class _CustomQuillEditorState extends State<CustomQuillEditor> {
  @override
  Widget build(BuildContext context) {
    final mainTheme = Theme.of(context);

    return LayoutBuilder(builder: (context, constraints) {
      //Border radious
      final double borderRadius = constraints.maxWidth * 0.02;

      //Whole editor
      final double editorPadding = constraints.maxWidth * 0.02;

      //Toolbar
      final double toolbarWidth = constraints.maxWidth * 0.95;
      final double toolbarHeight =
          min(constraints.maxWidth * 0.1, constraints.minHeight * 0.17);
      final double toolbarBorderRadius = constraints.maxWidth * 0.01;

      //Textfield
      final double textFieldHeight = constraints.maxHeight * 0.63;
      final double textFieldWidth = toolbarWidth;
      final double textFieldPadding = borderRadius/2;

      return Container(
        decoration: BoxDecoration(
          color: mainTheme.colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 1,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(editorPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: toolbarWidth,
                height: toolbarHeight,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: mainTheme.colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(toolbarBorderRadius),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 1,
                      spreadRadius: 1,
                    )
                  ],
                ),
                child: CustomQuillToolbar(widget: widget),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: textFieldHeight,
                width: textFieldWidth,
                decoration: BoxDecoration(
                  color: mainTheme.colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(borderRadius),
                  border: Border.all(
                    color: Colors.black, 
                    width: 0.2, 
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(textFieldPadding),
                  child: QuillEditor.basic(
                    controller: widget.quillController,
                    focusNode: widget.focusNode,
                    config: const QuillEditorConfig(),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

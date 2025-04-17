import 'dart:math';
import 'package:educator/widgets/flashcard_edit/helper_widgets/custom_quill_editor.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class CustomQuillToolbar extends StatelessWidget {
  const CustomQuillToolbar({
    super.key,
    required this.widget,
  });

  final CustomQuillEditor widget;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      
      final double iconSize =
          min(constraints.maxWidth * 0.015, constraints.maxHeight * 0.3);
      final double iconWidth =
          min(constraints.maxWidth * 0.037, constraints.maxHeight * 0.9);

      return QuillSimpleToolbar(
        controller: widget.quillController,
        config: QuillSimpleToolbarConfig(
          showFontFamily: false,
          showDividers: false,
          showLink: false,
          showSearchButton: false,
          showCodeBlock: false,
          showHeaderStyle: false,
          showInlineCode: false,
          showListCheck: false,
          showQuote: false,
          showAlignmentButtons: true,
          toolbarIconAlignment: WrapAlignment.spaceEvenly,
          buttonOptions: QuillSimpleToolbarButtonOptions(
            base: QuillToolbarBaseButtonOptions(
                afterButtonPressed: () {
                  final isDesktop = {
                    TargetPlatform.linux,
                    TargetPlatform.windows,
                    TargetPlatform.macOS
                  }.contains(defaultTargetPlatform);
                  if (isDesktop) {
                    widget.focusNode.requestFocus();
                  }
                },
                iconSize: iconSize,
                iconTheme: QuillIconTheme(
                    iconButtonSelectedData: IconButtonData(
                        iconSize: iconSize,
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(minWidth: iconWidth)),
                    iconButtonUnselectedData: IconButtonData(
                        iconSize: iconSize,
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(minWidth: iconWidth)))),
          ),
        ),
      );
    });
  }
}

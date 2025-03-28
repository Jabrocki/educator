//Item model
import 'package:educator/models/menu_item_model.dart';

//Material
import 'package:flutter/material.dart';

class GridMenu extends StatelessWidget {
  final MenuItemModel menuItemModel;
  const GridMenu({super.key, required this.menuItemModel});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate icon size as 50% of the widget's width.
        double iconSize = constraints.maxWidth * 0.5;
        double fontSize = constraints.maxWidth * 0.08;
        double borderRadius = constraints.maxWidth * 0.07;

        //Theme
        final mainTheme = Theme.of(context);

        return Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 1,
                  spreadRadius: 1,
                )
              ]),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius),
                color: mainTheme.colorScheme.primaryContainer,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Center(
                      child: Icon(
                        menuItemModel.icon,
                        size: iconSize,
                      ),
                    ),
                  ),
                  // The text uses the computed font size.
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      menuItemModel.label,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: fontSize,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

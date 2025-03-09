import 'package:educator/models/menu_item_model.dart';
import 'package:flutter/material.dart';

class GridMenu extends StatefulWidget {
  final int index;
  final MenuItemModel menuItemModel;
  const GridMenu(
      {super.key,
      required this.index,
      required this.menuItemModel
    });

  @override
  State<GridMenu> createState() => _GridMenuState();
}

class _GridMenuState extends State<GridMenu> {
  double _initScale = 0.0;
  double _pressedScale = 1.0;

  // Combine both scale factors
  double get _combinedScale => _initScale * _pressedScale;


  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 100 * widget.index), () {
      if (mounted) {
        setState(() {
          _initScale = 1.0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _combinedScale,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutBack,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
                // When the user presses down, shrink the widget
        onTapDown: (details) {
          setState(() {
            _pressedScale = 0.95;
          });
        },
        // When the user lifts their finger, return to full scale
        onTapUp: (details) {
          setState(() {
            _pressedScale = 1.0;
          });
        },
        // If the tap is canceled, return to full scale
        onTapCancel: () {
          setState(() {
            _pressedScale = 1.0;
          });
        },
        onTap: () {
                      Navigator.of(context).pushNamed(
              widget.menuItemModel.navigation,
            );
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Calculate icon size as 50% of the widget's width.
            double iconSize = constraints.maxWidth * 0.5;
            // Calculate font size as 15% of the width, clamped between 12 and 20.
            double fontSize = (constraints.maxWidth * 0.09).clamp(12.0, 20.0);

            return ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.grey[300],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // The icon scales responsively.
                    Expanded(
                      child: Center(
                        child: Icon(
                          widget.menuItemModel.icon,
                          size: iconSize,
                        ),
                      ),
                    ),
                    // The text uses the computed font size.
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        widget.menuItemModel.label,
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
            );
          },
        ),
      ),
    );
  }
}

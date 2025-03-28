//Item model

import 'package:educator/models/menu_item_model.dart';
import 'package:educator/widgets/grid_menu/grid_menu.dart';
import 'package:flutter/material.dart';

class AnimatedGridMenu extends StatelessWidget {
  final MenuItemModel menuItemModel;
  final Animation<double> animation;

  const AnimatedGridMenu(
      {super.key, required this.menuItemModel, required this.animation});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final double borderRadius = constraints.maxWidth * 0.05;

      return AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return Transform.scale(
              scale: animation.value,
              child: child,
            );
          },
          child: InkWell(
            borderRadius: BorderRadius.circular(borderRadius),
            onTap: () {
              Navigator.of(context).pushNamed(menuItemModel.navigation);
            },
            child: GridMenu(menuItemModel: menuItemModel),
          ));
    });
  }
}

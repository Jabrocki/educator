//Item model

import 'package:educator/models/menu_item_model.dart';
import 'package:educator/widgets/grid_menu/grid_menu.dart';
import 'package:flutter/material.dart';

class AnimatedGridMenu extends StatefulWidget {
  final MenuItemModel menuItemModel;
  final Animation<double> animation;

  const AnimatedGridMenu(
      {super.key, required this.menuItemModel, required this.animation});

  @override
  State<AnimatedGridMenu> createState() => _AnimatedGridMenuState();
}

class _AnimatedGridMenuState extends State<AnimatedGridMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController _pressController;
  late Animation<double> _pressAnimation;

  @override
  void initState() {
    super.initState();

    _pressController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 150));

    _pressAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
        CurvedAnimation(parent: _pressController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _pressController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _pressController.reverse();
  }

  void _onTapCancel() {
    _pressController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final double borderRadius = constraints.maxWidth * 0.05;

      return AnimatedBuilder(
          animation: Listenable.merge([widget.animation, _pressAnimation]),
          builder: (context, child) {
            final double combinedScale =
                widget.animation.value * _pressAnimation.value;
            return Transform.scale(
              scale: combinedScale,
              child: child,
            );
          },
          child: InkWell(
            borderRadius: BorderRadius.circular(borderRadius),
            onTap: () {
              Navigator.of(context).pushNamed(widget.menuItemModel.navigation);
            },
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            child: GridMenu(menuItemModel: widget.menuItemModel),
          ));
    });
  }
}

//Models
import 'package:educator/models/menu_item_model.dart';
import 'package:educator/state/animation_state.dart';
import 'package:provider/provider.dart';

//Widgets
import 'package:educator/widgets/grid_menu/animated_grid_menu.dart';

//Material
import 'package:flutter/material.dart';

class MenuSubjectPage extends StatefulWidget {
  const MenuSubjectPage({
    super.key,
  });

  @override
  State<MenuSubjectPage> createState() => _MenuSubjectPageState();
}

class _MenuSubjectPageState extends State<MenuSubjectPage>
    with SingleTickerProviderStateMixin {
  //List of menu items
  final List<MenuItemModel> menuItems = [
    const MenuItemModel(
      label: "FlashCards",
      icon: Icons.web_stories,
      navigation: "/subjects/menu/decks",
    ),
    const MenuItemModel(
        label: "Quizes", icon: Icons.quiz, navigation: "/subjects/menu/quizes"),
    const MenuItemModel(
        label: "Notes", icon: Icons.note, navigation: "/subjects/menu/notes"),
    const MenuItemModel(
        label: "Files",
        icon: Icons.file_open,
        navigation: "/subjects/menu/files")
  ];

  //Animation data
  late AnimationController _controller;
  bool _isInitialized = false;

  final int _itemAnimationDuration = 500;
  final int _itemDelay = 100;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      int count = menuItems.length;
      int totalDuration = count > 0
          ? _itemDelay * (count - 1) + _itemAnimationDuration
          : _itemAnimationDuration;

      _controller = AnimationController(
          vsync: this, duration: Duration(milliseconds: totalDuration));

      _controller.forward();
      setState(() {
        _isInitialized = true;
      });
    });
  }

  @override
  void dispose() {
    if (_isInitialized) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _reAnimate() {
    _controller.reset();
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AnimationState>(builder: (_, animationState, __) {
      if (!_isInitialized) {
        return const Center(child: CircularProgressIndicator());
      }
      if (animationState.reAnimate) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _reAnimate();
            animationState.reAnimate = false;
          }
        });
      }

      if (animationState.selectedIndex != 1 && _controller.isAnimating) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _controller.reset();
          }
        });
      }

      int crossAxisCount =
          (MediaQuery.of(context).size.width / 200).clamp(1, 6).toInt();
      return Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Menu",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SliverPadding(
                padding: const EdgeInsets.all(8),
                sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                      childAspectRatio: 1.0,
                    ),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      int delay = _itemDelay * index;
                      double start =
                          delay / _controller.duration!.inMilliseconds;
                      double end = (delay + _itemAnimationDuration) /
                          _controller.duration!.inMilliseconds;

                      Animation<double> childAnimation = Tween<double>(
                        begin: 0.0,
                        end: 1.0,
                      ).animate(
                        CurvedAnimation(
                          parent: _controller,
                          curve:
                              Interval(start, end, curve: Curves.easeOutBack),
                        ),
                      );

                      return AnimatedGridMenu(
                          menuItemModel: menuItems[index],
                          animation: childAnimation);
                    }, childCount: menuItems.length))),
          ],
        ),
      );
    });
  }
}

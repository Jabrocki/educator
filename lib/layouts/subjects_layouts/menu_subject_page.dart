//Models
import 'package:educator/models/menu_item_model.dart';
import 'package:educator/state/animation_state.dart';
import 'package:provider/provider.dart';

//Widgets
import 'package:educator/widgets/grid_menu.dart';

//Material
import 'package:flutter/material.dart';

class MenuSubjectPage extends StatefulWidget {
  const MenuSubjectPage({
    super.key,
  });

  @override
  State<MenuSubjectPage> createState() => _MenuSubjectPageState();
}

class _MenuSubjectPageState extends State<MenuSubjectPage> {
  late final List<GlobalKey<GridMenuState>> gridMenuKeys;
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

  @override
  void initState() {
    super.initState();
    gridMenuKeys =
        List.generate(menuItems.length, (_) => GlobalKey<GridMenuState>());
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
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
        Consumer<AnimationState>(builder: (_, animationState, ___) {
          if (animationState.reAnimate) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              animationState.reAnimate = false;
            });
          } 
          return SliverPadding(
              padding: const EdgeInsets.all(8),
              sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    childAspectRatio: 1.0,
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    gridMenuKeys[index].currentState?.reAnimate();
                    return GridMenu(
                      key: gridMenuKeys[index],
                      index: index,
                      menuItemModel: menuItems[index],
                    );
                  }, childCount: menuItems.length)));
        }),
      ],
    );
  }
}

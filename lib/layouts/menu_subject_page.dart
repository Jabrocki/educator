import 'package:educator/models/menu_item_model.dart';
import 'package:educator/widgets/grid_menu.dart';
import 'package:flutter/material.dart';

class MenuSubjectPage extends StatelessWidget {
  const MenuSubjectPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    //Calculate number of silvers grids
    double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = (screenWidth / 200).floor().clamp(2, 6);

    //List of menu items
    final List<MenuItemModel> menuItems = [
      const MenuItemModel(label: "FlashCards", icon: Icons.web_stories, navigation: "/subjects/menu/decks"),
      const MenuItemModel(label: "Quizes", icon: Icons.quiz, navigation: "/subjects/menu/quizes"),
      const MenuItemModel(label: "Notes", icon: Icons.note, navigation: "/subjects/menu/notes"),
      const MenuItemModel(label: "Files", icon: Icons.file_open, navigation: "/subjects/menu/files")
    ];

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
                return GridMenu(
                    index: index,
                    menuItemModel: menuItems[index],);
              }, childCount: menuItems.length)),
        ),
      ],
    );
  }
}

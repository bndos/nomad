import 'package:flutter/material.dart';

class CustomTabBar extends StatelessWidget {
  final TabController? tabController;
  final List<IconData> icons;

  const CustomTabBar({Key? key, this.tabController, required this.icons})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = tabController ?? DefaultTabController.of(context);

    return Container(
      color: Colors.white,
      child: TabBar(
        indicatorColor: Colors.black,
        controller: controller,
        tabs: icons.map((icon) {
          return Tab(
            height: 24,
            iconMargin: const EdgeInsets.all(0),
            icon: Icon(
              icon,
              color: Colors.black,
              size: 20,
            ),
          );
        }).toList(),
      ),
    );
  }
}

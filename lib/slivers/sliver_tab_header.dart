import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nomad/widgets/tabbar/custom_tab_bar.dart';

class CustomSliverHeader extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  CustomSliverHeader({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(CustomSliverHeader oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

class SliverTabHeaderWidget extends StatelessWidget {
  final TabController tabController;

  const SliverTabHeaderWidget({
    Key? key,
    required this.tabController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: CustomSliverHeader(
        minHeight: 48.0,
        maxHeight: 48.0,
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 42.0),
            child: CustomTabBar(
              tabController: tabController,
              icons: const [
                Iconsax.link,
                Iconsax.grid_1,
                Iconsax.video_circle,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

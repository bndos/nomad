import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class SliverTabHeader extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  SliverTabHeader({
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
  bool shouldRebuild(SliverTabHeader oldDelegate) {
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
      delegate: SliverTabHeader(
        minHeight: 48.0,
        maxHeight: 48.0,
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 42.0),
            child: TabBar(
              indicatorSize: TabBarIndicatorSize.label,
              indicatorColor: Colors.black,
              controller: tabController,
              tabs: const [
                Tab(
                  height: 24,
                  iconMargin: EdgeInsets.all(0),
                  icon: Icon(
                    Iconsax.link,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
                Tab(
                  height: 24,
                  icon: Icon(
                    Iconsax.grid_1,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
                Tab(
                  height: 24,
                  icon: Icon(
                    Iconsax.video_circle,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

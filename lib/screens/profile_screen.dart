import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //settings left
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.only(top: 30, left: 10),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Iconsax.setting,
                color: Colors.black,
              ),
            ),
          ),
        ),

        Align(
          alignment: Alignment.center,
          child: Container(
            margin: const EdgeInsets.only(top: 30),
            alignment: Alignment.center,
            color: Colors.transparent,
            // we can set width here with conditions
            height: kToolbarHeight,
            child: TextButton(
              onPressed: () {},
              child: const Text(
                'Username',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            margin: const EdgeInsets.only(top: 30, right: 10),
            alignment: Alignment.center,
            color: Colors.transparent,
            // we can set width here with conditions
            width: 40,
            height: kToolbarHeight,
            child: IconButton(
              icon: const Icon(
                Iconsax.message,
                color: Colors.black,
              ),
              onPressed: () {
                //TODO
              },
            ),
          ),
        ),
      ],
    );
  }

  ///width doesnt matter
  @override
  Size get preferredSize => const Size(200, kToolbarHeight);
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const MyAppBar(),
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Container(
                      color: Colors.white,
                      child: SafeArea(
                        child: Row(
                          children: [
                            Container(
                              margin:
                                  const EdgeInsets.only(left: 20, right: 10),
                              height: 70,
                              width: 70,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(100),
                                ),
                              ),
                            ),
                            // text username
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverAppBarDelegate(
                  minHeight: 48.0,
                  maxHeight: 48.0,
                  child: Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 42.0),
                      child: TabBar(
                        indicatorSize: TabBarIndicatorSize.label,
                        indicatorColor: Colors.black,
                        controller: _tabController,
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
              ),
            ],
            body: TabBarView(
              controller: _tabController,
              children: const [
                // Sub events or linked events tab
                SingleChildScrollView(
                  child: Center(
                    child: Column(
                      children: [
                        Text('Sub Events or Linked Events'),
                      ],
                    ),
                  ),
                ),
                // Pictures tab
                SingleChildScrollView(
                  child: Center(
                    child: Text('Feed'),
                  ),
                ),
                // Videos tab
                SingleChildScrollView(
                  child: Center(
                    child: Text('Videos'),
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

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _SliverAppBarDelegate({
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
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

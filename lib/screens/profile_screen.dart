import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nomad/models/event/event.dart';
import 'package:nomad/widgets/events/event_form.dart';
import 'package:nomad/widgets/events/event_preview.dart';
import 'package:nomad/widgets/map/rounded_icon_button.dart';

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
  bool _isFriend = false;
  List<Event> events = [];

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

  void _handleEventCreated(Event event) {
    setState(() {
      events.add(event);
    });
  }

  void _openEventForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return EventForm(
          onEventCreated: _handleEventCreated,
        );
      },
    );
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
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20, left: 20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Container(
                                  height: 70,
                                  width: 70,
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(100),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Name',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  margin: const EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  child: const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      // number of friends
                                      Text(
                                        '0',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        'Events',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  margin: const EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  child: const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      // number of friends
                                      Text(
                                        '0',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        'Friends',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  child: const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      // number of friends
                                      Text(
                                        '0',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        'Mutual',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec quis nisl nec nisl aliquam ultrices. Donec quis nisl nec nisl aliquam ultrices.',
                                style: TextStyle(
                                  fontSize: 13.0,
                                  color: Colors
                                      .black, // Reduce opacity of the text when disabled
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RoundedIconButton(
                              // participate
                              height: 32,
                              icon: CupertinoIcons.person_badge_plus_fill,
                              color: _isFriend
                                  ? Colors.grey.shade100
                                  : Colors.blue.shade200,
                              label: _isFriend ? 'Friends' : 'Add friend',
                              onPressed: () {
                                // Perform create event action
                                setState(() {
                                  _isFriend = !_isFriend;
                                });
                              },
                            ),
                            RoundedIconButton(
                              height: 32,
                              icon: CupertinoIcons.plus_app,
                              label: 'Invite',
                              color: Colors.grey.shade100,
                              onPressed: () {
                                // Perform share action
                              },
                            ),
                            RoundedIconButton(
                              height: 32,
                              icon: CupertinoIcons.paperplane_fill,
                              label: 'Share',
                              color: Colors.grey.shade100,
                              onPressed: () {
                                // Perform share action
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 42.0,
                        vertical: 8.0,
                      ),
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
              children: [
                // Sub events or linked events tab
                if (events.isNotEmpty) ...[
                  OverflowBox(
                    alignment: Alignment.topCenter,
                    maxHeight: double.infinity,
                    child: Column(
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height - 100,
                            minHeight: 0,
                          ),
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: events.length,
                            itemBuilder: (BuildContext context, int index) {
                              final event = events[index];
                              return EventPreview(event: event);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                if (events.isEmpty)
                  const Center(
                    child: Text(
                      'No events found',
                    ),
                  ),

                // Pictures tab
                const SingleChildScrollView(
                  child: Center(
                    child: Text('Feed'),
                  ),
                ),
                // Videos tab
                const SingleChildScrollView(
                  child: Center(
                    child: Text('Videos'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: IconButton(
        icon: const FaIcon(FontAwesomeIcons.plus),
        iconSize: 20.0,
        onPressed: () => _openEventForm(context),
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

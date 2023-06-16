import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:nomad/models/event/event.dart';
import 'package:nomad/widgets/map/rounded_icon_button.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const MyAppBar({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: const EdgeInsets.only(top: 30, left: 10),
              alignment: Alignment.center,
              color: Colors.transparent,
              // we can set width here with conditions
              width: 40,
              height: kToolbarHeight,
              child: IconButton(
                icon: const Icon(
                  FontAwesomeIcons.chevronLeft,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
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
      ),
    );
  }

  ///width doesnt matter
  @override
  Size get preferredSize => const Size(200, kToolbarHeight);
}

class EventPage extends StatefulWidget {
  final Event event;

  const EventPage({
    Key? key,
    required this.event,
  }) : super(key: key);

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> with TickerProviderStateMixin {
  late Event _event;
  late TabController _tabController;
  bool _isParticipating = false;

  @override
  void initState() {
    super.initState();
    _event = widget.event;
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
      appBar: MyAppBar(title: _event.placeName!),
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverToBoxAdapter(
              child: Stack(
                children: [
                  // container with image
                  Container(
                    height: 300,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(_event.imageUrls[0]),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.5),
                            Colors.black.withOpacity(0.0),
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                    ),
                  ),
                  // Content after the AppBar
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(top: 250),
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 20,
                          offset: const Offset(0, -30),
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        if (_event.startTime != null) const SizedBox(height: 8),
                        if (_event.startTime != null)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Iconsax.calendar_1,
                                size: 16,
                                color: Colors.black,
                              ),
                              const SizedBox(width: 4),
                              // AUG 17 AT 7:00 PM - AUG 18 AT 12:00 AM
                              Text(
                                DateFormat(
                                  'MMM d AT h:mm a',
                                  'en_US',
                                ).format(_event.startTime!).toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                ),
                              ),
                              if (_event.endTime != null)
                                Text(
                                  " - ${DateFormat('MMM d AT h:mm a', 'en_US').format(_event.endTime!)}"
                                      .toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                  ),
                                ),
                            ],
                          ),
                        if (_event.placeName != null) const SizedBox(height: 8),
                        if (_event.placeName != null)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                FontAwesomeIcons.locationArrow,
                                size: 16,
                                color: Colors.blue,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _event.placeName ?? '',
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        if (_event.details != null &&
                            _event.details!.isNotEmpty)
                          const SizedBox(height: 16),
                        if (_event.details != null &&
                            _event.details!.isNotEmpty)
                          Text(
                            _event.details!,
                            style: const TextStyle(fontSize: 14),
                          ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RoundedIconButton(
                              // participate
                              icon: CupertinoIcons.person_badge_plus_fill,
                              color: _isParticipating
                                  ? Colors.grey.shade100
                                  : Colors.blue.shade200,
                              label: _isParticipating
                                  ? 'Participating'
                                  : 'Participate',
                              onPressed: () {
                                // Perform create event action
                                setState(() {
                                  _isParticipating = !_isParticipating;
                                });
                              },
                            ),
                            RoundedIconButton(
                              icon: CupertinoIcons.paperplane_fill,
                              label: 'Share',
                              color: Colors.blue.shade200,
                              onPressed: () {
                                // Perform share action
                              },
                            ),
                          ],
                        ),
                      ],
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

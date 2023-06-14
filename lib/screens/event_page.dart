import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:nomad/models/event/event.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
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
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
      appBar: const MyAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                // container with image
                Container(
                  height: 250,
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
                // container with event details and shadow
                Container(
                  margin: const EdgeInsets.only(top: 240),
                  width: MediaQuery.of(context).size.width,
                  constraints: const BoxConstraints(
                    minHeight: 100,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.6),
                        blurRadius: 100,
                        spreadRadius: 2,
                        offset: const Offset(0, -20),
                      ),
                    ],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // event name
                        Text(
                          _event.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
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
                        Padding(
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
                        const SizedBox(height: 16),
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            // maxheight should be the available height of the safe area - 50 - appbar height
                            maxHeight: MediaQuery.of(context).size.height -
                                MediaQuery.of(context).padding.top -
                                MediaQuery.of(context).padding.bottom -
                                80,
                          ),
                          child: TabBarView(
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
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

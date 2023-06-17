import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nomad/models/event/event.dart';
import 'package:nomad/slivers/sliver_tab_header.dart';
import 'package:nomad/widgets/appbar/title_app_bar.dart';
import 'package:nomad/widgets/events/event_form.dart';
import 'package:nomad/widgets/events/events_list_view.dart';
import 'package:nomad/widgets/gallery/grid_gallery.dart';
import 'package:nomad/widgets/profile/profile_details.dart';

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
      appBar: const TitleAppBar(
        title: 'Username',
        leftIcon: Iconsax.setting,
        rightIcon: Iconsax.message,
      ),
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              const SliverToBoxAdapter(
                child: ProfileDetails(),
              ),
              SliverTabHeaderWidget(tabController: _tabController),
            ],
            body: TabBarView(
              controller: _tabController,
              children: [
                // Sub events or linked events tab
                EventsListView(events: events, emptyListText: 'No events yet'),
                const GridGallery(
                  imageUrls: [
                    "https://picsum.photos/500/800?random=0",
                    "https://picsum.photos/500/800?random=1",
                    "https://picsum.photos/500/800?random=2",
                    "https://picsum.photos/500/800?random=3",
                    "https://picsum.photos/500/800?random=4",
                    "https://picsum.photos/500/800?random=5",
                    "https://picsum.photos/500/800?random=6",
                    "https://picsum.photos/500/800?random=7",
                    "https://picsum.photos/500/800?random=8",
                    "https://picsum.photos/500/800?random=9",
                    "https://picsum.photos/500/800?random=11",
                    "https://picsum.photos/500/800?random=12",
                    "https://picsum.photos/500/800?random=13",
                    "https://picsum.photos/500/800?random=14",
                    "https://picsum.photos/500/800?random=15",
                    "https://picsum.photos/500/800?random=16",
                  ],
                  backgroundColor: Colors.white,
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

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nomad/models/event/event.dart';
import 'package:nomad/slivers/sliver_tab_header.dart';
import 'package:nomad/widgets/appbar/title_app_bar.dart';
import 'package:nomad/widgets/events/event_details.dart';
import 'package:nomad/widgets/events/event_form.dart';
import 'package:nomad/widgets/events/events_list_view.dart';

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
  List<Event> events = [];

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
      appBar: TitleAppBar(
        title: _event.name,
        leftIcon: FontAwesomeIcons.chevronLeft,
        rightIcon: Iconsax.message,
        onLeftIconPressed: () => Navigator.pop(context),
      ),
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverToBoxAdapter(
              child: EventDetails(
                event: _event,
                isParticipating: _isParticipating,
                onParticipatePressed: () {
                  setState(() {
                    _isParticipating = !_isParticipating;
                  });
                },
              ),
            ),
            SliverTabHeaderWidget(tabController: _tabController),
          ],
          body: TabBarView(
            controller: _tabController,
            children: [
              // Sub events or linked events tab
              EventsListView(events: events, emptyListText: 'No sub events'),

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
      floatingActionButton: IconButton(
        icon: const FaIcon(FontAwesomeIcons.plus),
        iconSize: 20.0,
        onPressed: () => _openEventForm(context),
      ),
    );
  }
}

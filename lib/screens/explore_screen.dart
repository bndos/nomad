import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nomad/models/event/event.dart';
import 'package:nomad/widgets/events/event_form.dart';
import 'package:nomad/widgets/events/event_preview.dart';

import 'package:nomad/widgets/search/search_field_ui.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({
    Key? key,
  }) : super(key: key);

  @override
  ExploreScreenState createState() => ExploreScreenState();
}

class ExploreScreenState extends State<ExploreScreen>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  List<String> _predictionStrings = [];
  List<Event> events = [];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    String input = _searchController.text;
    if (input.isNotEmpty) {
      _fetchAutocompletePredictions(input);
    } else {
      setState(() {
        _predictionStrings = [];
      });
    }
  }

  void _clearPredictions() {
    setState(() {
      _searchController.text = '';
      FocusScope.of(context).unfocus();
      _predictionStrings = [];
    });
  }

  void _fetchAutocompletePredictions(String input) async {
    _getPredictionString();
  }

  void _handlePredictionSelection(int? index) {
    _clearPredictions();
  }

  String _getPredictionString() {
    return '';
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
      body: Stack(
        children: [
          NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _SliverAppBarDelegate(
                    minHeight: MediaQuery.of(context).padding.top + 90,
                    maxHeight: MediaQuery.of(context).padding.top + 90,
                    child: Container(
                      //height is the safeara height + 90
                      height: MediaQuery.of(context).padding.top + 90,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12.withOpacity(0.075),
                            blurRadius: 40,
                            offset: const Offset(0, 10),
                          ),
                        ],
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                            child: SafeArea(
                              child: SearchFieldUI(
                                searchController: _searchController,
                                onSearchChanged: _onSearchChanged,
                                predictionStrings: _predictionStrings,
                                handlePredictionSelection:
                                    _handlePredictionSelection,
                                clearPredictions: _clearPredictions,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 42.0,
                              vertical: 4,
                            ),
                            child: TabBar(
                              indicatorSize: TabBarIndicatorSize.label,
                              controller: _tabController,
                              indicatorColor: Colors.black,
                              tabs: const [
                                Tab(
                                  height: 24,
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
                                    Iconsax.location,
                                    color: Colors.black,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ];
            },
            body: TabBarView(
              controller: _tabController,
              children: [
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
                const Center(
                  child: Text(
                    'No posts found',
                  ),
                ),
                const Center(
                  child: Text(
                    'No places found',
                  ),
                ),
              ],
            ),
          ),
        ],
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

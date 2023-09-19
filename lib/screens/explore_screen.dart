import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nomad/models/event/event.dart';
import 'package:nomad/slivers/sliver_tab_header.dart';
import 'package:nomad/widgets/events/event_form.dart';
import 'package:nomad/widgets/events/event_preview.dart';
import 'package:nomad/widgets/explore/explore_search_bar.dart';
import 'package:nomad/widgets/gallery/grid_gallery.dart';

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
    final double headerHeight = MediaQuery.of(context).padding.top + 90;
    return Scaffold(
      body: Stack(
        children: [
          NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverPersistentHeader(
                  pinned: true,
                  delegate: CustomSliverHeaderDelegate(
                    minHeight: headerHeight,
                    maxHeight: headerHeight,
                    child: ExploreSearchBar(
                      height: headerHeight,
                      tabController: _tabController,
                      predictionStrings: _predictionStrings,
                      handlePredictionSelection: _handlePredictionSelection,
                      clearPredictions: _clearPredictions,
                    ),
                  ),
                ),
              ];
            },
            body: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: TabBarView(
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
                              maxHeight: MediaQuery.of(context).size.height,
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
                  const Center(
                    child: Text(
                      'No places found',
                    ),
                  ),
                ],
              ),
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

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nomad/models/event/event.dart';
import 'package:nomad/widgets/events/event_form.dart';
import 'package:nomad/widgets/events/event_preview.dart';
import 'package:nomad/widgets/gallery/grid_gallery.dart';
import 'package:nomad/widgets/places/place_details.dart';
import 'package:nomad/widgets/tabbar/custom_tab_bar.dart';

class PlaceDetailsContainer extends StatefulWidget {
  final String placeName;
  final String address;
  final String distance;
  final List<PlaceType> types;
  final List<Image> placeImages;
  final VoidCallback? onHideContainer; // New callback function

  const PlaceDetailsContainer({
    Key? key,
    required this.placeName,
    required this.address,
    required this.types,
    required this.placeImages,
    required this.distance,
    this.onHideContainer,
  }) : super(key: key);

  @override
  PlaceDetailsContainerState createState() => PlaceDetailsContainerState();
}

class PlaceDetailsContainerState extends State<PlaceDetailsContainer>
    with TickerProviderStateMixin {
  double previousHeight = 200.0;
  double containerHeight = 200.0;
  double dragOffset = 0.0;
  List<Event> events = [];
  late AnimationController _animationController;
  late SpringDescription _spring;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _spring = const SpringDescription(
      mass: 1,
      stiffness: 100,
      damping: 10.0,
    );
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _animationController.dispose();
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
          placeName: widget.placeName,
          distance: widget.distance,
          onEventCreated: _handleEventCreated,
        );
      },
    );
  }

  void _handleVerticalDragUpdate(DragUpdateDetails details) {
    setState(() {
      previousHeight = containerHeight;
      containerHeight -= details.delta.dy;
    });
  }

  void _handleVerticalDragEnd(DragEndDetails details) {
    final screenHeight = MediaQuery.of(context).size.height;
    final appBarHeight = AppBar().preferredSize.height;
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final availableHeight =
        screenHeight - appBarHeight - statusBarHeight - bottomPadding;

    final snapPoints = [0.0, 200.0, screenHeight * 1 / 2, availableHeight];
    final currentHeight = containerHeight;
    final dragVelocity = currentHeight - previousHeight;

    double closestSnapPoint = currentHeight;

    if (dragVelocity > 0) {
      // Dragging downwards
      for (final point in snapPoints) {
        if (point > currentHeight) {
          closestSnapPoint = point;
          break;
        }
      }
    } else {
      // Dragging upwards
      for (var i = snapPoints.length - 1; i >= 0; i--) {
        final point = snapPoints[i];
        if (point < currentHeight) {
          closestSnapPoint = point;
          break;
        }
      }
    }

    closestSnapPoint = closestSnapPoint.clamp(0.0, availableHeight);

    final simulation = SpringSimulation(
      _spring,
      containerHeight,
      closestSnapPoint,
      details.velocity.pixelsPerSecond.dy,
    );
    containerHeight = closestSnapPoint;
    _animationController.animateWith(simulation);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: GestureDetector(
        onVerticalDragUpdate: _handleVerticalDragUpdate,
        onVerticalDragEnd:
            widget.onHideContainer != null ? _handleVerticalDragEnd : null,
        child: AnimatedContainer(
          width: double.infinity,
          height: containerHeight,
          padding: const EdgeInsets.only(
            top: 16.0,
            left: 4.0,
            right: 4.0,
            bottom: 0.0,
          ),
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOutQuart,
          onEnd: () => {
            if (containerHeight < 10)
              {
                widget.onHideContainer?.call(),
              }
          },
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 20.0,
                spreadRadius: 5.0,
              ),
            ],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.0),
              topRight: Radius.circular(16.0),
            ),
          ),
          child: OverflowBox(
            alignment: Alignment.topCenter,
            maxHeight: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PlaceDetails(
                  placeName: widget.placeName,
                  address: widget.address,
                  distance: widget.distance,
                  types: widget.types,
                  onAddEvent: () {
                    _openEventForm(context);
                  },
                  onDirections: () {
                    // Perform directions action
                  },
                  onShare: () {
                    // Perform share action
                  },
                ),
                CustomTabBar(
                  tabController: _tabController,
                  icons: const [
                    Iconsax.link,
                    Iconsax.grid_1,
                    Iconsax.video_circle,
                  ],
                ),
                MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height - 200,
                      minHeight: 0,
                    ),
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        if (events.isNotEmpty) ...[
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight:
                                  MediaQuery.of(context).size.height - 200,
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
                        if (events.isEmpty)
                          const Center(
                            child: Text(
                              'No events found',
                            ),
                          ),
                        GridGallery(
                          images: widget.placeImages,
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
          ),
        ),
      ),
    );
  }
}

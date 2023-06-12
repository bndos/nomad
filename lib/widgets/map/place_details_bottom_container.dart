import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:nomad/models/event/event.dart';
import 'package:nomad/widgets/events/event_form.dart';
import 'package:nomad/widgets/events/event_preview.dart';
import 'package:nomad/widgets/map/rounded_icon_button.dart';

class PlaceDetailsContainer extends StatefulWidget {
  final String placeName;
  final String address;
  final String distance;
  final List<PlaceType> types;
  final VoidCallback? onHideContainer; // New callback function

  const PlaceDetailsContainer({
    Key? key,
    required this.placeName,
    required this.address,
    required this.types,
    required this.distance,
    this.onHideContainer,
  }) : super(key: key);

  @override
  PlaceDetailsContainerState createState() => PlaceDetailsContainerState();
}

class PlaceDetailsContainerState extends State<PlaceDetailsContainer>
    with SingleTickerProviderStateMixin {
  double containerHeight = 200.0; // Initial height of the container
  double dragOffset = 0.0; // Offset for tracking the drag gesture
  List<Event> events = [];
  late AnimationController _animationController;
  late SpringDescription _spring;

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
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  IconData getIconForPlaceType(PlaceType placeType) {
    switch (placeType) {
      case PlaceType.UNIVERSITY:
        return FontAwesomeIcons.graduationCap;
      case PlaceType.RESTAURANT:
        return FontAwesomeIcons.utensils;
      case PlaceType.CAFE:
        return FontAwesomeIcons.mugSaucer;
      case PlaceType.BAR:
        return FontAwesomeIcons.champagneGlasses;
      case PlaceType.NIGHT_CLUB:
        return FontAwesomeIcons.champagneGlasses;
      case PlaceType.PARK:
        return FontAwesomeIcons.tree;
      case PlaceType.SHOPPING_MALL:
        return FontAwesomeIcons.bagShopping;
      case PlaceType.HOSPITAL:
        return FontAwesomeIcons.hospital;
      case PlaceType.MOVIE_THEATER:
        return FontAwesomeIcons.film;
      case PlaceType.MUSEUM:
        return FontAwesomeIcons.monument;
      case PlaceType.STADIUM:
        return FontAwesomeIcons.flag;
      case PlaceType.TOURIST_ATTRACTION:
        return FontAwesomeIcons.camera;
      case PlaceType.SUBWAY_STATION:
        return FontAwesomeIcons.trainSubway;
      default:
        return FontAwesomeIcons.locationPin; // Default icon
    }
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
    final closestSnapPoint = snapPoints.reduce((prev, point) {
      if ((currentHeight - prev).abs() < (currentHeight - point).abs()) {
        return prev;
      } else {
        return point;
      }
    });

    final simulation = SpringSimulation(
      _spring,
      containerHeight,
      closestSnapPoint,
      1000 * details.velocity.pixelsPerSecond.dy,
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
            left: 16.0,
            right: 16.0,
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
                Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width *
                              0.2, // 25% of the screen width
                          height: MediaQuery.of(context).size.width *
                              0.2, // Set the height equal to the width for a circular shape
                          decoration: BoxDecoration(
                            color:
                                Colors.grey[100], // Pale grey background color
                            shape: BoxShape.circle, // Circular shape
                          ),
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              iconTheme: IconThemeData(
                                color: Colors.grey[
                                    800], // Set the desired foreground color
                              ),
                            ),
                            child: Icon(
                              getIconForPlaceType(widget.types[0]),
                              size: 32.0,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.distance.isNotEmpty
                                    ? '${widget.placeName} (${widget.distance})'
                                    : widget.placeName,
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                widget.types[0].name
                                    .replaceAll('_', ' ')
                                    .capitalize!,
                                style: const TextStyle(fontSize: 12.0),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                widget.address,
                                style: const TextStyle(fontSize: 12.0),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RoundedIconButton(
                          icon: FontAwesomeIcons
                              .plus, // Replace with the appropriate Font Awesome icon
                          label: 'Event',
                          onPressed: () {
                            // Perform create event action
                            _openEventForm(context);
                          },
                        ),
                        RoundedIconButton(
                          icon: FontAwesomeIcons
                              .locationPin, // Replace with the appropriate Font Awesome icon
                          label: 'Directions',
                          onPressed: () {
                            // Perform directions action
                          },
                        ),
                        RoundedIconButton(
                          icon: FontAwesomeIcons
                              .share, // Replace with the appropriate Font Awesome icon
                          label: 'Share',
                          onPressed: () {
                            // Perform share action
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                if (events.isNotEmpty) ...[
                  const SizedBox(height: 8.0),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height - 200,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

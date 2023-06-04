import 'package:flutter/material.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'package:nomad/widgets/map/rounded_icon_button.dart';

class PlaceDetailsContainer extends StatefulWidget {
  final String placeName;
  final String address;
  final String distance;
  final List<PlaceType> types;

  const PlaceDetailsContainer({
    Key? key,
    required this.placeName,
    required this.address,
    required this.types,
    required this.distance,
  }) : super(key: key);

  @override
  PlaceDetailsContainerState createState() => PlaceDetailsContainerState();
}

class PlaceDetailsContainerState extends State<PlaceDetailsContainer> {
  double containerHeight = 200.0; // Initial height of the container
  double dragOffset = 0.0; // Offset for tracking the drag gesture

  IconData getIconForPlaceType(PlaceType placeType) {
    switch (placeType) {
      case PlaceType.UNIVERSITY:
        return FontAwesomeIcons.graduationCap;
      case PlaceType.RESTAURANT:
        return FontAwesomeIcons.utensils;
      case PlaceType.CAFE:
        return FontAwesomeIcons.coffee;
      case PlaceType.BAR:
        return FontAwesomeIcons.glassCheers;
      case PlaceType.PARK:
        return FontAwesomeIcons.tree;
      case PlaceType.SHOPPING_MALL:
        return FontAwesomeIcons.shoppingBag;
      case PlaceType.HOSPITAL:
        return FontAwesomeIcons.hospital;
      case PlaceType.MOVIE_THEATER:
        return FontAwesomeIcons.film;
      case PlaceType.MUSEUM:
        return FontAwesomeIcons.monument;
      case PlaceType.STADIUM:
        return FontAwesomeIcons.volleyballBall;
      default:
        return FontAwesomeIcons.mapMarkerAlt; // Default icon
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: GestureDetector(
        onVerticalDragUpdate: (details) {
          setState(() {
            // Update the container height based on the vertical drag gesture
            containerHeight -= details.delta.dy;
            // Ensure the container doesn't exceed certain limits
            containerHeight = containerHeight.clamp(
              100.0,
              MediaQuery.of(context).size.height,
            );
          });
        },
        child: Container(
          width: double.infinity,
          height: containerHeight,
          padding: const EdgeInsets.all(16.0),
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
            minHeight: 0.0,
            maxHeight: double.infinity,
            alignment: Alignment.topCenter,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width *
                            0.2, // 25% of the screen width
                        height: MediaQuery.of(context).size.width *
                            0.2, // Set the height equal to the width for a circular shape
                        decoration: BoxDecoration(
                          color: Colors.grey[100], // Pale grey background color
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
                        )),
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
                            widget.types[0].name.capitalize!,
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
                      },
                    ),
                    RoundedIconButton(
                      icon: FontAwesomeIcons
                          .mapMarker, // Replace with the appropriate Font Awesome icon
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
          ),
        ),
      ),
    );
  }
}

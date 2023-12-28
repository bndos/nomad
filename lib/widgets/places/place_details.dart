import 'package:flutter/material.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:nomad/utils/place_icons.dart';
import 'package:nomad/widgets/map/rounded_icon_button.dart';

class PlaceDetails extends StatelessWidget {
  final String placeName;
  final String address;
  final String distance;
  final List<PlaceType> types;
  final VoidCallback onAddEvent;
  final VoidCallback onDirections;
  final VoidCallback onShare;

  const PlaceDetails({
    Key? key,
    required this.placeName,
    required this.address,
    required this.distance,
    required this.types,
    required this.onAddEvent,
    required this.onDirections,
    required this.onShare,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
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
                    color: Colors.grey[800], // Set the desired foreground color
                  ),
                ),
                child: Icon(
                  getIconForPlaceType(types[0]),
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
                    distance.isNotEmpty ? '$placeName ($distance)' : placeName,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    types[0].name.replaceAll('_', ' ').capitalize!,
                    style: const TextStyle(fontSize: 12.0),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    address,
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
              icon: FontAwesomeIcons.plus,
              label: 'Event',
              onPressed: onAddEvent,
              containerColor: Colors.grey[100],
              height: 38,
            ),
            RoundedIconButton(
              icon: FontAwesomeIcons.locationPin,
              label: 'Directions',
              onPressed: onDirections,
              containerColor: Colors.grey[100],
              height: 38,
            ),
            RoundedIconButton(
              icon: FontAwesomeIcons.share,
              label: 'Share',
              onPressed: onShare,
              containerColor: Colors.grey[100],
              height: 38,
            ),
          ],
        ),
        const SizedBox(height: 8.0),
      ],
    );
  }
}

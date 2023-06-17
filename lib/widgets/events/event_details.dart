import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nomad/models/event/event.dart';
import 'package:nomad/widgets/map/rounded_icon_button.dart';

class EventDetails extends StatelessWidget {
  final Event event;
  final bool isParticipating;
  final Function() onParticipatePressed;

  const EventDetails({
    Key? key,
    required this.event,
    required this.isParticipating,
    required this.onParticipatePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Container with image
        Container(
          height: 300,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(event.imageUrls[0]),
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
              if (event.startTime != null) const SizedBox(height: 8),
              if (event.startTime != null)
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
                      ).format(event.startTime!).toUpperCase(),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                    if (event.endTime != null)
                      Text(
                        " - ${DateFormat('MMM d AT h:mm a', 'en_US').format(event.endTime!)}"
                            .toUpperCase(),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              if (event.placeName != null) const SizedBox(height: 8),
              if (event.placeName != null)
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
                      event.placeName ?? '',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              if (event.details != null && event.details!.isNotEmpty)
                const SizedBox(height: 16),
              if (event.details != null && event.details!.isNotEmpty)
                Text(
                  event.details!,
                  style: const TextStyle(fontSize: 14),
                ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RoundedIconButton(
                    icon: CupertinoIcons.person_badge_plus_fill,
                    color: isParticipating
                        ? Colors.grey.shade100
                        : Colors.blue.shade200,
                    label: isParticipating ? 'Participating' : 'Participate',
                    onPressed: onParticipatePressed,
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
    );
  }
}

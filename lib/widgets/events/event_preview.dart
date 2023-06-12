import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:nomad/models/event/event.dart';
import 'package:nomad/screens/event_page.dart';

class EventPreview extends StatelessWidget {
  final Event event;

  const EventPreview({
    Key? key,
    required this.event,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventPage(event: event),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 0.0,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0, 0),
                blurRadius: 8.0,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16.0)),
                child: CachedNetworkImage(
                  imageUrl: event.imageUrls[0],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 1 / 5,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    if (event.startTime != null) const SizedBox(height: 16),
                    if (event.startTime != null)
                      Row(
                        children: [
                          const Icon(
                            Iconsax.calendar_1,
                            size: 16,
                            color: Colors.black,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            DateFormat('MMMM d, yyyy, hh:mm a')
                                .format(event.startTime!),
                            style: const TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    if (event.placeName != null) const SizedBox(height: 16),
                    if (event.placeName != null)
                      Row(
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
                    // if (event.address != null) Text(event.address!),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

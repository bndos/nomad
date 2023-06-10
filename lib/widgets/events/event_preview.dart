import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nomad/models/event/event.dart';

class EventPreview extends StatelessWidget {
  final Event event;

  const EventPreview({
    Key? key,
    required this.event,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedNetworkImage(
            imageUrl: event.imageUrls[0],
            fit: BoxFit.cover,
            width: double.infinity,
            height: 200,
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
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                Text(event.details),
                const SizedBox(height: 8),
                Text(
                  'Start Time: ${event.startTime.toString()}',
                ),
                Text(
                  'End Time: ${event.endTime.toString()}',
                ),
                if (event.placeName != null) Text(event.placeName!),
                if (event.address != null) Text(event.address!),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

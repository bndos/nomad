import 'package:flutter/material.dart';
import 'package:nomad/models/event/event.dart';
import 'package:nomad/widgets/events/event_preview.dart';

class EventsListView extends StatelessWidget {
  final List<Event> events;
  final String emptyListText;

  const EventsListView({
    Key? key,
    required this.events,
    required this.emptyListText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return events.isNotEmpty
        ? ConstrainedBox(
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
          )
        : Center(
            child: Text(
              emptyListText,
            ),
          );
  }
}

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:nomad/models/event/event.dart';

class EventPage extends StatefulWidget {
  final Event event;

  const EventPage({
    Key? key,
    required this.event,
  }) : super(key: key);

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  late Event _event;

  @override
  void initState() {
    super.initState();
    _event = widget.event;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                // container with image
                Container(
                  height: 250,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(_event.imageUrls[0]),
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
                // container with event details and shadow
                Container(
                  margin: const EdgeInsets.only(top: 240),
                  width: MediaQuery.of(context).size.width,
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height * 0.7,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.6),
                        blurRadius: 100,
                        spreadRadius: 2,
                        offset: const Offset(0, -20),
                      ),
                    ],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // event name
                        Text(
                          _event.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (_event.startTime != null) const SizedBox(height: 8),
                        if (_event.startTime != null)
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
                                DateFormat('MMM d AT h:mm a', 'en_US')
                                    .format(_event.startTime!)
                                    .toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                ),
                              ),
                              if (_event.endTime != null)
                                Text(
                                  " - ${DateFormat('MMM d AT h:mm a', 'en_US').format(_event.endTime!)}"
                                      .toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                  ),
                                ),
                            ],
                          ),

                        if (_event.placeName != null) const SizedBox(height: 8),
                        if (_event.placeName != null)
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
                                _event.placeName ?? '',
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        if (_event.details != null &&
                            _event.details!.isNotEmpty)
                          const SizedBox(height: 16),
                        if (_event.details != null &&
                            _event.details!.isNotEmpty)
                          Text(
                            _event.details!,
                            style: const TextStyle(fontSize: 14),
                          ),
                        // Add the rest of the event variables here
                        // Example: if (_event.placeName != null) Text(_event.placeName!),
                        // Example: if (_event.address != null) Text(_event.address!),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle the interaction or modification of the event details
          // Here you can update the state of `_event` or perform any desired action
          setState(() {
            // Example of modifying the event name
            _event.name = 'Updated Event Name';
          });
        },
        child: const Icon(Icons.edit),
      ),
    );
  }
}

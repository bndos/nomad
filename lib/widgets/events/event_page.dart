import 'package:flutter/material.dart';

class EventCard extends StatefulWidget {
  final String? placeName;
  final String? address;
  final String? location;
  final DateTime? startTime;
  final DateTime? endTime;
  final String name;
  final String details;
  final List<String> imageUrls;

  const EventCard({
    Key? key,
    this.placeName,
    this.address,
    this.location,
    this.startTime,
    this.endTime,
    required this.name,
    required this.details,
    required this.imageUrls,
  }) : super(key: key);

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  late String _placeName;
  late String _address;
  late String _location;
  late String _startTime;
  late String _endTime;

  @override
  void initState() {
    super.initState();
    _placeName = widget.placeName ?? '';
    _address = widget.address ?? '';
    _location = widget.location ?? '';
    _startTime = widget.startTime?.toString() ?? '';
    _endTime = widget.endTime?.toString() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 24,
                  // Add your image/avatar here
                  backgroundImage: AssetImage('assets/avatar.png'),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _placeName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(_address),
                    Text(_location),
                  ],
                ),
              ],
            ),
          ),
          Image.network(
            widget.imageUrls[0],
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
                  widget.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                Text(widget.details),
                const SizedBox(height: 8),
                Text(
                  'Start Time: $_startTime',
                ),
                Text(
                  'End Time: $_endTime',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class PlaceDetailsBottomSheet extends StatelessWidget {
  final String placeName;
  final String address;

  const PlaceDetailsBottomSheet({
    Key? key,
    required this.placeName,
    required this.address,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            placeName,
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            address,
            style: const TextStyle(fontSize: 16.0),
          ),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Perform action 1
                },
                child: const Text('Action 1'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Perform action 2
                },
                child: const Text('Action 2'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

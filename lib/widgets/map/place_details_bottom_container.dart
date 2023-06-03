import 'package:flutter/material.dart';

class PlaceDetailsContainer extends StatefulWidget {
  final String placeName;
  final String address;

  const PlaceDetailsContainer({
    Key? key,
    required this.placeName,
    required this.address,
  }) : super(key: key);

  @override
  PlaceDetailsContainerState createState() => PlaceDetailsContainerState();
}

class PlaceDetailsContainerState extends State<PlaceDetailsContainer> {
  double containerHeight = 200.0; // Initial height of the container
  double dragOffset = 0.0; // Offset for tracking the drag gesture

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
                Text(
                  widget.placeName,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  widget.address,
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
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class CurrentLocationButton extends StatelessWidget {
  final void Function() getCurrentLocation;

  const CurrentLocationButton({
    Key? key,
    required this.getCurrentLocation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 30,
      right: 20,
      child: Container(
        width: 50,
        height: 50,
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: IconButton(
          icon: const Icon(
            Icons.my_location,
            color: Colors.blue,
          ),
          onPressed: getCurrentLocation,
        ),
      ),
    );
  }
}

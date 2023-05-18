import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, handle accordingly
      throw LocationException('Location services are not enabled.');
    }

    // Request location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      // Permission is denied forever, handle accordingly
      throw LocationException('Location permission is denied forever.');
    }

    if (permission == LocationPermission.denied) {
      // Permission is denied, request permission
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        // Permission is still denied, handle accordingly
        throw LocationException('Location permission is denied.');
      }
    }

    // Get the current position
    Position position = await Geolocator.getCurrentPosition();
    return position;
  }
}

class LocationException implements Exception {
  final String message;

  LocationException(this.message);
}

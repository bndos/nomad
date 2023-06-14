import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  bool permissionGranted = false;
  Position? position;

  Future<bool> checkPermission() async {
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

    permissionGranted = true;
    return permissionGranted;
  }

  Future<Position> getCurrentLocation() async {
    // Get the current position
    if (!permissionGranted) {
      checkPermission();
    }

    position = await Geolocator.getCurrentPosition();
    return position!;
  }

  String getDistanceBetween(LatLng position1, Position position2) {
    double distanceInMeters = Geolocator.distanceBetween(
      position1.lat,
      position1.lng,
      position2.latitude,
      position2.longitude,
    );

    if (distanceInMeters < 1000) {
      return '${distanceInMeters.toStringAsFixed(0)} m';
    } else {
      return '${(distanceInMeters / 1000).toStringAsFixed(1)} km';
    }
  }

  Future<String> getDistanceFromMe(LatLng position) async {
    final currentLocation = await getCurrentLocation();
    return getDistanceBetween(position, currentLocation);
  }
}

class LocationException implements Exception {
  final String message;

  LocationException(this.message);
}

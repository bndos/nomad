import 'package:photo_manager/photo_manager.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart'
    as places_sdk;

class Event {
  String? placeName;
  String? address;
  String? placeId;
  places_sdk.LatLng? location;
  DateTime? startTime;
  DateTime? endTime;
  String? details;
  String name;
  List<String> imageUrls;
  List<AssetEntity>? assets;

  Event({
    this.placeName,
    this.placeId,
    this.address,
    this.location,
    this.startTime,
    this.endTime,
    required this.name,
    required this.details,
    required this.imageUrls,
    this.assets,
  });

  Map<String, dynamic> toJson() {
    return {
      'placeName': placeName,
      'address': address,
      'placeId': placeId,
      'location': location != null
          ? {'lat': location!.lat, 'lng': location!.lng}
          : null,
      'startTime': startTime?.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'details': details,
      'name': name,
      'imageUrls': imageUrls,
    };
  }
}

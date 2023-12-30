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
  String? iconUrl;

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
    this.iconUrl,
  });

  factory Event.fromFirestore(Map<String, dynamic> data) {
    return Event(
      placeName: data['placeName'],
      address: data['address'],
      placeId: data['placeId'],
      location: data['location'] != null
          ? places_sdk.LatLng(
              lat: data['location']['lat'],
              lng: data['location']['lng'],
            )
          : null,
      startTime:
          data['startTime'] != null ? DateTime.parse(data['startTime']) : null,
      endTime: data['endTime'] != null ? DateTime.parse(data['endTime']) : null,
      details: data['details'],
      name: data['name'],
      imageUrls: List<String>.from(data['imageUrls'] ?? []),
      iconUrl: data['iconUrl'],
      // assets field is omitted as it's not directly supported in Firestore
    );
  }

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
      'iconUrl': iconUrl,
    };
  }
}

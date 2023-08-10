import 'package:photo_manager/photo_manager.dart';

class Event {
  String? placeName;
  String? address;
  String? location;
  DateTime? startTime;
  DateTime? endTime;
  String? details;
  String name;
  List<String> imageUrls;
  List<AssetEntity>? assets;

  Event({
    this.placeName,
    this.address,
    this.location,
    this.startTime,
    this.endTime,
    required this.name,
    required this.details,
    required this.imageUrls,
    this.assets,
  });
}

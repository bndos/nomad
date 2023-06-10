class Event {
  String? placeName;
  String? address;
  String? location;
  DateTime? startTime;
  DateTime? endTime;
  String name;
  String details;
  List<String> imageUrls;

  Event({
    this.placeName,
    this.address,
    this.location,
    this.startTime,
    this.endTime,
    required this.name,
    required this.details,
    required this.imageUrls,
  });
}

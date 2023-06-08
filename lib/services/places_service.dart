import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';

class PlacesService {
  static FlutterGooglePlacesSdk? places;

  static Future<void> initialize() async {
    String apiKey = dotenv.env['GOOGLE_PLACES_API_KEY']!;
    places = FlutterGooglePlacesSdk(apiKey);
  }
}

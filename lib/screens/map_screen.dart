import 'package:flutter/material.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart'
    as places_sdk;
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../services/places_service.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<places_sdk.AutocompletePrediction> _predictions = [];
  List<places_sdk.FetchPlaceResponse?> _placeDetails = [];

  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    String input = _searchController.text;
    if (input.isNotEmpty) {
      _fetchAutocompletePredictions(input);
    } else {
      setState(() {
        _predictions = [];
      });
    }
  }

  void getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, display an error message or show a dialog
      return;
    }

    // Request location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      // Permission is denied forever, handle appropriately
      return;
    }

    if (permission == LocationPermission.denied) {
      // Permission is denied, request permission
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        // Permission is still denied, handle appropriately
        return;
      }
    }

    // Get the current position
    Position position = await Geolocator.getCurrentPosition();
    LatLng currentPosition = LatLng(position.latitude, position.longitude);

    // Use the current location as needed
    _mapController!.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: currentPosition,
        zoom: 18,
      ),
    ));
  }

  void _fetchAutocompletePredictions(String input) async {
    final places_sdk.FindAutocompletePredictionsResponse predictions =
        await PlacesService.places!.findAutocompletePredictions(input);

    if (_placeDetails.length < predictions.predictions.length) {
      _placeDetails = List<places_sdk.FetchPlaceResponse?>.filled(
        predictions.predictions.length,
        null,
      );
    }

    for (int i = 0; i < predictions.predictions.length; i++) {
      final prediction = predictions.predictions[i];
      final details = await PlacesService.places!.fetchPlace(
        prediction.placeId,
        fields: [
          places_sdk.PlaceField.Types,
          places_sdk.PlaceField.Name,
          places_sdk.PlaceField.Location,
        ],
      );
      _placeDetails[i] = details;
    }

    setState(() {
      _predictions = predictions.predictions;
    });
  }

  void _clearPredictions() {
    setState(() {
      _searchController.text = '';
      FocusScope.of(context).unfocus();
      _predictions = [];
    });
  }

  void _handlePredictionSelection(places_sdk.AutocompletePrediction prediction,
      places_sdk.LatLng? location) {
    if (location != null) {
      final latLng = LatLng(location.lat, location.lng);
      if (_mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(latLng, 14.0),
        );
      }
    }

    setState(() {
      _clearPredictions();
    });
  }

  @override
  Widget build(BuildContext context) {
    const CameraPosition kGooglePlex = CameraPosition(
      target: LatLng(37.42796133580664, -122.085749655962),
      zoom: 14.4746,
    );

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            zoomControlsEnabled: false,
            mapType: MapType.terrain,
            onMapCreated: (GoogleMapController controller) {
              setState(() {
                _mapController = controller;
                getCurrentLocation();
              });
            },
            initialCameraPosition: kGooglePlex,
          ),
          buildSearchField(context),
          buildCurrentLocationButton(),
          if (_predictions.isNotEmpty) buildAutocompleteContainer(),
        ],
      ),
    );
  }

  Widget buildSearchField(BuildContext context) {
    return Positioned(
      top: 30,
      left: 20,
      right: 20,
      child: Container(
        width: Get.width,
        padding: const EdgeInsets.only(left: 5),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          children: [
            if (_predictions.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  setState(() {
                    _clearPredictions();
                  });
                },
              )
            else
              const IconButton(
                icon: Icon(Icons.search),
                onPressed: null,
              ),
            Expanded(
              child: TextFormField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _onSearchChanged();
                  });
                },
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCurrentLocationButton() {
    return Positioned(
      bottom: 80,
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
          onPressed: () {
            getCurrentLocation();
          },
        ),
      ),
    );
  }

  Widget buildAutocompleteContainer() {
    return Positioned(
      top: 80,
      left: 20,
      right: 20,
      child: Container(
        padding: const EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: ListView.builder(
          padding: EdgeInsets.zero, // Adjust the padding here
          shrinkWrap: true,
          itemCount: _predictions.length,
          itemBuilder: (context, index) {
            final type = _placeDetails[index]?.place?.types?[0];
            // final name = _placeDetails[index]?.place?.name;
            final location = _placeDetails[index]?.place?.latLng;
            final prediction = _predictions[index];
            // print("------------------");
            // print(_predictions.length);
            // print(_placeDetails.length);
            // print(name);
            // print(type);
            // print(_placeDetails[index]?.place?.types);
            // print(location);
            // print("------------------");

            IconData iconData;
            switch (type) {
              case places_sdk.PlaceType.RESTAURANT:
                iconData = Icons.restaurant;
                break;
              case places_sdk.PlaceType.CAFE:
                iconData = Icons.local_cafe;
                break;
              case places_sdk.PlaceType.LODGING:
                iconData = Icons.hotel;
                break;
              // Add more cases for other place types as needed
              default:
                iconData = Icons.place;
                break;
            }

            return ListTile(
              leading: Icon(iconData),
              title: Text(prediction.fullText),
              onTap: () {
                _handlePredictionSelection(prediction, location!);
              },
            );
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart'
    as places_sdk;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nomad/services/location_service.dart';
import 'package:nomad/services/places_service.dart';
import 'package:nomad/widgets/map/autocomplete_container.dart';
import 'package:nomad/widgets/map/current_location_button.dart';
import 'package:nomad/widgets/map/search_field.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<places_sdk.AutocompletePrediction> _predictions = [];
  List<places_sdk.FetchPlaceResponse?> _placeDetails = [];
  final LocationService _locationService = LocationService();

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
    try {
      Position position = await _locationService.getCurrentLocation();
      places_sdk.LatLng currentPosition =
          places_sdk.LatLng(lat: position.latitude, lng: position.longitude);

      _focusLocation(currentPosition);
    } catch (e) {
      // TODO Handle location error
    }
  }

  void _focusLocation(places_sdk.LatLng? location) {
    if (location != null) {
      final latLng = LatLng(location.lat, location.lng);
      if (_mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(latLng, 16.0),
        );
      }
    }

    setState(() {
      _clearPredictions();
    });
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
          SearchField(
            searchController: _searchController,
            predictions: _predictions,
            onSearchChanged: _onSearchChanged,
            clearPredictions: _clearPredictions,
          ),
          CurrentLocationButton(
            getCurrentLocation: getCurrentLocation,
          ),
          if (_predictions.isNotEmpty)
            AutocompleteContainer(
              predictions: _predictions,
              placeDetails: _placeDetails,
              handlePredictionSelection: _focusLocation,
            ),
        ],
      ),
    );
  }
}

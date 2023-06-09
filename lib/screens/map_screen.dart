import 'package:flutter/material.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart'
    as places_sdk;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nomad/services/location_service.dart';
import 'package:nomad/services/places_service.dart';
import 'package:nomad/widgets/map/current_location_button.dart';
import 'package:nomad/widgets/map/place_details_bottom_container.dart';
import 'package:nomad/widgets/map/search_field.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  final TextEditingController _searchController = TextEditingController();
  final LocationService _locationService = LocationService();

  List<Marker> _markers = [];
  GoogleMapController? _mapController;

  places_sdk.LatLng? _currentLocation;
  places_sdk.FetchPlaceResponse? _currentPlaceDetails;
  String _currentPlaceDistance = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void getCurrentLocation() async {
    try {
      Position position = await _locationService.getCurrentLocation();

      setState(() {
        _currentLocation =
            places_sdk.LatLng(lat: position.latitude, lng: position.longitude);
      });
    } catch (e) {
      // TODO Handle location error
    }
  }

  void focusCurrentLocation() {
    getCurrentLocation();
    _moveCameraToLocation(_currentLocation, addMarker: false);
  }

  void _setMarker(LatLng position, String id) {
    setState(() {
      _markers = [
        Marker(
          markerId: MarkerId(id),
          position: position,
        )
      ];
    });
  }

  void _clearMarkers() {
    setState(() {
      _markers = [];
    });
  }

  void _moveCameraToLocation(
    places_sdk.LatLng? location, {
    bool addMarker = true,
  }) {
    if (location != null) {
      final latLng = LatLng(location.lat, location.lng);
      if (_mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(latLng, 16.0),
        );
      }

      setState(() {
        if (addMarker) {
          _setMarker(latLng, 'focusedLocation');
        }
      });
    }
  }

  void _focusPredictionClicked(
    int? index,
    List<places_sdk.AutocompletePrediction> predictions,
  ) async {
    if (index != null) {
      final prediction = predictions[index];
      final details = await PlacesService.places!.fetchPlace(
        prediction.placeId,
        fields: [
          places_sdk.PlaceField.Types,
          places_sdk.PlaceField.Name,
          places_sdk.PlaceField.Address,
          places_sdk.PlaceField.Location,
        ],
      );

      final location = details.place!.latLng;
      final distanceMeters = prediction.distanceMeters;
      String distance = '';

      if (distanceMeters != null) {
        if (distanceMeters >= 1000) {
          distance = '${(distanceMeters / 1000).toStringAsFixed(1)} km';
        } else {
          distance = '${distanceMeters.toStringAsFixed(0)} m';
        }
      } else {
        distance = await _locationService.getDistanceFromMe(location!);
      }

      _moveCameraToLocation(location);

      setState(() {
        _currentPlaceDetails = details;
        _currentPlaceDistance = distance;
      });
    }
  }

  bool _isTouchAroundMarker(LatLng position) {
    if (_markers.isNotEmpty) {
      final markerPosition = _markers.first.position;
      final distance = Geolocator.distanceBetween(
        markerPosition.latitude,
        markerPosition.longitude,
        position.latitude,
        position.longitude,
      );
      return distance < 100;
    }
    return false;
  }

  void _handleMapTap(LatLng latLng) {
    if (_isTouchAroundMarker(latLng)) {
      _moveCameraToLocation(
        places_sdk.LatLng(lat: latLng.latitude, lng: latLng.longitude),
      );
    } else {
      _clearMarkers();
    }
  }

  void _handleMapLongPress(LatLng latLng) {
    if (_isTouchAroundMarker(latLng)) {
      _clearMarkers();
    } else {
      _moveCameraToLocation(
        places_sdk.LatLng(lat: latLng.latitude, lng: latLng.longitude),
      );
    }
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
            markers: Set<Marker>.of(_markers),
            onMapCreated: (GoogleMapController controller) {
              setState(() {
                _mapController = controller;
                focusCurrentLocation();
              });
            },
            onLongPress: _handleMapLongPress,
            onTap: _handleMapTap,
            myLocationButtonEnabled: false,
            initialCameraPosition: kGooglePlex,
          ),
          CurrentLocationButton(
            getCurrentLocation: focusCurrentLocation,
          ),
          if (_currentPlaceDetails != null)
            PlaceDetailsContainer(
              placeName: _currentPlaceDetails!.place!.name!,
              address: _currentPlaceDetails!.place!.address!,
              types: _currentPlaceDetails!.place!.types!,
              distance: _currentPlaceDistance,
            ),
          SafeArea(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: SearchField(
                currentLocation: _currentLocation,
                mapController: _mapController,
                handlePredictionSelection: _focusPredictionClicked,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

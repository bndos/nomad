import 'package:flutter/material.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart'
    as places_sdk;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nomad/models/event/event.dart';
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

  List<Marker> _currentMarker = [];
  final List<Marker> _eventMarkers = [];
  GoogleMapController? _mapController;

  places_sdk.LatLng? _currentLocation;
  places_sdk.FetchPlaceResponse? _currentPlaceDetails;
  String _currentPlaceId = '';
  final List<Image> _placeImages = [];
  String _currentPlaceDistance = '';
  // events maps a map location to multiple events
  final Map<places_sdk.LatLng, List<Event>> _eventMap = {};

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleHidePlaceDetails() {
    setState(() {
      _currentPlaceDetails = null;
      _currentPlaceDistance = '';
    });
  }

  void getCurrentLocation(bool shouldMoveCamera) async {
    try {
      Position position = await _locationService.getCurrentLocation();

      setState(() {
        _currentLocation =
            places_sdk.LatLng(lat: position.latitude, lng: position.longitude);
        if (shouldMoveCamera) {
          _moveCameraToLocation(_currentLocation);
        }
      });
    } catch (e) {
      // TODO Handle location error
    }
  }

  void focusCurrentLocation() {
    getCurrentLocation(true);
  }

  void _setMarker(LatLng position, String id) {
    setState(() {
      _currentMarker = [
        Marker(
          markerId: MarkerId(id),
          position: position,
        ),
      ];
    });
  }

  void _clearCurrentMarker() {
    setState(() {
      _currentMarker = [];
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
      _focusPlace(
        prediction.placeId,
        distanceMeters: prediction.distanceMeters,
      );
    }
  }

  void _focusPlace(String placeId, {int? distanceMeters}) async {
    final details = await PlacesService.places!.fetchPlace(
      placeId,
      fields: [
        places_sdk.PlaceField.Types,
        places_sdk.PlaceField.Name,
        places_sdk.PlaceField.Address,
        places_sdk.PlaceField.Location,
        places_sdk.PlaceField.PhotoMetadatas,
      ],
    );

    final location = details.place!.latLng;
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

    setState(() {
      _placeImages.clear();
    });

    if (details.place!.photoMetadatas != null) {
      for (final photoMetadata in details.place!.photoMetadatas!) {
        PlacesService.places!
            .fetchPlacePhoto(
          photoMetadata,
        )
            .then((photo) {
          setState(() {
            if (photo.image != null) {
              _placeImages.add(photo.image!);
            }
          });
        });
      }
    }

    _moveCameraToLocation(location);

    setState(() {
      _currentPlaceDetails = details;
      _currentPlaceId = placeId;
      _currentPlaceDistance = distance;
    });
  }

  bool _isTouchAroundMarker(LatLng position) {
    if (_currentMarker.isNotEmpty) {
      final markerPosition = _currentMarker.first.position;
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
      _clearCurrentMarker();
    }
  }

  void _handleEventCreated(Event event) {
    // event id generated in firestore
    if (event.location == null) {
      return;
    }

    if (_eventMap.containsKey(event.location!)) {
      _eventMap[event.location!]!.add(event);
    } else {
      _eventMap[event.location!] = [event];
    }

    setState(() {
      _eventMarkers.add(
        Marker(
          markerId: MarkerId(event.location!.toString()),
          position: LatLng(event.location!.lat, event.location!.lng),
          onTap: () {
            _focusPlace(event.placeId!);
          },
        ),
      );
    });
  }

  void _handleMapLongPress(LatLng latLng) {
    if (_isTouchAroundMarker(latLng)) {
      _clearCurrentMarker();
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

    return Stack(
      children: [
        GoogleMap(
          zoomControlsEnabled: false,
          mapType: MapType.terrain,
          markers: Set<Marker>.of({..._currentMarker, ..._eventMarkers}),
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
        if (_currentPlaceDetails != null)
          PlaceDetailsContainer(
            placeId: _currentPlaceId,
            placeName: _currentPlaceDetails!.place!.name!,
            address: _currentPlaceDetails!.place!.address!,
            events: [..._eventMap[_currentPlaceDetails!.place!.latLng!] ?? []],
            types: _currentPlaceDetails!.place!.types!,
            location: _currentPlaceDetails!.place!.latLng!,
            placeImages: _placeImages,
            distance: _currentPlaceDistance,
            onHideContainer: _handleHidePlaceDetails,
            onEventCreated: _handleEventCreated,
          ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart'
    as places_sdk;

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nomad/services/places_service.dart';

import 'package:nomad/widgets/search/search_field_ui.dart';

class SearchField extends StatefulWidget {
  final GoogleMapController? mapController;
  final void Function(
    int? index,
    List<places_sdk.AutocompletePrediction> predictions,
  ) handlePredictionSelection;
  final void Function()? clearSearch;
  final places_sdk.LatLng? currentLocation;
  final bool shouldAutofocus;

  const SearchField({
    Key? key,
    required this.currentLocation,
    required this.handlePredictionSelection,
    this.mapController,
    this.clearSearch,
    this.shouldAutofocus = false,
  }) : super(key: key);

  @override
  SearchFieldState createState() => SearchFieldState();
}

class SearchFieldState extends State<SearchField> {
  final TextEditingController _searchController = TextEditingController();
  List<places_sdk.AutocompletePrediction> _predictions = [];
  List<String> _predictionStrings = [];

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
        _predictionStrings = [];
      });
    }
  }

  void _clearPredictions() {
    setState(() {
      _searchController.text = '';
      FocusScope.of(context).unfocus();
      _predictions = [];
      _predictionStrings = [];
      widget.clearSearch?.call();
    });
  }

  void _fetchAutocompletePredictions(String input) async {
    places_sdk.LatLngBounds locationBias;
    if (widget.mapController != null) {
      final LatLng mapCenter = await widget.mapController!.getLatLng(
        ScreenCoordinate(
          x: MediaQuery.of(context).size.width ~/ 2,
          y: MediaQuery.of(context).size.height ~/ 2,
        ),
      );

      locationBias = places_sdk.LatLngBounds(
        southwest: places_sdk.LatLng(
          lat: mapCenter.latitude - 0.1,
          lng: mapCenter.longitude - 0.1,
        ),
        northeast: places_sdk.LatLng(
          lat: mapCenter.latitude + 0.1,
          lng: mapCenter.longitude + 0.1,
        ),
      );
    } else {
      locationBias = places_sdk.LatLngBounds(
        southwest: places_sdk.LatLng(
          lat: widget.currentLocation!.lat - 0.1,
          lng: widget.currentLocation!.lng - 0.1,
        ),
        northeast: places_sdk.LatLng(
          lat: widget.currentLocation!.lat + 0.1,
          lng: widget.currentLocation!.lng + 0.1,
        ),
      );
    }

    final places_sdk.FindAutocompletePredictionsResponse predictionsResponse =
        await PlacesService.places!.findAutocompletePredictions(
      input,
      locationBias: locationBias,
      origin: widget.currentLocation,
    );

    setState(() {
      _predictions = predictionsResponse.predictions;
      _predictionStrings = _predictions
          .map((prediction) => _getPredictionString(prediction))
          .toList();
    });
  }

  void _handlePredictionSelection(int? index) {
    widget.handlePredictionSelection(index, _predictions);
    _clearPredictions();
  }

  String _getPredictionString(places_sdk.AutocompletePrediction prediction) {
    final distanceMeters = prediction.distanceMeters;
    String distance = '';

    if (distanceMeters != null) {
      if (distanceMeters >= 1000) {
        distance = '${(distanceMeters / 1000).toStringAsFixed(1)} km';
      } else {
        distance = '${distanceMeters.toStringAsFixed(0)} m';
      }
    }

    return distance.isNotEmpty
        ? '($distance) ${prediction.fullText}'
        : prediction.fullText;
  }

  @override
  Widget build(BuildContext context) {
    return SearchFieldUI(
      searchController: _searchController,
      onSearchChanged: _onSearchChanged,
      predictionStrings: _predictionStrings,
      handlePredictionSelection: _handlePredictionSelection,
      clearPredictions: _clearPredictions,
    );
  }
}

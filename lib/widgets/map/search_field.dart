import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart'
    as places_sdk;

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nomad/services/places_service.dart';

import 'package:nomad/widgets/map/autocomplete_container.dart';

class SearchField extends StatefulWidget {
  final GoogleMapController? mapController;
  final void Function(
    int? index,
    List<places_sdk.AutocompletePrediction> predictions,
  ) handlePredictionSelection;
  final places_sdk.LatLng? currentLocation;

  const SearchField({
    Key? key,
    required this.currentLocation,
    required this.mapController,
    required this.handlePredictionSelection,
  }) : super(key: key);

  @override
  SearchFieldState createState() => SearchFieldState();
}

class SearchFieldState extends State<SearchField> {
  final TextEditingController _searchController = TextEditingController();
  List<places_sdk.AutocompletePrediction> _predictions = [];

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

  void _clearPredictions() {
    setState(() {
      _searchController.text = '';
      FocusScope.of(context).unfocus();
      _predictions = [];
    });
  }

  void _fetchAutocompletePredictions(String input) async {
    final LatLng mapCenter = await widget.mapController!.getLatLng(
      ScreenCoordinate(
        x: MediaQuery.of(context).size.width ~/ 2,
        y: MediaQuery.of(context).size.height ~/ 2,
      ),
    );

    final locationBias = places_sdk.LatLngBounds(
      southwest: places_sdk.LatLng(
        lat: mapCenter.latitude - 0.1,
        lng: mapCenter.longitude - 0.1,
      ),
      northeast: places_sdk.LatLng(
        lat: mapCenter.latitude + 0.1,
        lng: mapCenter.longitude + 0.1,
      ),
    );

    final places_sdk.FindAutocompletePredictionsResponse predictionsResponse =
        await PlacesService.places!.findAutocompletePredictions(
      input,
      locationBias: locationBias,
      origin: widget.currentLocation,
    );

    setState(() {
      _predictions = predictionsResponse.predictions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: Get.width,
            margin: const EdgeInsets.only(top: 20, bottom: 0),
            padding: const EdgeInsets.only(left: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20),
                topRight: const Radius.circular(20),
                bottomLeft: _predictions.isEmpty
                    ? const Radius.circular(20)
                    : const Radius.circular(0),
                bottomRight: _predictions.isEmpty
                    ? const Radius.circular(20)
                    : const Radius.circular(0),
              ),
            ),
            child: Row(
              children: [
                if (_predictions.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: _clearPredictions,
                  )
                else
                  const IconButton(
                    icon: Icon(Icons.search),
                    onPressed: null,
                  ),
                Expanded(
                  child: TextFormField(
                    controller: _searchController,
                    onChanged: (value) => _onSearchChanged(),
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
          if (_predictions.isNotEmpty)
            AutocompleteContainer(
              predictions: _predictions,
              handlePredictionSelection: widget.handlePredictionSelection,
              clearPredictions: _clearPredictions,
            ),
        ],
      ),
    );
  }
}

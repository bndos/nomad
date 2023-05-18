import 'package:flutter/material.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';

class AutocompleteContainer extends StatelessWidget {
  final List<AutocompletePrediction> predictions;
  final List<FetchPlaceResponse?> placeDetails;
  final void Function(AutocompletePrediction, LatLng) handlePredictionSelection;

  const AutocompleteContainer({
    Key? key,
    required this.predictions,
    required this.placeDetails,
    required this.handlePredictionSelection,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: predictions.length,
          itemBuilder: (context, index) {
            final type = placeDetails[index]?.place?.types?[0];
            final location = placeDetails[index]?.place?.latLng;
            final prediction = predictions[index];

            IconData iconData;
            switch (type) {
              case PlaceType.RESTAURANT:
                iconData = Icons.restaurant;
                break;
              case PlaceType.CAFE:
                iconData = Icons.local_cafe;
                break;
              case PlaceType.LODGING:
                iconData = Icons.hotel;
                break;
              default:
                iconData = Icons.place;
                break;
            }

            return ListTile(
              leading: Icon(iconData),
              title: Text(prediction.fullText),
              onTap: () => handlePredictionSelection(prediction, location!),
            );
          },
        ),
      ),
    );
  }
}

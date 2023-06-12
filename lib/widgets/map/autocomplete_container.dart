import 'package:flutter/material.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';

class AutocompleteContainer extends StatelessWidget {
  final List<AutocompletePrediction> predictions;
  final void Function(int? index, List<AutocompletePrediction> predictions)
      handlePredictionSelection;
  final void Function() clearPredictions;

  const AutocompleteContainer({
    Key? key,
    required this.predictions,
    required this.handlePredictionSelection,
    required this.clearPredictions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 5),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 30),
          ),
        ],
      ),
      child: ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        itemCount: predictions.length,
        itemBuilder: (context, index) {
          final prediction = predictions[index];
          final distanceMeters = prediction.distanceMeters;
          String distance = '';

          if (distanceMeters != null) {
            if (distanceMeters >= 1000) {
              distance = '${(distanceMeters / 1000).toStringAsFixed(1)} km';
            } else {
              distance = '${distanceMeters.toStringAsFixed(0)} m';
            }
          }

          return ListTile(
            title: Text(
              distance.isNotEmpty
                  ? '($distance) ${prediction.fullText}'
                  : prediction.fullText,
            ),
            onTap: () => {
              clearPredictions(),
              handlePredictionSelection(index, predictions)
            },
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';

class AutocompleteContainer extends StatelessWidget {
  final List<AutocompletePrediction> predictions;
  final void Function(int? index) handlePredictionSelection;

  const AutocompleteContainer({
    Key? key,
    required this.predictions,
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
              onTap: () => handlePredictionSelection(index),
            );
          },
        ),
      ),
    );
  }
}

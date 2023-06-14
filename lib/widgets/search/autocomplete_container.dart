import 'package:flutter/material.dart';

class AutocompleteContainer extends StatelessWidget {
  final List<String> predictionStrings;
  final void Function(int? index) handlePredictionSelection;

  const AutocompleteContainer({
    Key? key,
    required this.predictionStrings,
    required this.handlePredictionSelection,
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
        itemCount: predictionStrings.length,
        itemBuilder: (context, index) {
          final predictionString = predictionStrings[index];

          return ListTile(
            title: Text(
              predictionString,
              style: const TextStyle(fontSize: 13),
            ),
            onTap: () => {handlePredictionSelection(index)},
          );
        },
      ),
    );
  }
}

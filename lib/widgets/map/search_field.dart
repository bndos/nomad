import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';

class SearchField extends StatelessWidget {
  final TextEditingController searchController;
  final List<AutocompletePrediction> predictions;
  final void Function() onSearchChanged;
  final void Function() clearPredictions;

  const SearchField({
    Key? key,
    required this.searchController,
    required this.predictions,
    required this.onSearchChanged,
    required this.clearPredictions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      margin: const EdgeInsets.only(top: 6),
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
          if (predictions.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: clearPredictions,
            )
          else
            const IconButton(
              icon: Icon(Icons.search),
              onPressed: null,
            ),
          Expanded(
            child: TextFormField(
              controller: searchController,
              onChanged: (value) => onSearchChanged(),
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
    );
  }
}

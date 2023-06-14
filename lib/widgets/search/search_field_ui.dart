import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:nomad/widgets/search/autocomplete_container.dart';

class SearchFieldUI extends StatelessWidget {
  final List<String> predictionStrings;
  final TextEditingController? searchController;
  final void Function(int? index)? handlePredictionSelection;
  final void Function()? clearPredictions;
  final void Function()? onSearchChanged;

  const SearchFieldUI({
    Key? key,
    required this.predictionStrings,
    this.clearPredictions,
    this.handlePredictionSelection,
    this.searchController,
    this.onSearchChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: Get.width,
            height: 35,
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
                bottomLeft: predictionStrings.isNotEmpty
                    ? const Radius.circular(0)
                    : const Radius.circular(20),
                bottomRight: predictionStrings.isNotEmpty
                    ? const Radius.circular(0)
                    : const Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                if (predictionStrings.isNotEmpty)
                  IconButton(
                    icon: const Icon(
                      Icons.clear,
                      size: 20,
                    ),
                    onPressed: clearPredictions,
                  )
                else
                  const IconButton(
                    icon: Icon(
                      Icons.search,
                      size: 20,
                    ),
                    onPressed: null,
                  ),
                Expanded(
                  child: TextFormField(
                    controller: searchController,
                    autofocus: true,
                    onChanged: (_) => onSearchChanged?.call(),
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 13,
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
          if (predictionStrings.isNotEmpty && handlePredictionSelection != null)
            AutocompleteContainer(
              predictionStrings: predictionStrings,
              handlePredictionSelection: handlePredictionSelection!,
            ),
        ],
      ),
    );
  }
}

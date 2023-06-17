import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:nomad/widgets/search/autocomplete_container.dart';

class SearchFieldUI extends StatefulWidget {
  final List<String> predictionStrings;
  final TextEditingController? searchController;
  final void Function(int? index)? handlePredictionSelection;
  final void Function()? clearPredictions;
  final void Function()? onSearchChanged;
  final bool shouldAutofocus;

  const SearchFieldUI({
    Key? key,
    required this.predictionStrings,
    this.clearPredictions,
    this.handlePredictionSelection,
    this.searchController,
    this.onSearchChanged,
    this.shouldAutofocus = false,
  }) : super(key: key);

  @override
  State<SearchFieldUI> createState() => _SearchFieldUIState();
}

class _SearchFieldUIState extends State<SearchFieldUI> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

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
                bottomLeft: widget.predictionStrings.isNotEmpty
                    ? const Radius.circular(0)
                    : const Radius.circular(20),
                bottomRight: widget.predictionStrings.isNotEmpty
                    ? const Radius.circular(0)
                    : const Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                if (widget.predictionStrings.isNotEmpty || _focusNode.hasFocus)
                  IconButton(
                    icon: const Icon(
                      Icons.clear,
                      size: 20,
                    ),
                    onPressed: widget.clearPredictions,
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
                    controller: widget.searchController,
                    focusNode: _focusNode,
                    autofocus: widget.shouldAutofocus,
                    onChanged: (_) => widget.onSearchChanged?.call(),
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
          if (widget.predictionStrings.isNotEmpty &&
              widget.handlePredictionSelection != null)
            AutocompleteContainer(
              predictionStrings: widget.predictionStrings,
              handlePredictionSelection: widget.handlePredictionSelection!,
            ),
        ],
      ),
    );
  }
}

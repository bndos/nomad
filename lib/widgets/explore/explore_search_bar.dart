import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nomad/widgets/search/search_field_ui.dart';
import 'package:nomad/widgets/tabbar/custom_tab_bar.dart';

class ExploreSearchBar extends StatefulWidget {
  final double height;
  final TextEditingController? searchController;
  final void Function()? onSearchChanged;
  final List<String> predictionStrings;
  final void Function(int? index)? handlePredictionSelection;
  final void Function()? clearPredictions;
  final TabController tabController;

  const ExploreSearchBar({
    Key? key,
    required this.height,
    required this.tabController,
    required this.predictionStrings,
    this.searchController,
    this.onSearchChanged,
    this.handlePredictionSelection,
    this.clearPredictions,
  }) : super(key: key);

  @override
  State<ExploreSearchBar> createState() => _ExploreSearchBarState();
}

class _ExploreSearchBarState extends State<ExploreSearchBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.075),
            blurRadius: 40,
            offset: const Offset(0, 10),
          ),
        ],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SafeArea(
              child: SearchFieldUI(
                searchController: widget.searchController,
                onSearchChanged: widget.onSearchChanged,
                predictionStrings: widget.predictionStrings,
                handlePredictionSelection: widget.handlePredictionSelection,
                clearPredictions: widget.clearPredictions,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 42.0, vertical: 4),
            child: CustomTabBar(
              tabController: widget.tabController,
              icons: const [
                Iconsax.link,
                Iconsax.grid_1,
                Iconsax.location,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

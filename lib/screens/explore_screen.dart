import 'package:flutter/material.dart';

import 'package:nomad/widgets/search/search_field_ui.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({
    Key? key,
  }) : super(key: key);

  @override
  ExploreScreenState createState() => ExploreScreenState();
}

class ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();
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
        _predictionStrings = [];
      });
    }
  }

  void _clearPredictions() {
    setState(() {
      _searchController.text = '';
      FocusScope.of(context).unfocus();
      _predictionStrings = [];
    });
  }

  void _fetchAutocompletePredictions(String input) async {
    _getPredictionString();
  }

  void _handlePredictionSelection(int? index) {
    _clearPredictions();
  }

  String _getPredictionString() {
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SearchFieldUI(
          searchController: _searchController,
          onSearchChanged: _onSearchChanged,
          predictionStrings: _predictionStrings,
          handlePredictionSelection: _handlePredictionSelection,
          clearPredictions: _clearPredictions,
        ),
      ),
    );
  }
}

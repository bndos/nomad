import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:nomad/models/event/event.dart';
import 'package:nomad/services/location_service.dart';
import 'package:nomad/services/places_service.dart';
import 'package:nomad/widgets/gallery/grid_gallery.dart';
import 'package:nomad/widgets/gallery/media_picker.dart';
import 'package:nomad/widgets/map/rounded_icon_button.dart';
import 'package:nomad/widgets/map/search_field.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:time_range_picker/time_range_picker.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart'
    as places_sdk;

import 'package:intl/intl.dart';

class EventForm extends StatefulWidget {
  final String? placeId;
  final String? distance;
  final String? placeName;
  final places_sdk.LatLng? location;
  final Function(Event) onEventCreated;

  const EventForm({
    Key? key,
    this.placeId,
    this.distance,
    this.placeName,
    this.location,
    required this.onEventCreated,
  }) : super(key: key);

  @override
  EventFormState createState() => EventFormState();
}

class DateWrapper {
  DateTime? date;
}

class EventFormState extends State<EventForm> {
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _eventDescriptionController =
      TextEditingController();
  final FocusNode _eventNameFocusNode = FocusNode();
  final FocusNode _eventDescriptionFocusNode = FocusNode();
  final LocationService _locationService = LocationService();

  bool _isEventNameFocused = false;
  bool _isEventDescriptionFocused = false;
  bool _isSearchingPlace = false;
  final DateWrapper _startDateWrapper = DateWrapper();
  final DateWrapper _endDateWrapper = DateWrapper();
  places_sdk.LatLng? _currentLocation;
  String _currentPlaceDistance = '';
  String _currentPlaceName = '';
  String _currentAddress = '';
  String _currentPlaceId = '';
  places_sdk.LatLng? _currentPlaceLocation;
  List<AssetEntity> assets = [];

  @override
  void initState() {
    super.initState();
    _eventNameFocusNode.addListener(_handleEventNameFocusChange);
    _eventNameFocusNode.addListener(_handleEventDescriptionFocusChange);
    if (widget.placeName != null) {
      _currentPlaceName = widget.placeName!;
    }
    if (widget.distance != null) {
      _currentPlaceDistance = widget.distance!;
    }
    if (widget.placeId != null) {
      _currentPlaceId = widget.placeId!;
    }
    if (widget.location != null) {
      _currentPlaceLocation = widget.location!;
    }
  }

  @override
  void dispose() {
    _eventNameController.dispose();
    _eventNameFocusNode.removeListener(_handleEventNameFocusChange);
    _eventNameFocusNode.dispose();

    _eventDescriptionController.dispose();
    _eventDescriptionFocusNode
        .removeListener(_handleEventDescriptionFocusChange);
    _eventDescriptionFocusNode.dispose();

    super.dispose();
  }

  void _handleEventNameFocusChange() {
    setState(() {
      _isEventNameFocused = _eventNameFocusNode.hasFocus;
    });
  }

  void _handleEventDescriptionFocusChange() {
    setState(() {
      _isEventDescriptionFocused = _eventDescriptionFocusNode.hasFocus;
    });
  }

  void _clearSearch() {
    setState(() {
      _isSearchingPlace = false;
    });
  }

  void _handlePredictionSelection(
    int? index,
    List<places_sdk.AutocompletePrediction> predictions,
  ) async {
    if (index != null) {
      final prediction = predictions[index];
      final details = await PlacesService.places!.fetchPlace(
        prediction.placeId,
        fields: [
          places_sdk.PlaceField.Types,
          places_sdk.PlaceField.Name,
          places_sdk.PlaceField.Address,
          places_sdk.PlaceField.Location,
        ],
      );

      final location = details.place!.latLng;
      final distanceMeters = prediction.distanceMeters;
      String distance = '';

      if (distanceMeters != null) {
        if (distanceMeters >= 1000) {
          distance = '${(distanceMeters / 1000).toStringAsFixed(1)} km';
        } else {
          distance = '${distanceMeters.toStringAsFixed(0)} m';
        }
      } else {
        distance = await _locationService.getDistanceFromMe(location!);
      }

      setState(() {
        _currentPlaceDistance = distance;
        _currentPlaceId = prediction.placeId;
        _currentPlaceName = details.place!.name!;
        _currentAddress = details.place!.address!;
        _currentPlaceLocation = location;
      });
    }
  }

  Future<void> _selectDate(
    BuildContext context,
    DateWrapper selectedDate, {
    DateTime? initialDate,
  }) async {
    setState(() {
      selectedDate.date = null;
      _endDateWrapper.date = null;
    });

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: initialDate ?? DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate.date = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
        );
      });

      if (!mounted) return;

      final TimeOfDay? pickedTime;

      if (initialDate != null &&
          pickedDate.year == initialDate.year &&
          pickedDate.month == initialDate.month &&
          pickedDate.day == initialDate.day) {
        TimeRange timeRange = await await showTimeRangePicker(
          context: context,
          start: TimeOfDay.fromDateTime(initialDate),
          end: const TimeOfDay(hour: 23, minute: 59),
          disabledTime: TimeRange(
            startTime: const TimeOfDay(hour: 23, minute: 55),
            //end time initialDate minus 1 minute
            endTime: TimeOfDay.fromDateTime(initialDate),
          ),
          use24HourFormat: false,
        );

        pickedTime = timeRange.endTime;
      } else {
        pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
      }

      if (pickedTime != null) {
        setState(() {
          selectedDate.date = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime!.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  Future<void> _onSelectPlacePressed() async {
    Position position;
    if (_locationService.position == null) {
      position = await _locationService.getCurrentLocation();
    } else {
      position = _locationService.position!;
    }

    setState(() {
      _currentLocation = places_sdk.LatLng(
        lat: position.latitude,
        lng: position.longitude,
      );
      _isSearchingPlace = true;
    });
  }

  Future<void> _handleSelectedAssets(List<AssetEntity> selectedAssets) async {
    if (selectedAssets.isNotEmpty) {
      setState(() {
        assets.addAll(selectedAssets);
      });
    }
  }

  Future<void> _handleAddPictureAction() async {
    // final media =
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MediaPicker(
          requestType: RequestType.common,
          onHandleSelectedAssets: _handleSelectedAssets,
        ),
      ),
    );

    // if (media != null && media.isNotEmpty) {
    //   setState(() {
    //     selectedMedia.addAll(media);
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: SafeArea(
              child: Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 50, left: 5, right: 5),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (_currentPlaceName.isNotEmpty)
                              RoundedIconButton(
                                icon: FontAwesomeIcons.locationArrow,
                                label:
                                    '$_currentPlaceName ($_currentPlaceDistance)',
                                onPressed: () async {
                                  await _onSelectPlacePressed();
                                },
                                color: const Color(0xFFE6F0FF),
                                iconColor: const Color(0xFF4D8AF0),
                              ),
                            if (_currentPlaceName.isEmpty)
                              RoundedIconButton(
                                icon: FontAwesomeIcons.locationArrow,
                                label: 'Select a place',
                                iconColor: const Color(0xFF4D8AF0),
                                onPressed: () async {
                                  await _onSelectPlacePressed();
                                },
                              ),
                            IconButton(
                              padding: const EdgeInsets.all(0),
                              icon: const Icon(FontAwesomeIcons.xmark),
                              onPressed: () {
                                // Close the modal when the close button is pressed
                                Navigator.of(context).pop();
                              },
                              iconSize: 16,
                            ),
                          ],
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                const SizedBox(height: 24),
                                CustomTextField(
                                  controller: _eventNameController,
                                  focusNode: _eventNameFocusNode,
                                  isTextFieldFocused: _isEventNameFocused,
                                  label: 'Event Name',
                                ),
                                const SizedBox(height: 24),
                                CustomTextField(
                                  controller: _eventDescriptionController,
                                  focusNode: _eventDescriptionFocusNode,
                                  isTextFieldFocused:
                                      _isEventDescriptionFocused,
                                  label: 'Event Details',
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    RoundedIconButton(
                                      icon: FontAwesomeIcons.calendar,
                                      textLabel: 'Start date',
                                      label: _startDateWrapper.date != null
                                          ? DateFormat('yyyy-MM-dd HH:mm')
                                              .format(_startDateWrapper.date!)
                                          : 'Select Date',
                                      onPressed: () => _selectDate(
                                        context,
                                        _startDateWrapper,
                                      ),
                                    ),
                                    RoundedIconButton(
                                      icon: FontAwesomeIcons.calendar,
                                      textLabel: 'End date',
                                      label: _endDateWrapper.date != null
                                          ? DateFormat('yyyy-MM-dd HH:mm')
                                              .format(_endDateWrapper.date!)
                                          : 'Select Date',
                                      onPressed: () => _selectDate(
                                        context,
                                        _endDateWrapper,
                                        initialDate: _startDateWrapper.date,
                                      ),
                                      isDisabled:
                                          _startDateWrapper.date == null,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    RoundedIconButton(
                                      icon: FontAwesomeIcons.camera,
                                      label: 'Take Picture',
                                      onPressed: () {
                                        // TODO: Handle take picture action
                                      },
                                    ),
                                    const SizedBox(width: 10),
                                    RoundedIconButton(
                                      icon: FontAwesomeIcons.plus,
                                      label: 'Add Picture',
                                      onPressed: () async {
                                        // TODO: Handle add picture action
                                        await _handleAddPictureAction();
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                GridGallery(
                                  assets: assets,
                                  backgroundColor: lightGreyColor,
                                ),
                                const SizedBox(height: 16),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            RoundedIconButton(
                              icon: FontAwesomeIcons.floppyDisk,
                              label: 'Create Event',
                              onPressed: () {
                                Event event = Event(
                                  placeId: _currentPlaceId,
                                  placeName: _currentPlaceName,
                                  address: _currentAddress,
                                  location: _currentPlaceLocation,
                                  startTime: _startDateWrapper.date,
                                  endTime: _endDateWrapper.date,
                                  name: _eventNameController
                                      .text.capitalizeFirst!,
                                  details: _eventDescriptionController
                                      .text.capitalizeFirst!,
                                  assets: assets,
                                  imageUrls: [],
                                );

                                // call handler to create event
                                widget.onEventCreated(event);
                                // close modal
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (_isSearchingPlace && _currentLocation != null)
                    Container(
                      margin:
                          const EdgeInsets.only(right: 20, left: 20, top: 50),
                      child: SearchField(
                        shouldAutofocus: true,
                        currentLocation: _currentLocation,
                        handlePredictionSelection: _handlePredictionSelection,
                        clearSearch: _clearSearch,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isTextFieldFocused;
  final String label;

  const CustomTextField({
    required this.label,
    required this.controller,
    required this.focusNode,
    required this.isTextFieldFocused,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          //color
          color: Colors.grey[500],
          fontSize: 16,
          height: 5.5,
        ),
        hintText: isTextFieldFocused ? null : 'Event Name',
        filled: true,
        fillColor: Colors.grey[100],
        contentPadding: EdgeInsets.symmetric(
          vertical: isTextFieldFocused ? 30 : 22,
          horizontal: 24,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(28),
        ),
      ),
    );
  }
}

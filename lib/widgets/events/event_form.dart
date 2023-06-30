import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nomad/widgets/gallery/grid_gallery.dart';
import 'package:nomad/widgets/map/rounded_icon_button.dart';
import 'package:time_range_picker/time_range_picker.dart';

import 'package:intl/intl.dart';

class EventForm extends StatefulWidget {
  final String distance;
  final String placeName;

  const EventForm({Key? key, required this.distance, required this.placeName})
      : super(key: key);

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
  bool _isEventNameFocused = false;
  bool _isEventDescriptionFocused = false;
  final DateWrapper _startDateWrapper = DateWrapper();
  final DateWrapper _endDateWrapper = DateWrapper();

  @override
  void initState() {
    super.initState();
    _eventNameFocusNode.addListener(_handleEventNameFocusChange);
    _eventNameFocusNode.addListener(_handleEventDescriptionFocusChange);
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

  List<DropdownMenuEntry<String>> dropdownMenuEntries = [];
  bool isPrivate = false;
  String? eventType;

  @override
  Widget build(BuildContext context) {
    dropdownMenuEntries.add(
      const DropdownMenuEntry(
        value: 'Sporting event',
        label: 'Sporting event',
      ),
    );
    dropdownMenuEntries.add(
      const DropdownMenuEntry(value: 'Party', label: 'Party'),
    );
    dropdownMenuEntries.add(
      const DropdownMenuEntry(value: 'Leolist', label: 'Leolist'),
    );
    dropdownMenuEntries.add(
      const DropdownMenuEntry(
        value: 'Religious gathering',
        label: 'Religious gathering',
      ),
    );

    return Material(
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: SafeArea(
              child: Container(
                margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RoundedIconButton(
                            icon: FontAwesomeIcons.locationArrow,
                            label: '${widget.placeName} (${widget.distance})',
                            onPressed: () => {},
                            color: const Color(0xFFE6F0FF),
                            iconColor: const Color(0xFF4D8AF0),
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
                                isTextFieldFocused: _isEventDescriptionFocused,
                                label: 'Event Details',
                              ),
                              const SizedBox(height: 18),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  DropdownMenu<String>(
                                    label: const Text('Event type'),
                                    dropdownMenuEntries: dropdownMenuEntries,
                                    initialSelection:
                                        dropdownMenuEntries[0].label,
                                    onSelected: (String? str) {
                                      setState(() {
                                        eventType = str;
                                      });
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: ColoredBox(
                                        color: isPrivate
                                            ? Colors.blueGrey.shade100
                                            : lightGreyColor,
                                        child: CheckboxListTile(
                                          title: const Text(
                                            'Make event private',
                                          ),
                                          value: isPrivate,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              isPrivate = value!;
                                            });
                                          },
                                          secondary: isPrivate
                                              ? const Icon(Icons.lock_outline)
                                              : const Icon(Icons.lock_open),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
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
                                    onPressed: () =>
                                        _selectDate(context, _startDateWrapper),
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
                                    isDisabled: _startDateWrapper.date == null,
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
                                    onPressed: () {
                                      // TODO: Handle add picture action
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              const GridGallery(
                                imageUrls: [
                                  "https://picsum.photos/200/300?random=0",
                                  "https://picsum.photos/200/300?random=1",
                                  "https://picsum.photos/200/300?random=2",
                                  "https://picsum.photos/200/300?random=3",
                                  "https://picsum.photos/200/300?random=4",
                                  "https://picsum.photos/200/300?random=5",
                                  "https://picsum.photos/200/300?random=6",
                                  "https://picsum.photos/200/300?random=7",
                                  "https://picsum.photos/200/300?random=8",
                                  "https://picsum.photos/200/300?random=9",
                                  "https://picsum.photos/200/300?random=10",
                                ],
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
                              // TODO: Handle create event action
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
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

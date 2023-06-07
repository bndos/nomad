import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: () {
      //   // Close the modal when tapping outside the sheet
      //   Navigator.of(context).pop();
      // },
      child: Material(
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
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue[50],
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    FontAwesomeIcons.locationArrow,
                                    size: 12.0,
                                    color: Colors.blue,
                                  ),
                                  const SizedBox(width: 5.0),
                                  Text(
                                    '${widget.placeName} (${widget.distance})',
                                    style: const TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
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
                        const SizedBox(height: 16),
                        // TextButton.icon(
                        //   onPressed: () => _selectDate(context),
                        //   icon: const Icon(FontAwesomeIcons.calendar),
                        //   label: Text(
                        // _selectedDate != null
                        //     ? 'Selected Date: ${_selectedDate!.toIso8601String().split('T')[0]}'
                        //     : 'Select Date',
                        //   ),
                        // ),

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
                        )

                        // Add other form fields and content here
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
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

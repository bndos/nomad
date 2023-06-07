import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nomad/widgets/map/rounded_icon_button.dart';

class EventForm extends StatefulWidget {
  const EventForm({Key? key}) : super(key: key);

  @override
  EventFormState createState() => EventFormState();
}

class EventFormState extends State<EventForm> {
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _eventDescriptionController =
      TextEditingController();
  final FocusNode _eventNameFocusNode = FocusNode();
  final FocusNode _eventDescriptionFocusNode = FocusNode();
  bool _isEventNameFocused = false;
  bool _isEventDescriptionFocused = false;
  DateTime? _selectedDate;

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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: Theme(
            data: ThemeData.light(),
            child: child!,
          ),
        );
      },
    );
    if (pickedDate != null) {
      if (!mounted) return;

      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: Theme(
              data: ThemeData.light(),
              child: child!,
            ),
          );
        },
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
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
                  margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
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
                              label: _selectedDate != null
                                  ? _selectedDate!
                                      .toIso8601String()
                                      .split('T')[0]
                                  : 'Select Date',
                              onPressed: () => _selectDate(context),
                            ),
                            RoundedIconButton(
                              icon: FontAwesomeIcons.calendar,
                              textLabel: 'End date',
                              label: _selectedDate != null
                                  ? _selectedDate!
                                      .toIso8601String()
                                      .split('T')[0]
                                  : 'Select Date',
                              onPressed: () => _selectDate(context),
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

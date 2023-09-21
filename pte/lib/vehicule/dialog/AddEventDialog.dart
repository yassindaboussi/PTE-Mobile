import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../const/const.dart';

class AddEventDialog extends StatefulWidget {
  final Function(String, String, String, String, String) onAddEvent;

  const AddEventDialog({
    required this.onAddEvent,
    Key? key,
  }) : super(key: key);

  @override
  _AddEventDialogState createState() => _AddEventDialogState();
}

class _AddEventDialogState extends State<AddEventDialog> {
  final TextEditingController _titleController = TextEditingController();
  String? _selectedDriver;
  final TextEditingController _destinationController = TextEditingController();

  List<String> _userFullNames = [];
  Map<String, String> _userIdMapping = {};
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedStartTime;
  DateTime? _selectedEndTime;

  Future<List<Map<String, dynamic>>> fetchUserData() async {
    final response = await http.get(Uri.parse('$serverPath/api/users/getall'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  Future<List<String>> _fetchUserFullNames() async {
    try {
      List<Map<String, dynamic>> users = await fetchUserData();
      Map<String, String> mapping = {};
      for (var user in users) {
        String fullName = user['fullName'] as String;
        String userId = user['_id'] as String;
        mapping[fullName] = userId;
      }
      setState(() {
        _userFullNames = mapping.keys.toList();
        _userIdMapping = mapping;
      });
      return _userFullNames;
    } catch (e) {
      print('Error fetching user data: $e');
      return [];
    }
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedStartTime = DateTime(
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

  Future<void> _selectEndTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedEndTime = DateTime(
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
  void initState() {
    super.initState();
    _fetchUserFullNames().then((fullNames) {
      setState(() {
        _userFullNames = fullNames;
      });
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Add Event',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(),
                      ),
                      controller: _titleController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Title is required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Start',
                              border: OutlineInputBorder(),
                            ),
                            onTap: () => _selectStartTime(context),
                            readOnly: true,
                            controller: _selectedStartTime != null
                                ? TextEditingController(
                                text:
                                '${_selectedStartTime!.day}/${_selectedStartTime!.month}/${_selectedStartTime!.year} ${_selectedStartTime!.hour}:${_selectedStartTime!.minute}')
                                : null,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'End',
                              border: OutlineInputBorder(),
                            ),
                            onTap: () => _selectEndTime(context),
                            readOnly: true,
                            controller: _selectedEndTime != null
                                ? TextEditingController(
                                text:
                                '${_selectedEndTime!.day}/${_selectedEndTime!.month}/${_selectedEndTime!.year} ${_selectedEndTime!.hour}:${_selectedEndTime!.minute}')
                                : null,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _selectedDriver,
                      onChanged: (value) {
                        setState(() {
                          _selectedDriver = value;
                        });
                      },
                      items: _userFullNames.map((fullName) {
                        return DropdownMenuItem<String>(
                          value: fullName,
                          child: Text(fullName),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        labelText: 'Driver',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 12),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Destination',
                        border: OutlineInputBorder(),
                      ),
                      controller: _destinationController,
                      validator: (value) {
                        // Add validation for destination
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final String title = _titleController.text;
                        String start = _formatDateTime(_selectedStartTime);
                        String end = _formatDateTime(_selectedEndTime);
                        final String selectedFullName = _selectedDriver ?? '';
                        final String driverId = _userIdMapping[selectedFullName] ?? '';
                        final String destination = _destinationController.text;
                        widget.onAddEvent(
                          title,
                          start,
                          end,
                          driverId,
                          destination,
                        );
                        Navigator.pop(context);
                      }
                    },
                    child: Text(
                      'Add',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

  }
  String _formatDateTime(DateTime? dateTime) {
    if (dateTime != null) {
      return dateTime.toIso8601String();
    }
    return '';
  }
}

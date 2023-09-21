import 'package:flutter/material.dart';

class EditRoomDialog extends StatefulWidget {
  final Function(String, String, int) onEditRoom;
  final String existingLabel;
  final String existingLocation;
  final int existingCapacity;

  const EditRoomDialog({
    required this.onEditRoom,
    required this.existingLabel,
    required this.existingLocation,
    required this.existingCapacity,
    Key? key,
  }) : super(key: key);

  @override
  _EditRoomDialogState createState() => _EditRoomDialogState();
}

class _EditRoomDialogState extends State<EditRoomDialog> {
  late TextEditingController _labelController;
  late TextEditingController _locationController;
  late TextEditingController _capacityController;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _labelController = TextEditingController(text: widget.existingLabel);
    _locationController = TextEditingController(text: widget.existingLocation);
    _capacityController = TextEditingController(text: widget.existingCapacity.toString());
  }

  @override
  void dispose() {
    _labelController.dispose();
    _locationController.dispose();
    _capacityController.dispose();
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
                'Edit Room',
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
                        labelText: 'Label',
                        border: OutlineInputBorder(),
                      ),
                      controller: _labelController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Label is required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 12),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Location',
                        border: OutlineInputBorder(),
                      ),
                      controller: _locationController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Location is required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 12),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Capacity',
                        border: OutlineInputBorder(),
                      ),
                      controller: _capacityController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Capacity is required';
                        } else if (int.tryParse(value) == null) {
                          return 'Invalid capacity format';
                        }
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
                        final String label = _labelController.text;
                        final String location = _locationController.text;
                        final int capacity = int.parse(_capacityController.text);

                        widget.onEditRoom(label, location, capacity);
                        Navigator.pop(context);
                      }
                    },
                    child: Text(
                      'Save',
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
}

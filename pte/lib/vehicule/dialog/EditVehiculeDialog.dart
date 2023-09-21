import 'package:flutter/material.dart';

class EditVehiculeDialog extends StatefulWidget {
  final Function(String, String, String) onEditVehicule;
  final String existingModel;
  final String existingRegistrationNumber;
  final String existingType;

  const EditVehiculeDialog({
    required this.onEditVehicule,
    required this.existingModel,
    required this.existingRegistrationNumber,
    required this.existingType,
    Key? key,
  }) : super(key: key);

  @override
  _EditVehiculeDialogState createState() => _EditVehiculeDialogState();
}

class _EditVehiculeDialogState extends State<EditVehiculeDialog> {
  late TextEditingController _modelController;
  late TextEditingController _registrationNumberController;
  late TextEditingController _typeController;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _modelController = TextEditingController(text: widget.existingModel);
    _registrationNumberController =
        TextEditingController(text: widget.existingRegistrationNumber);
    _typeController = TextEditingController(text: widget.existingType);
  }

  @override
  void dispose() {
    _modelController.dispose();
    _registrationNumberController.dispose();
    _typeController.dispose();
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
                'Edit Vehicle',
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
                        labelText: 'Model',
                        border: OutlineInputBorder(),
                      ),
                      controller: _modelController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Model is required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 12),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Registration Number',
                        border: OutlineInputBorder(),
                      ),
                      controller: _registrationNumberController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Registration number is required';
                        } else if (!RegExp(r'^[1-9]\d{0,2} \d{1,4}$')
                            .hasMatch(value)) {
                          return 'Invalid registration number format';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 12),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Type',
                        border: OutlineInputBorder(),
                      ),
                      controller: _typeController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Type is required';
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
            final String model = _modelController.text;
            final String registrationNumber = _registrationNumberController
                .text;
            final String type = _typeController.text;

            // Check for null values before calling the callback
            if (model != null && registrationNumber != null && type != null) {
              widget.onEditVehicule(model, registrationNumber, type);
              Navigator.pop(context);
            } else {
              // Handle the case where one or more form fields are null
              print('One or more form fields are null');
            }
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

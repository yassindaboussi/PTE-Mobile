import 'package:flutter/material.dart';

class AddVehiculeDialog extends StatefulWidget {
  final Function(String, String, String) onAddVehicule;

  const AddVehiculeDialog({
    required this.onAddVehicule,
    Key? key,
  }) : super(key: key);

  @override
  _AddVehiculeDialogState createState() => _AddVehiculeDialogState();
}

class _AddVehiculeDialogState extends State<AddVehiculeDialog> {
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _registrationNumberController =
  TextEditingController();
  final TextEditingController _typeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

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
                'Add Vehicle',
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
                        final String registrationNumber =
                            _registrationNumberController.text;
                        final String type = _typeController.text;
                        widget.onAddVehicule(model, registrationNumber, type);
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
}

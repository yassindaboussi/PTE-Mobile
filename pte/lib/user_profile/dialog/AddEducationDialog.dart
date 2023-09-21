import 'package:flutter/material.dart';

class AddEducationDialog extends StatefulWidget {
  final Function(String, String, String, String) onAddEducation;

  const AddEducationDialog({
    required this.onAddEducation,
    Key? key,
  }) : super(key: key);

  @override
  _AddEducationDialogState createState() => _AddEducationDialogState();
}

class _AddEducationDialogState extends State<AddEducationDialog> {
  final TextEditingController _diplomaController = TextEditingController();
  final TextEditingController _establishmentController = TextEditingController();
  final TextEditingController _sectionController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();

  @override
  void dispose() {
    _diplomaController.dispose();
    _establishmentController.dispose();
    _sectionController.dispose();
    _yearController.dispose();
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
                'Add Education',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Diploma',
                  border: OutlineInputBorder(),
                ),
                controller: _diplomaController,
              ),
              SizedBox(height: 12),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Establishment',
                  border: OutlineInputBorder(),
                ),
                controller: _establishmentController,
              ),
              SizedBox(height: 12),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Section',
                  border: OutlineInputBorder(),
                ),
                controller: _sectionController,
              ),
              SizedBox(height: 12),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Year(yyyy)',
                  border: OutlineInputBorder(),
                ),
                controller: _yearController,
                keyboardType: TextInputType.number,
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
                      final String diploma = _diplomaController.text;
                      final String establishment = _establishmentController.text;
                      final String section = _sectionController.text;
                      final String year = _yearController.text;

                      if (diploma.isNotEmpty &&
                          establishment.isNotEmpty &&
                          section.isNotEmpty &&
                          year.isNotEmpty) {
                        widget.onAddEducation(
                            diploma, establishment, section, year);
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

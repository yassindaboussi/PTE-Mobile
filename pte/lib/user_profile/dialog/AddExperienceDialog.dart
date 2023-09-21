import 'package:flutter/material.dart';

class AddExperienceDialog extends StatefulWidget {
  final Function(
      String,
      String,
      String,
      String,
      String,
      ) onAddExperience;

  const AddExperienceDialog({
    required this.onAddExperience,
    Key? key,
  }) : super(key: key);

  @override
  _AddExperienceDialogState createState() => _AddExperienceDialogState();
}

class _AddExperienceDialogState extends State<AddExperienceDialog> {
  final TextEditingController _organizationController = TextEditingController();
  final TextEditingController _jobController = TextEditingController();
  final TextEditingController _startPeriodController = TextEditingController();
  final TextEditingController _endPeriodController = TextEditingController();
  final TextEditingController _taskDescriptionController =
  TextEditingController();

  @override
  void dispose() {
    _organizationController.dispose();
    _jobController.dispose();
    _startPeriodController.dispose();
    _endPeriodController.dispose();
    _taskDescriptionController.dispose();
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
                'Add Experience',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Organization',
                  border: OutlineInputBorder(),
                ),
                controller: _organizationController,
              ),
              SizedBox(height: 12),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Job',
                  border: OutlineInputBorder(),
                ),
                controller: _jobController,
              ),
              SizedBox(height: 12),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Start period(yyyy)',
                  border: OutlineInputBorder(),
                ),
                controller: _startPeriodController,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 12),
              TextField(
                decoration: InputDecoration(
                  labelText: 'End period(yyyy)',
                  border: OutlineInputBorder(),
                ),
                controller: _endPeriodController,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 12),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Task description',
                  border: OutlineInputBorder(),
                ),
                controller: _taskDescriptionController,
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
                      final String organization = _organizationController.text;
                      final String job = _jobController.text;
                      final String startPeriod =
                          _startPeriodController.text;
                      final String endPeriod = _endPeriodController.text;
                      final String taskDescription =
                          _taskDescriptionController.text;

                      if (organization.isNotEmpty &&
                          job.isNotEmpty &&
                          startPeriod.isNotEmpty &&
                          endPeriod.isNotEmpty &&
                          taskDescription.isNotEmpty) {
                        widget.onAddExperience(
                          organization,
                          job,
                          startPeriod,
                          endPeriod,
                          taskDescription,
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
}

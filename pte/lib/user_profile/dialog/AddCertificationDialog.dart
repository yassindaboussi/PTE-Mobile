import 'package:flutter/material.dart';

class AddCertificationDialog extends StatefulWidget {
  final Function(String, String) onAddCertification;

  const AddCertificationDialog({
    required this.onAddCertification,
    Key? key,
  }) : super(key: key);

  @override
  _AddCertificationDialogState createState() => _AddCertificationDialogState();
}

class _AddCertificationDialogState extends State<AddCertificationDialog> {
  final TextEditingController _domaineController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  int? _selectedYear;

  void _showYearPicker() async {
    DateTime currentDate = DateTime.now();
    int currentYear = currentDate.year;

    // Show a dialog containing a custom year picker.
    _selectedYear = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: YearPicker(
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
              selectedDate: DateTime(currentYear),
              onChanged: (DateTime date) {
                setState(() {
                  _selectedYear = date.year;
                });
                Navigator.of(context).pop(_selectedYear);
              },
            ),
          ),
        );
      },
    );

    if (_selectedYear != null) {
      _yearController.text = _selectedYear.toString();
    }
  }

  @override
  void dispose() {
    _domaineController.dispose();
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
              'Add Certification',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Domaine',
                border: OutlineInputBorder(),
              ),
              controller: _domaineController,
            ),
            SizedBox(height: 12),
            InkWell(
              onTap: _showYearPicker,
              child: IgnorePointer(
                child: TextField(
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Year',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  controller: _yearController,
                ),
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
                    final String domaine = _domaineController.text;
                    final String year = _yearController.text;

                    if (domaine.isNotEmpty && year.isNotEmpty) {
                      widget.onAddCertification(domaine, year);
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
    );
  }
}

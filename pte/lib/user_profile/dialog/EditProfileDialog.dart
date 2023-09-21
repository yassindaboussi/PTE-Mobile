import 'package:flutter/material.dart';

class EditProfileDialog extends StatefulWidget {
  final Function(
      String,
      String,
      String,
      String,
      String,
      String,
      bool,
      String,
      String,
      String,
      String,
      bool,
      ) onSaveProfile;
  final Map<String, dynamic> initialUserData;

  const EditProfileDialog({
    required this.onSaveProfile,
    required this.initialUserData,
    Key? key,
  }) : super(key: key);

  @override
  _EditProfileDialogState createState() => _EditProfileDialogState();
}



class _EditProfileDialogState extends State<EditProfileDialog> {
  final TextEditingController _FullNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _familySituationController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _hiringDateController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();

  bool _drivingLicense = false;
  bool _isEnabled = false;


  @override
  void initState() {
    super.initState();

    _FullNameController.text = widget.initialUserData['fullName'] ?? '';
    _phoneController.text = widget.initialUserData['phone'].toString() ?? '';
    _emailController.text = widget.initialUserData['email'] ?? '';
    _departmentController.text = widget.initialUserData['department'] ?? '';
    _addressController.text = widget.initialUserData['address'] ?? '';
    _familySituationController.text = widget.initialUserData['familySituation'] ?? '';
    _dateOfBirthController.text = _formatDate(widget.initialUserData['DateOfBirth'] ?? '');
    _genderController.text = widget.initialUserData['gender'] ?? '';
    _hiringDateController.text = _formatDate(widget.initialUserData['hiringDate'] ?? '');
    _experienceController.text = widget.initialUserData['experience'].toString() ?? '';
    _drivingLicense = widget.initialUserData['drivingLicense'] ?? false;
    _isEnabled = widget.initialUserData['isEnabled'] ?? false;

  }

  String _formatDate(String date) {
    if (date != null && date.contains('T')) {
      return date.split('T')[0];
    }
    return date;
  }

  @override
  void dispose() {
    _FullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _departmentController.dispose();
    _addressController.dispose();
    _familySituationController.dispose();
    _dateOfBirthController.dispose();
    _genderController.dispose();
    _hiringDateController.dispose();
    _experienceController.dispose();
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Edit Profile',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
                controller: _FullNameController,
              ),
              SizedBox(height: 12),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Phone',
                  border: OutlineInputBorder(),
                ),
                controller: _phoneController,
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 12),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 12),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Department',
                  border: OutlineInputBorder(),
                ),
                controller: _departmentController,
              ),
              SizedBox(height: 12),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                ),
                controller: _addressController,
              ),
              SizedBox(height: 12),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Family Situation',
                  border: OutlineInputBorder(),
                ),
                controller: _familySituationController,
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Text('Driving License'),
                  SizedBox(width: 8),
                  Switch(
                    value: _drivingLicense,
                    onChanged: (value) {
                      setState(() {
                        _drivingLicense = value;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 12),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Date Of Birth',
                  border: OutlineInputBorder(),
                ),
                controller: _dateOfBirthController,
              ),
              SizedBox(height: 12),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Gender',
                  border: OutlineInputBorder(),
                ),
                controller: _genderController,
              ),
              SizedBox(height: 12),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Hiring Date',
                  border: OutlineInputBorder(),
                ),
                controller: _hiringDateController,
              ),
              SizedBox(height: 12),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Experience',
                  border: OutlineInputBorder(),
                ),
                controller: _experienceController,
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Text('Is Enabled'),
                  SizedBox(width: 8),
                  Switch(
                    value: _isEnabled,
                    onChanged: (value) {
                      setState(() {
                        _isEnabled = value;
                      });
                    },
                  ),
                ],
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
                      final String fullName = _FullNameController.text;
                      final String phone = _phoneController.text;
                      final String email = _emailController.text;
                      final String department = _departmentController.text;
                      final String address = _addressController.text;
                      final String familySituation = _familySituationController.text;
                      final String dateOfBirth = _dateOfBirthController.text;
                      final String gender = _genderController.text;
                      final String hiringDate = _hiringDateController.text;
                      final String experience = _experienceController.text;

                      widget.onSaveProfile(
                        fullName,
                        phone,
                        email,
                        department,
                        address,
                        familySituation,
                        _drivingLicense,
                        dateOfBirth,
                        gender,
                        hiringDate,
                        experience,
                        _isEnabled,
                      );
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Save Profile',
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

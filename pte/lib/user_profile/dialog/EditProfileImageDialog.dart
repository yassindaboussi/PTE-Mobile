import 'package:flutter/material.dart';
import '../../service/ServiceUser.dart';

class EditProfileImageDialog extends StatelessWidget {
  final String token;
  final String idUser;
  final Function() onPhotoUpdated;

  EditProfileImageDialog({required this.token, required this.idUser, required this.onPhotoUpdated});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text(
                'Edit Profile Image',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                UploadImageUser(idUser, token, onPhotoUpdated);
                Navigator.pop(context);
              },
              child: Text('Import New Photo'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                primary: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                DeletePhotoUser(idUser,token,onPhotoUpdated);
                Navigator.pop(context);
              },
              child: Text('Delete This Photo'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                primary: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 12),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Close'),
              style: TextButton.styleFrom(
                primary: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

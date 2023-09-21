import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';

import '../const/const.dart';


Future<List<dynamic>> fetchUserData() async { // get user informations
  final response = await http.get(Uri.parse('$serverPath/api/users/getall'));
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    //print(response.body);
    return data;
  } else {
    throw Exception('Failed to fetch data');
  }
}

Future<Map<String, dynamic>> getUserById(String id, String token) async { //get user info + CV
  final url = Uri.parse('$serverPath/api/users/$id');
  final response = await http.get(
    url,
    headers: {'Authorization': 'Bearer $token'},
  );

  //print(response.body);
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to get user \n Maybe Token has expired');
  }
}

Future<List> searchUsersByName(String name) async {
  final response = await http.get(Uri.parse('$serverPath/api/users/getall'));
  if (response.statusCode == 200) {
    final List<dynamic> responseData = json.decode(response.body);
    return responseData
        .where((user) => user['fullName'].toLowerCase().contains(name.toLowerCase()))
        .toList();
  } else {
    throw Exception('Failed to load users');
  }
}

Future<List<Map<String, dynamic>>> searchUsersByDepartmentAndTitle(String department, String title) async {
  final response = await http.get(Uri.parse('$serverPath/api/users/getall'));
  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body);
    List<Map<String, dynamic>> users = [];
    for (var userJson in jsonData) {
      if (userJson['department'] == department || userJson['title'] == title) {
        users.add(userJson);
      }
    }
    return users;
  } else {
    throw Exception('Failed to load user data');
  }
}


Future<void> updateUser(String idUser, String Token, Map<String, dynamic> data) async {
  final response = await http.patch(
    Uri.parse('$serverPath/api/users/update/$idUser'),
    headers: {
      'Authorization': 'Bearer $Token',
      'Content-Type': 'application/json',
    },
    body: json.encode(data),
  );

  if (response.statusCode == 200) {
    print('User updated successfully');
  } else {
    print('Failed to update user');
  }
}

final ImagePicker _imagePicker = ImagePicker();
Future<void> UploadImageUser(String idUser,String Token,Function() onPhotoUpdated) async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final file = File(pickedFile.path);
        final request = http.MultipartRequest(
          'POST',
          Uri.parse('$serverPath/file'),
        );

        request.files.add(await http.MultipartFile.fromPath('image', file.path));

        final response = await request.send();
        if (response.statusCode == 200) {
          final data = {
            "image": file.path.split('/').last, // Get only the filename from the path
          };

          await updateUser(idUser,Token, data);

          onPhotoUpdated();

        } else {
          print('Failed to upload image');
        }
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }


Future<void> DeletePhotoUser(String idUser,String Token,Function() onPhotoUpdated) async {
  Map<String, dynamic> data = {
    "image": "",
  };
  try {
    await updateUser(idUser,Token, data);

    onPhotoUpdated();

    print('Delete photo successfully');
  } catch (e) {
    print('Failed to Delete: $e');
  }
}









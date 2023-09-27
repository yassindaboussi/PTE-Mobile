import 'package:http/http.dart' as http;
import 'dart:convert';
import '../const/const.dart';

Future<int> CountUser() async {
  final response = await http.get(Uri.parse('$serverPath/api/users/getall'));
  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    int userCount = data.length;
    return userCount;
  } else {
    throw Exception('Failed to fetch data');
  }
}


Future<int> countRooms(String token) async {
  final response = await http.get(
    Uri.parse('$serverPath/api/material/room/getRooms'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );
  if (response.statusCode == 200) {
    final List<dynamic> roomList = json.decode(response.body);
    return roomList.length;
  } else {
    throw Exception('Failed to load rooms');
  }
}

Future<int> countVehicles(String token) async {
  final response = await http.get(
    Uri.parse('$serverPath/api/material/vehicle/getVehicles'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );
  if (response.statusCode == 200) {
    final List<dynamic> vehicleList = json.decode(response.body);
    return vehicleList.length;
  } else {
    throw Exception('Failed to load vehicles');
  }
}

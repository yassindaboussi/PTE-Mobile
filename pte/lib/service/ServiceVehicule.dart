import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import '../const/const.dart';


Future<List<dynamic>> searchVehicles(String searchText,String token) async {
  final response = await http.get(
    Uri.parse('$serverPath/api/material/vehicle/search?text=$searchText'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    return data;
  } else {
    throw Exception('Failed to load data');
  }
}




Future<List<Map<String, dynamic>>> getVehicles(String Token) async {
  final response = await http.get(
    Uri.parse('$serverPath/api/material/vehicle/getVehicles'),
    headers: {
      'Authorization': 'Bearer $Token',
    },
  );
  if (response.statusCode == 200) {
    final List<dynamic> vehicleList = json.decode(response.body);
    return vehicleList.cast<Map<String, dynamic>>();
  } else {
    throw Exception('Failed to load vehicles');
  }
}


Future addVehicule( String token, Map<String, dynamic> data) async {
  final response = await http.post(
    Uri.parse('$serverPath/api/material/vehicle/addVehicle'),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
    body: jsonEncode(data),
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else if (response.statusCode == 400) {
    throw Exception('Registration number already exists');
  } else {
    throw Exception('Failed to add vehicle');
  }
}


Future<void> updateVehicule(String token, String id, Map<String, dynamic> data) async {

  try {
    final response = await http.patch(
      Uri.parse('$serverPath/api/material/vehicle/update/$id'),
      headers: {
        'Authorization':'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 400) {
      print('Registration number already exists');
    }
  } catch (error) {
    print('An error occurred: $error');
  }
}



Future<void> deleteVehicule(String token, String id) async {
  try {
    final response = await http.delete(
      Uri.parse('$serverPath/api/material/vehicle/deleteVehicle/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      print('Vehicle deleted');
    } else {
      print('Failed to delete vehicle. Status code: ${response.statusCode}');
    }
  } catch (error) {
    print('An error occurred: $error');
  }
}

  Future<List<dynamic>> getVehicleEvents(String token, String vehicleId) async {
    final baseUrl = '$serverPath/api/material/vehicle/events';
    final uri = Uri.parse(baseUrl);

    final headers = {
      'Authorization': 'Bearer $token',
    };

    final queryParams = {
      'vehicle': vehicleId,
      'start': '2023-08-26T23:00',
      'end': '2023-10-07T23:00',
    };

    final response = await http.get(uri.replace(queryParameters: queryParams), headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> events = json.decode(response.body);
      return events;
    } else {
      throw Exception('Failed to load events');
    }
}

Future<void> deleteEvent(String eventId, String authToken) async {
  final url = Uri.parse('$serverPath/api/material/vehicle/deleteEvent/$eventId');

  try {
    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $authToken',
      },
    );

    if (response.statusCode == 200) {
      print('Event successfully deleted');
    } else if (response.statusCode == 404) {
      print('Event ID is not valid');
    } else {
      print('Unexpected response status: ${response.statusCode}');
    }
  } catch (error) {
    print('Error during HTTP request: $error');
  }
}


Future<void> createEventt(String token,String title,String start,String end,String vehicle,String applicant, String driver, String destination,BuildContext context) async {
  final url = '$serverPath/api/material/vehicle/setevent';
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  final body = {
    'title': title,
    'start': start,
    'end': end,
    'vehicle': vehicle,
    'applicant': applicant,
    'driver': driver,
    'destination': destination,
  };

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      print('Event created successfully!');
      print(json.decode(response.body));
    } else {
      print('Failed to create event. Status code: ${response.statusCode}');
      print(json.decode(response.body));

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Failed to create event'),
            content: Text(json.decode(response.body)),
            actions: [
              TextButton(
              onPressed: () {
            Navigator.pop(context);
               },
                child: Text('OK'),
              ),
            ],
          );
        },
      );

    }
  } catch (error) {
    print('Error creating event: $error');
  }
}








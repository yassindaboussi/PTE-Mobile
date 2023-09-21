import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import '../const/const.dart';



Future<List<Map<String, dynamic>>> getRooms(String Token) async {
  final response = await http.get(
    Uri.parse('$serverPath/api/material/room/getRooms'),
    headers: {
      'Authorization': 'Bearer $Token',
    },
  );
  if (response.statusCode == 200) {
    final List<dynamic> roomList = json.decode(response.body);
    return roomList.cast<Map<String, dynamic>>();
  } else {
    throw Exception('Failed to load Rooms');
  }
}

Future<List<dynamic>> searchRooms(String searchText, String token) async {
  final response = await http.get(Uri.parse('$serverPath/api/material/room/search?text=$searchText'),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load rooms');
  }
}


Future<void> addRoom(String token,Map<String, dynamic> roomData) async {
  try {
    final response = await http.post(
      Uri.parse('$serverPath/api/material/room/add'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(roomData),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> room = jsonDecode(response.body);
      print('Room added: $room');
    } else if (response.statusCode == 500) {
      print('Server error');
    } else {
      print('Unexpected status code: ${response.statusCode}');
    }
  } catch (error) {
    print('An error occurred: $error');
  }
}



Future<void> updateRoom(String token, String id, Map<String, dynamic> data) async {
  try {
    final response = await http.patch(
      Uri.parse('$serverPath/api/material/room/update/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      print('Room not found');
    } else if (response.statusCode == 500) {
      print('Server error');
    } else if (response.statusCode == 400) {
      print('Invalid request or ID is not valid');
    } else {
      print('Unexpected status code: ${response.statusCode}');
    }
  } catch (error) {
    print('An error occurred: $error');
  }
}




Future<void> deleteRoom(String token, String id) async {

  try {
    final response = await http.delete(
      Uri.parse('$serverPath/api/material/room/delete/$id'),
      headers: {
        'Authorization':'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      print('Room deleted');
    } else {
      print('Failed to delete room. Status code: ${response.statusCode}');
    }
  } catch (error) {
    print('An error occurred: $error');
  }
}


Future<List<dynamic>> getRoomEvents(String token, String roomId) async {
  final baseUrl = '$serverPath/api/material/room/events';
  final uri = Uri.parse(baseUrl);

  final headers = {
    'Authorization': 'Bearer $token',
  };

  final queryParams = {
    'room': roomId
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
  final url = Uri.parse('$serverPath/api/material/room/deleteEvent/$eventId');

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


Future<void> createEventt(String token,String title,String start,String end,String room,String applicant,BuildContext context) async {
  final url = '$serverPath/api/material/room/setevent';
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  final body = {
    'title': title,
    'start': start,
    'end': end,
    'room': room,
    'applicant': applicant,
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
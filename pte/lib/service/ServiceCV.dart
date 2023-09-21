import 'package:http/http.dart' as http;
import 'dart:convert';

import '../const/const.dart';


Future<dynamic> updateCV(String authToken,String id, Map<String, dynamic> data) async {
  final response = await http.patch(
    Uri.parse('$serverPath/api/cv/update/$id'),
    body: jsonEncode(data),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $authToken',
    },
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to update CV');
  }
}

Future<void> deleteItem(String authToken,String id, String arrayName, String itemId) async {
  final response = await http.delete(
    Uri.parse('$serverPath/api/cv/delete-item/$id/$arrayName/$itemId'),
    headers: {
      'Authorization': 'Bearer $authToken',
    },
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to delete item');
  }
}
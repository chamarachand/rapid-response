import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<dynamic>> fetchPostData() async {
  final response = await http
      .get(Uri.parse('http://10.0.2.2:3000/api/posts/incidents/latest'));
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    print(response.statusCode);
    throw Exception('Failed to load data');
  }
}

Future<List<dynamic>> fetchSosData() async {
  final response =
      await http.get(Uri.parse('http://10.0.2.2:3000/api/posts/sos'));
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load data');
  }
}

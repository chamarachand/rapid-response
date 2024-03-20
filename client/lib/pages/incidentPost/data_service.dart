import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<dynamic>> fetchData() async* {
  final response = await http.get(Uri.parse('http://  :3000/api/incidentPost'));
  if(response.statusCode == 200){
    return json.decode(response.body);
  }else{
    throw Exception('Failed to load data.');
  }
}

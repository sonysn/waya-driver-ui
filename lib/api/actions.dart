
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:waya_driver/constants/api_constants.dart';

//todo base uri value here
var baseUri = 'https://waya-api.onrender.com';

//availability is a bool returns 1 or 0
Future updateAvailability(availability, id) async{
  final http.Response response = await http.post(
      Uri.parse('$baseUri${ApiConstants.updateAvailabilityEndpoint}'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "availabilityStatus": availability,
        "driverID": id,
      }));
  return response.statusCode;
}

Future getDriverCars(id, token) async{
  final http.Response response = await http.get(
    Uri.parse('$baseUri/$id${ApiConstants.getDriverCars}'),
    headers: {
      "Content-Type": "application/json",
      "Authorization": 'Bearer $token'
    }
  );
  final data = await jsonDecode(response.body);
  //print(data['result'].length);
  return data;
}
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:waya_driver/constants/api_constants.dart';
import 'package:waya_driver/models/auth.dart';

//todo base uri value here
var baseUri = 'https://waya-api.onrender.com';

Future signIn(emailOrPhone, password) async {
  final http.Response response = await http.post(
      Uri.parse('$baseUri${ApiConstants.signInEndpoint}'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "password": password,
        "phoneNumber": emailOrPhone,
        "email": emailOrPhone
      }));
  if(response.statusCode == 200){
    //print(Data.fromJson(json.decode(response.body)).email);
    return Data.fromJson(json.decode(response.body));
    //return json.decode(response.body);
  } else {
    throw Exception('Login Failed');
  }
}
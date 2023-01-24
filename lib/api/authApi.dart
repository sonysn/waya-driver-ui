import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:waya_driver/constants/api_constants.dart';

var baseUri = 'http://192.168.100.43:3000';

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

class Data {
  final String token;
  final int id;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String email;
  final String address;
  final String? profilePhoto;
  final double rating;
  final String workAddress;

  Data({
    required this.token,
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.email,
    required this.address,
    required this.profilePhoto,
    required this.rating,
    required this.workAddress,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    //print(json['result'][0]['ID']);
    return Data(token: json['token'],
        id: json['result'][0]['ID'],
        firstName: json['result'][0]['FIRST_NAME'],
        lastName: json['result'][0]['LAST_NAME'],
        phoneNumber: json['result'][0]['PHONE_NUMBER'],
        email: json['result'][0]['EMAIL'],
        address: json['result'][0]['EMAIL'],
        profilePhoto: json['result'][0]['PROFILE_PHOTO'],
        rating: double.parse(json['result'][0]['RATING'].toString()),
        workAddress: json['result'][0]['WORK_ADDRESS'],

    );
  }
}
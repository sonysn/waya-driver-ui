import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:waya_driver/constants/api_constants.dart';
import 'package:waya_driver/models/auth.dart';
import 'package:path/path.dart' as path;

//todo base uri value here
//var baseUri = 'http://192.168.100.43:3000';
var baseUri = 'https://waya-api.onrender.com';
//var baseUri = 'https://e7b6-102-216-201-31.ngrok-free.app';

Future paystackDeposit(
    {required int id,
    required dynamic phone,
    required String email,
    required int amount}) async {
  try {
    final http.Response response = await http.post(
      Uri.parse('$baseUri${ApiConstants.chargeEndpoint}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'driverID': id,
        'phone': phone,
        'email': email,
        'amount': amount,
        'reference': 'ref_${DateTime.now().millisecondsSinceEpoch}',
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('An error occurred while processing your payment.');
    }
  } catch (e) {
    throw Exception('An error occurred while processing your payment.');
  }
}

Future getRidersTransfers({required int driverID}) async {
  final http.Response response = await http.get(
      Uri.parse('$baseUri/$driverID${ApiConstants.getUserTransfersEndpoint}'),
      headers: {'Content-Type': 'application/json'});
  if (response.statusCode == 200) {
    dynamic data = json.decode(response.body);
    //print(data);
    return data;
  }
}

Future getDepositHistory({required int driverID}) async {
  final http.Response response = await http.get(
      Uri.parse('$baseUri/$driverID${ApiConstants.getDepositsEndpoint}'),
      headers: {'Content-Type': 'application/json'});
  if (response.statusCode == 200) {
    dynamic data = json.decode(response.body);
    //print(data);
    return data;
  }
}

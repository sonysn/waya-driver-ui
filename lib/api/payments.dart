import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:waya_driver/constants/api_constants.dart';
import 'package:waya_driver/models/auth.dart';
import 'package:path/path.dart' as path;

//todo base uri value here
//var baseUri = 'http://192.168.100.43:3000';
var baseUri = 'https://waya-api.onrender.com';
//var baseUri = 'https://e7b6-102-216-201-31.ngrok-free.app';

Future paystackDeposit({required String email, required int amount}) async {
  try {
    final http.Response response = await http.post(
      Uri.parse('$baseUri/charge'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
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

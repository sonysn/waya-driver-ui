import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:waya_driver/constants/api_constants.dart';

//todo base uri value here
//var baseUri = 'http://192.168.100.43:3000';
// var baseUri = 'https://waya-api.onrender.com';
//var baseUri = 'https://e7b6-102-216-201-31.ngrok-free.app';
var baseUri = ApiConstants.baseUrl;

Future paystackDeposit(
    {required int id,
    required dynamic phone,
    required String email,
    required int amount,
    required String authBearer}) async {
  try {
    final http.Response response = await http.post(
      Uri.parse('$baseUri${ApiConstants.chargeEndpoint}'),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": 'Bearer $authBearer'
      },
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

Future getRidersTransfers(
    {required int driverID, required String authBearer}) async {
  final http.Response response = await http.get(
      Uri.parse('$baseUri/$driverID${ApiConstants.getUserTransfersEndpoint}'),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": 'Bearer $authBearer'
      });
  if (response.statusCode == 200) {
    dynamic data = json.decode(response.body);
    //print(data);
    return data;
  }
}

Future getDepositHistory(
    {required int driverID, required String authBearer}) async {
  final http.Response response = await http.get(
      Uri.parse('$baseUri/$driverID${ApiConstants.getDepositsEndpoint}'),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": 'Bearer $authBearer'
      });
  if (response.statusCode == 200) {
    dynamic data = json.decode(response.body);
    //print(data);
    return data;
  }
}

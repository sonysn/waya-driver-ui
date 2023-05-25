import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:waya_driver/constants/api_constants.dart';

//todo base uri value here
//var baseUri = 'http://192.168.100.43:3000';
var baseUri = 'https://waya-api.onrender.com';

//availability is a bool returns 1 or 0
Future updateAvailability(availability, id) async {
  final http.Response response = await http.post(
      Uri.parse('$baseUri${ApiConstants.updateAvailabilityEndpoint}'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "availabilityStatus": availability,
        "driverID": id,
      }));
  return response.statusCode;
}

Future getDriverCars(id, token) async {
  final http.Response response = await http
      .get(Uri.parse('$baseUri/$id${ApiConstants.getDriverCars}'), headers: {
    "Content-Type": "application/json",
    "Authorization": 'Bearer $token'
  });
  final data = await jsonDecode(response.body);
  //print(data['result'].length);
  return data;
}

Future getBalance(id, phone) async {
  final http.Response response =
      await http.post(Uri.parse('$baseUri${ApiConstants.getBalanceEndpoint}'),
          headers: {
            "Content-Type": "application/json",
          },
          body: json.encode({
            'id': id,
            'phoneNumber': phone,
          }));
  final data = json.decode(response.body);
  final d = data['balance'].toString();
  return d;
}

Future transfer(amount, receivingNum, sendingNum) async {
  final http.Response response = await http.post(
      Uri.parse('$baseUri${ApiConstants.transferToOtherDrivers}'),
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode({
        'amountToBeTransferred': amount,
        'driverReceivingPhoneNumber': receivingNum,
        'driverSendingPhoneNumber': sendingNum,
      }));
  final data = json.decode(response.body);
  final d = data['message'].toString();
  return d;
}

Future acceptRide(
    {required int riderId,
    required String? driverPhoto,
    required String? driverPhone,
    required String? vehicleName,
    required String? vehiclePlateNumber,
    required String? vehicleColour}) async {
  final http.Response response = await http.post(
      Uri.parse('$baseUri${ApiConstants.driverAcceptRideEndpoint}'),
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode({
        'riderID': riderId,
        'driverPhoto': driverPhoto,
        'vehicleName': vehicleName,
        'vehiclePlateNumber': vehiclePlateNumber,
        'vehicleColour': vehicleColour,
        'driverPhone': driverPhone
      }));
}

Future locationPing(
    {required int driverID, required locationPoint, required timeStamp}) async {
  final http.Response response = await http.post(
      Uri.parse('$baseUri/$driverID${ApiConstants.locationUpdatePingEndpoint}'),
      headers: {
        "Content-Type": "application/json",
      },
      body: json
          .encode({'locationPoint': locationPoint, 'timeStamp': timeStamp}));
}

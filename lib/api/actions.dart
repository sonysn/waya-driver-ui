// ignore_for_file: depend_on_referenced_packages, unused_local_variable

import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:qunot_driver/constants/api_constants.dart';

//todo base uri value here
// var baseUri = 'http://192.168.100.43:3000';
// var baseUri = 'https://waya-api.onrender.com';
var baseUri = ApiConstants.baseUrl;

//availability is a bool returns 1 or 0
Future updateAvailability({required int availability, required int id}) async {
  final http.Response response = await http.post(
      Uri.parse('$baseUri${ApiConstants.updateAvailabilityEndpoint}'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "availabilityStatus": availability,
        "driverID": id,
      }));
  return response.statusCode;
}

Future getDriverCars({required int id, required String authBearer}) async {
  final http.Response response = await http
      .get(Uri.parse('$baseUri/$id${ApiConstants.getDriverCars}'), headers: {
    "Content-Type": "application/json",
    "Authorization": 'Bearer $authBearer'
  });
  final data = await jsonDecode(response.body);
  //print(data['result'].length);
  return data;
}

Future getBalance(
    {required int id,
    required String phone,
    required String authBearer}) async {
  final http.Response response = await http.post(
      Uri.parse('$baseUri${ApiConstants.getBalanceEndpoint}'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": 'Bearer $authBearer'
      },
      body: json.encode({
        'id': id,
        'phoneNumber': phone,
      }));
  final data = json.decode(response.body);
  final d = data['balance'].toString();
  return d;
}

Future transfer(amount, receivingNum, sendingNum, authBearer) async {
  final http.Response response = await http.post(
      Uri.parse('$baseUri${ApiConstants.transferToOtherDrivers}'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": 'Bearer $authBearer'
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
    required String riderPhoneNumber,
    required int? driverId,
    required String? driverPhoto,
    required String? driverPhone,
    required String? vehicleName,
    required String? vehiclePlateNumber,
    required String? vehicleColour,
    required String? pickUpLocation,
    required String? destinationLocation,
    required int fare,
    required List pickupLocationPosition,
    required List dropoffLocationPostion}) async {
  DateTime now = DateTime.now();

  // Format the current time with timezone
  String formattedTime = DateFormat('HH:mm').format(now);

  // Get the timezone offset
  Duration offset = now.timeZoneOffset;

  // Calculate the GMT offset in hours and minutes
  int hours = offset.inHours;
  int minutes = offset.inMinutes.remainder(60).abs();

  // Format the GMT offset string
  String gmtOffset =
      'GMT ${hours >= 0 ? '+' : '-'}${hours.abs()}:${minutes.toString().padLeft(2, '0')}';
  print(gmtOffset);

  final http.Response response = await http.post(
      Uri.parse('$baseUri${ApiConstants.driverAcceptRideEndpoint}'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        'riderID': riderId,
        'riderPhoneNumber': riderPhoneNumber,
        'requestTime': formattedTime,
        'GMT': gmtOffset,
        'driverID': driverId,
        'driverPhoto': driverPhoto,
        'vehicleName': vehicleName,
        'vehiclePlateNumber': vehiclePlateNumber,
        'vehicleColour': vehicleColour,
        'driverPhone': driverPhone,
        'pickUpLocation': pickUpLocation,
        'destinationLocation': destinationLocation,
        'pickupLocationPosition': pickupLocationPosition,
        'dropoffLocationPosition': dropoffLocationPostion,
        'fare': fare,
      }));
  return response.statusCode;
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

Future driverGetCurrentRides(
    {required int driverID, required String authBearer}) async {
  final http.Response response = await http.get(
      Uri.parse(
          '$baseUri/$driverID${ApiConstants.driverGetCurrentRidesEndpoint}'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": 'Bearer $authBearer'
      });
  final data = await jsonDecode(response.body);
  return data;
}

//TODO ADD RETURN VALUE
Future onDriverCancelRide(
    {required int driverID,
    required int riderID,
    required String dbObjectID,
    required String authBearer}) async {
  final http.Response response = await http.post(
      Uri.parse('$baseUri/$driverID${ApiConstants.driverCancelRideEndpoint}'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": 'Bearer $authBearer'
      },
      body: json.encode({'riderID': riderID, 'objectID': dbObjectID}));
  final data = response.statusCode;
  return data;
}

Future onRideCompleted(
    {required int driverID,
    required int riderID,
    required String dbObjectID,
    required String authBearer}) async {
  final http.Response response = await http.post(
      Uri.parse('$baseUri${ApiConstants.driverOnRideCompleteEndpoint}'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": 'Bearer $authBearer'
      },
      body: json.encode(
          {'driverID': driverID, 'riderID': riderID, 'objectID': dbObjectID}));
  final data = response.statusCode;
  return data;
}

Future getRideHistory(
    {required int driverID, required String authBearer}) async {
  final http.Response response = await http
      .get(Uri.parse('$baseUri/$driverID/getDriverTripHistory'), headers: {
    "Content-Type": "application/json",
    "Authorization": 'Bearer $authBearer'
  });
  //final data = json.decode(response.body);
  //print(data);
  return response;
}

Future getDriverNotifications() async {
  final response = await http
      .get(Uri.parse('$baseUri${ApiConstants.getDriverNotificationsEndpoint}'));
  print(response.body);
  return response;
}

import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:waya_driver/constants/api_constants.dart';
import 'package:waya_driver/models/auth.dart';

//todo base uri value here
// var baseUri = 'http://192.168.100.43:3000';
// var baseUri = 'https://waya-api.onrender.com';
var baseUri = ApiConstants.baseUrl;

class SignInResponse {
  final Data? data;
  final int statusCode;
  final dynamic body;

  SignInResponse(this.data, this.statusCode, this.body);
}

Future signIn(
    {required String emailOrPhone,
    required String password,
    required String deviceID}) async {
  final http.Response response =
      await http.post(Uri.parse('$baseUri${ApiConstants.signInEndpoint}'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "password": password,
            "phoneNumber": emailOrPhone,
            "email": emailOrPhone,
            "deviceID": deviceID
          }));
  if (response.statusCode == 200) {
    final data = Data.fromJson(json.decode(response.body));
    return SignInResponse(data, response.statusCode, null);
  } else {
    return SignInResponse(null, response.statusCode, jsonDecode(response.body));
    //throw Exception('Login Failed');
  }
}

Future signUp(
    {required String firstname,
    required String lastname,
    required String password,
    required String phoneNumber,
    required String email,
    required String address,
    required dob,
    required String vehicleMake,
    required String vehicleModel,
    required String vehicleColour,
    required String vehicleBodytype,
    required vehicleYear,
    required vehiclePlateNumber,
    required profilePhoto,
    required driversLicense,
    required vehicleInsurance}) async {
  var formData =
      http.MultipartRequest('POST', Uri.parse('$baseUri/driversignup'));

  formData.fields['firstname'] = firstname;
  formData.fields['lastname'] = lastname;
  formData.fields['password'] = password;
  formData.fields['phoneNumber'] = phoneNumber;
  formData.fields['email'] = email;
  formData.fields['address'] = address;
  formData.fields['dob'] = dob;
  formData.fields['vehicleMake'] = vehicleMake;
  formData.fields['vehicleModel'] = vehicleModel;
  formData.fields['vehicleColour'] = vehicleColour;
  formData.fields['vehicleBodytype'] = vehicleBodytype;
  formData.fields['vehicleYear'] = vehicleYear;
  formData.fields['vehiclePlateNumber'] = vehiclePlateNumber;

  // Add profilePhoto as a file
  if (profilePhoto != null) {
    var profilePhotoFile =
        await http.MultipartFile.fromPath('profilePhoto', profilePhoto.path);
    formData.files.add(profilePhotoFile);
  }

  // Add driversLicense as a file
  if (driversLicense != null) {
    var driversLicenseFile = await http.MultipartFile.fromPath(
        'driversLicense', driversLicense.path);
    formData.files.add(driversLicenseFile);
  }

  // Add vehicleInsurance as a file
  if (vehicleInsurance != null) {
    var vehicleInsuranceFile = await http.MultipartFile.fromPath(
        'vehicleInsurance', vehicleInsurance.path);
    formData.files.add(vehicleInsuranceFile);
  }

  http.StreamedResponse response = await formData.send();

  if (response.statusCode == 200) {
    print('Data submitted successfully!');
    return 200;
  } else {
    print('Error submitting data.');
  }
}

Future logOut({required int id, required String authBearer}) async {
  final http.Response response = await http.post(
      Uri.parse('$baseUri${ApiConstants.logoutEndpoint}'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": 'Bearer $authBearer'
      },
      body: jsonEncode({"id": id}));
  if (response.statusCode == 200) {
    return 'logout success';
  } else {
    return 'logout failed';
  }
}

Future changePassword(
    {required int id,
    required String newPassword,
    required String oldPassword,
    required String authBearer}) async {
  final http.Response response = await http.post(
    Uri.parse('$baseUri${ApiConstants.changePasswordEndpoint}'),
    headers: {
      "Content-Type": "application/json",
      "Authorization": 'Bearer $authBearer'
    },
    body: jsonEncode({
      "driverId": id,
      "newPassword": newPassword,
      "oldPassword": oldPassword
    }),
  );
  return response;
}

Future forgotPassword({required String emailOrphoneNumber}) async {
  final http.Response response = await http.post(
    Uri.parse('$baseUri${ApiConstants.forgotPasswordEndpoint}'),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode(
        {"email": emailOrphoneNumber, "phoneNumber": emailOrphoneNumber}),
  );
  return response;
}

Future resetPasswordFromForgotPassword(
    {required String emailOrphoneNumber,
    required String userToken,
    required String newPassword}) async {
  final http.Response response = await http.post(
    Uri.parse('$baseUri${ApiConstants.verifyForgotPasswordChangeEndpoint}'),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "email": emailOrphoneNumber,
      "phoneNumber": emailOrphoneNumber,
      "userToken": userToken,
      "newPassword": newPassword
    }),
  );
  return response;
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:waya_driver/constants/api_constants.dart';
import 'package:waya_driver/models/auth.dart';

//todo base uri value here
// var baseUri = 'http://192.168.100.43:3000';
var baseUri = 'https://waya-api.onrender.com';

class SignInResponse {
  final Data? data;
  final int statusCode;
  final dynamic body;

  SignInResponse(this.data, this.statusCode, this.body);
}

Future signIn(emailOrPhone, password, deviceID) async {
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
    {required firstname,
    required lastname,
    required password,
    required phoneNumber,
    required email,
    required address,
    required dob,
    required vehicleMake,
    required vehicleModel,
    required vehicleColour,
    required vehicleBodytype,
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

Future logOut(id) async {
  final http.Response response = await http.post(
      Uri.parse('$baseUri${ApiConstants.logoutEndpoint}'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"id": id}));
  if (response.statusCode == 200) {
    return 'logout success';
  } else {
    return 'logout failed';
  }
}

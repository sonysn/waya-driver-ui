class Data {
  final String authToken;
  final int id;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String email;
  final String address;
  final String? profilePhoto;
  final double rating;
  final int verified;
  //final String workAddress;
  final double accountBalance;

  Data(
      {required this.authToken,
      required this.id,
      required this.firstName,
      required this.lastName,
      required this.phoneNumber,
      required this.email,
      required this.address,
      required this.profilePhoto,
      required this.rating,
      required this.verified,
      //required this.workAddress,
      required this.accountBalance});

  factory Data.fromJson(Map<String, dynamic> json) {
    //print(json['result'][0]['ID']);
    return Data(
        authToken: json['token'],
        id: json['result'][0]['ID'],
        firstName: json['result'][0]['FIRST_NAME'],
        lastName: json['result'][0]['LAST_NAME'],
        phoneNumber: json['result'][0]['PHONE_NUMBER'],
        email: json['result'][0]['EMAIL'],
        address: json['result'][0]['EMAIL'],
        profilePhoto: json['result'][0]['PROFILE_PHOTO'],
        rating: double.parse(json['result'][0]['RATING'].toString()),
        verified: json['result'][0]['VERIFIED'],
        //workAddress: json['result'][0]['WORK_ADDRESS'],
        accountBalance:
            double.parse(json['result'][0]['ACCOUNT_BALANCE'].toString()));
  }
}

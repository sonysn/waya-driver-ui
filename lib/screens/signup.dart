import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:waya_driver/api/auth.dart';
import 'package:waya_driver/screens/loginpage.dart';
import '/colorscheme.dart';
import '/screens/bottom_nav.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class SignUp extends StatefulWidget {
  String phoneNumber;

  SignUp({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  dynamic _serverResponse() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await signUp(
          firstname.text,
          lastname.text,
          password.text,
          widget.phoneNumber,
          email.text,
          homeAddress.text,
          dateController.text,
          _image,
          _licenseFile,
          _permitFile);
      if (response == 200) {
        setState(() {
          _isLoading = false;
        });
        _nav();
      }
    } on SocketException catch (e) {
      print(e);
      _showSnackBar(
          'Connection failed. Please check your internet connection.');
    } on TimeoutException catch (e) {
      print(e);
      _showSnackBar('Request timed out. Please try again later.');
    } catch (e) {
      print(e);
    }
  }

  void _showSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _nav() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  Future getVehicleData() async {
    final http.Response response =
        await http.get(Uri.parse('https://car-makers.onrender.com'));
    final data = await jsonDecode(response.body);
    //print(data[0]['MAKE']);
    print(data[0]['MODELS'][0]);
    for (int i = 0; i < data.length; i++) {
      print(data[i]['MAKE']);
      setState(() {
        vehicleMakeItemList.add(data[i]['MAKE']);
        //vehicleModelItemListAllFromServer.addAll(data[i]['MODELS']);
      });
    }
  }

  Color getColorFromName(String colorName) {
    switch (colorName) {
      case 'Red':
        return Colors.red;
      case 'Blue':
        return Colors.blue;
      case 'Green':
        return Colors.green;
      case 'Yellow':
        return Colors.yellow;
      case 'Orange':
        return Colors.orange;
      case 'Purple':
        return Colors.purple;
      case 'Pink':
        return Colors.pink;
      case 'Black':
        return Colors.black;
      case 'White':
        return Colors.white;
      case 'Gray':
        return Colors.grey;
      case 'Brown':
        return Colors.brown;
      case 'Lime':
        return Colors.lime;
      case 'Teal':
        return Colors.teal;
      case 'Cyan':
        return Colors.cyan;
      default:
        return Colors.black;
    }
  }

  //Todo Text editing controller holds the user input for program execution, the names are self explanatory of what they do or hold
  TextEditingController firstname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController homeAddress = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController vehicleYear = TextEditingController();
  TextEditingController vehiclePlateNumber = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';
  String? selectedModel;
  String? selectedMake;
  String? selectedColor;
  String? selectedBodyType;
  List<String> vehicleMakeItemList = [];
  int? vehicleMakePositioninListArray;
  List<String> vehicleModelItemListAllFromServer = [];
  //List<String> vehicleModelItemList = [];
  List<String> vehicleColorList = [
    'Red',
    'Blue',
    'Green',
    'Yellow',
    'Orange',
    'Purple',
    'Pink',
    'Black',
    'White',
    'Gray',
    'Brown',
    'Lime',
    'Teal',
    'Cyan',
  ];
  List<String> vehicleBodyTypes = [
    "Sedan",
    "Coupe",
    "SUV",
    "Hatchback",
    "Convertible",
    "Wagon",
    "Minivan",
    "Pickup Truck",
    "Van"
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getVehicleData();
  }

  @override
  void dispose() {
    firstname.dispose();
    lastname.dispose();
    phoneNumber.dispose();
    password.dispose();
    email.dispose();
    homeAddress.dispose();
    dateController.dispose();
    vehicleYear.dispose();
    vehiclePlateNumber.dispose();
    super.dispose();
  }

  //PICK PROFILE IMAGE
  File? _image;
  final picker = ImagePicker();

  Future getImageFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  //PICK DOCUMENTS
  File? _licenseFile;
  File? _permitFile;

  Future<void> _pickLicenseFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      );

      if (result != null) {
        setState(() {
          _licenseFile = File(result.files.single.path!);
        });
      }
    } on PlatformException catch (e) {
      print("Error picking file: $e");
    }
  }

  Future<void> _pickPermitFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      );

      if (result != null) {
        setState(() {
          _permitFile = File(result.files.single.path!);
        });
      }
    } on PlatformException catch (e) {
      print("Error picking file: $e");
    }
  }

  //THEIR WIDGETS
  Widget _buildSelectedLicenseFile() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const Icon(Icons.attach_file),
          const SizedBox(width: 20.0),
          Expanded(
            child: Text(
              _licenseFile != null
                  ? path.basename(_licenseFile!.path)
                  : 'No file selected',
              style: const TextStyle(fontSize: 16.0),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          const SizedBox(width: 20.0),
          GestureDetector(
            onTap: () {
              setState(() {
                _licenseFile = null;
              });
            },
            child: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedPermitFile() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const Icon(Icons.attach_file),
          const SizedBox(width: 20.0),
          Expanded(
            child: Text(
              _permitFile != null
                  ? path.basename(_permitFile!.path)
                  : 'No file selected',
              style: const TextStyle(fontSize: 16.0),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          const SizedBox(width: 20.0),
          GestureDetector(
            onTap: () {
              setState(() {
                _permitFile = null;
              });
            },
            child: Icon(Icons.close),
          ),
        ],
      ),
    );
  }

  // Widget _buildSelectLicenseFileButton() {
  //   return ElevatedButton.icon(
  //     onPressed: _pickLicenseFile,
  //     icon: const Icon(Icons.attach_file),
  //     label: const Text('Select driver\'s license'),
  //   );
  // }

  // Widget _buildSelectPermitFileButton() {
  //   return ElevatedButton.icon(
  //     onPressed: _pickPermitFile,
  //     icon: const Icon(Icons.attach_file),
  //     label: const Text('Select Vehicle\'s Permit'),
  //   );
  // }

  //PICK DATE
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now());
    if (picked != null) {
      setState(() {
        dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: _isLoading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Center(
                        child: Image(
                      image: AssetImage("assets/icons/logo.png"),
                      width: 200.0,
                      height: 200.0,
                    )),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'We\'re Setting Up Your Profile...',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    LoadingAnimationWidget.waveDots(
                        color: Colors.black, size: 70)
                  ],
                ),
              )
            : ListView(
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 10),
                    margin: const EdgeInsets.symmetric(horizontal: 7),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 12, bottom: 10),
                          child: Text(
                            'Register',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 27,
                                color: Colors.black),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 12),
                          child: Text(
                            'Profile Picture',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black),
                          ),
                        ),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              CircleAvatar(
                                backgroundColor: Colors.black,
                                radius: 30,
                                backgroundImage:
                                    _image != null ? FileImage(_image!) : null,
                                child: _image == null
                                    ? const Icon(
                                        Icons.person,
                                        size: 30,
                                        color: Colors.white,
                                      )
                                    : null,
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                  onPressed: getImageFromCamera,
                                  style: ElevatedButton.styleFrom(
                                      primary: customPurple,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(20),
                                          bottom: Radius.circular(20),
                                        ),
                                      )),
                                  child: const Text('Take a picture')),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 12),
                          child: Text(
                            'First name',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black),
                          ),
                        ),
                        Container(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              children: [
                                //TextField for name
                                TextField(
                                  controller: firstname,
                                  cursorColor: customPurple,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                      errorText: _errorMessage.isNotEmpty
                                          ? _errorMessage
                                          : null,
                                      hintText: 'Enter your First Name',
                                      contentPadding: const EdgeInsets.all(15),
                                      enabledBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)),
                                        borderSide:
                                            BorderSide(color: Colors.black),
                                      ),
                                      filled: true,
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)),
                                        borderSide:
                                            BorderSide(color: Colors.yellow),
                                      )),
                                ),
                              ],
                            )),
                        const Padding(
                          padding: EdgeInsets.only(left: 12),
                          child: Text(
                            'Last Name',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black),
                          ),
                        ),
                        Container(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              children: [
                                //TextField for name
                                TextField(
                                  controller: lastname,
                                  cursorColor: customPurple,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                      errorText: _errorMessage.isNotEmpty
                                          ? _errorMessage
                                          : null,
                                      hintText: 'Enter your First Name',
                                      contentPadding: const EdgeInsets.all(15),
                                      enabledBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)),
                                        borderSide:
                                            BorderSide(color: Colors.black),
                                      ),
                                      filled: true,
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)),
                                        borderSide:
                                            BorderSide(color: Colors.yellow),
                                      )),
                                ),
                              ],
                            )),
                        const Padding(
                          padding: EdgeInsets.only(left: 12),
                          child: Text(
                            'Password',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black),
                          ),
                        ),
                        Container(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              children: [
                                //TextField for name
                                TextField(
                                  controller: password,
                                  cursorColor: customPurple,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                      errorText: _errorMessage.isNotEmpty
                                          ? _errorMessage
                                          : null,
                                      hintText: 'Enter your First Name',
                                      contentPadding: const EdgeInsets.all(15),
                                      enabledBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)),
                                        borderSide:
                                            BorderSide(color: Colors.black),
                                      ),
                                      filled: true,
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)),
                                        borderSide:
                                            BorderSide(color: Colors.yellow),
                                      )),
                                ),
                              ],
                            )),
                        const Padding(
                          padding: EdgeInsets.only(left: 12),
                          child: Text(
                            'Phone Number',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black),
                          ),
                        ),
                        Container(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              children: [
                                //TextField for name
                                TextField(
                                  controller: phoneNumber,
                                  readOnly: true,
                                  cursorColor: customPurple,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                      hintText: widget.phoneNumber,
                                      contentPadding: const EdgeInsets.all(15),
                                      enabledBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)),
                                        borderSide:
                                            BorderSide(color: Colors.black),
                                      ),
                                      filled: true,
                                      focusedBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)),
                                        borderSide:
                                            BorderSide(color: Colors.yellow),
                                      )),
                                ),
                              ],
                            )),
                        const Padding(
                          padding: EdgeInsets.only(left: 12),
                          child: Text(
                            'Email',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black),
                          ),
                        ),
                        Container(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              children: [
                                //TextField for name
                                TextField(
                                  controller: email,
                                  cursorColor: customPurple,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                      errorText: _errorMessage.isNotEmpty
                                          ? _errorMessage
                                          : null,
                                      hintText: 'Enter your Email',
                                      contentPadding: const EdgeInsets.all(15),
                                      enabledBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)),
                                        borderSide:
                                            BorderSide(color: Colors.black),
                                      ),
                                      filled: true,
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)),
                                        borderSide:
                                            BorderSide(color: Colors.yellow),
                                      )),
                                ),
                              ],
                            )),
                        const Padding(
                          padding: EdgeInsets.only(left: 12),
                          child: Text(
                            'DOB',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black),
                          ),
                        ),
                        Container(
                            padding: const EdgeInsets.all(12),
                            child: TextField(
                              cursorColor: Colors.black,
                              controller: dateController,
                              onTap: () {
                                _selectDate(context);
                              },
                              decoration: InputDecoration(
                                errorText: _errorMessage.isNotEmpty
                                    ? _errorMessage
                                    : null,
                                hintText: 'Select Date',
                                suffixIcon: const Icon(
                                  Icons.calendar_today,
                                  color: Colors.black,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.black,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                filled: true,
                                focusedBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                  borderSide: BorderSide(color: Colors.yellow),
                                ),
                              ),
                            )),
                        const Padding(
                          padding: EdgeInsets.only(left: 12),
                          child: Text(
                            'Address',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.black),
                                ),
                                child: TextFormField(
                                  controller: homeAddress,
                                  cursorColor: customPurple,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 3,
                                  // set maxLines to 2 for a double-line input
                                  decoration: InputDecoration(
                                    errorText: _errorMessage.isNotEmpty
                                        ? _errorMessage
                                        : null,
                                    hintText: 'Enter your Address',
                                    filled: true,
                                    contentPadding: const EdgeInsets.all(15),
                                    border: InputBorder.none,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your home address';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 10),
                        const Padding(
                          padding: EdgeInsets.only(left: 12),
                          child: Text(
                            'Vehicle Make',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Container(
                            //padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Stack(
                              children: [
                                IgnorePointer(
                                  ignoring: true,
                                  child: TextFormField(
                                    controller: TextEditingController(
                                        text: selectedMake),
                                    decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Vehicle Make',
                                        filled: true),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      borderRadius: BorderRadius.circular(10),
                                      icon: const Icon(Icons.arrow_drop_down),
                                      onChanged: (newValue) {
                                        // Handle dropdown value change here
                                        setState(() {
                                          selectedMake = newValue;
                                          vehicleMakePositioninListArray =
                                              vehicleMakeItemList
                                                  .indexOf(newValue!);
                                        });
                                        print(vehicleMakeItemList
                                            .indexOf(newValue!));

                                        Future getVehicleData2() async {
                                          final http.Response response =
                                              await http.get(Uri.parse(
                                                  'https://car-makers.onrender.com'));
                                          final data =
                                              await jsonDecode(response.body);
                                          //print(data[0]['MAKE']);
                                          print(data[0]['MODELS'][0]);
                                          vehicleModelItemListAllFromServer
                                              .clear();
                                          for (int i = 0;
                                              i <
                                                  data[vehicleMakePositioninListArray]
                                                          ['MODELS']
                                                      .length;
                                              i++) {
                                            setState(() {
                                              vehicleModelItemListAllFromServer
                                                  .add(data[
                                                          vehicleMakePositioninListArray]
                                                      ['MODELS'][i]);
                                            });
                                          }
                                        }

                                        getVehicleData2();
                                      },
                                      items: vehicleMakeItemList
                                          .map((String item) {
                                        return DropdownMenuItem<String>(
                                          value: item,
                                          child: Text(item),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),
                        const Padding(
                          padding: EdgeInsets.only(left: 12),
                          child: Text(
                            'Vehicle Model',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Container(
                            //padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Stack(
                              children: [
                                IgnorePointer(
                                  ignoring: true,
                                  child: TextFormField(
                                    controller: TextEditingController(
                                        text: selectedModel),
                                    decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Vehicle Model',
                                        filled: true),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      borderRadius: BorderRadius.circular(10),
                                      icon: const Icon(Icons.arrow_drop_down),
                                      onChanged: (newValue) {
                                        // Handle dropdown value change here
                                        setState(() {
                                          selectedModel = newValue;
                                        });
                                      },
                                      items: vehicleModelItemListAllFromServer
                                          .map((String item) {
                                        return DropdownMenuItem<String>(
                                          value: item,
                                          child: Text(item),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Padding(
                          padding: EdgeInsets.only(left: 12),
                          child: Text(
                            'Vehicle Colour',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Stack(
                              children: [
                                IgnorePointer(
                                  ignoring: true,
                                  child: TextFormField(
                                    controller: TextEditingController(
                                        text: selectedColor),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Vehicle Colour',
                                      filled: true,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      borderRadius: BorderRadius.circular(10),
                                      icon: const Icon(Icons.arrow_drop_down),
                                      onChanged: (newValue) {
                                        setState(() {
                                          selectedColor = newValue;
                                        });
                                      },
                                      items: vehicleColorList
                                          .map<DropdownMenuItem<String>>(
                                              (String item) {
                                        return DropdownMenuItem<String>(
                                          value: item,
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 20,
                                                height: 20,
                                                color: getColorFromName(item),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(item),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Padding(
                          padding: EdgeInsets.only(left: 12),
                          child: Text(
                            'Vehicle Body Type',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Container(
                            //padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Stack(
                              children: [
                                IgnorePointer(
                                  ignoring: true,
                                  child: TextFormField(
                                    controller: TextEditingController(
                                        text: selectedBodyType),
                                    decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Vehicle Body Type',
                                        filled: true),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      borderRadius: BorderRadius.circular(10),
                                      icon: const Icon(Icons.arrow_drop_down),
                                      onChanged: (newValue) {
                                        // Handle dropdown value change here
                                        setState(() {
                                          selectedBodyType = newValue;
                                        });
                                      },
                                      items:
                                          vehicleBodyTypes.map((String item) {
                                        return DropdownMenuItem<String>(
                                          value: item,
                                          child: Text(item),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Padding(
                          padding: EdgeInsets.only(left: 12),
                          child: Text(
                            'Vehicle Year',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black),
                          ),
                        ),
                        Container(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              children: [
                                //TextField for name
                                TextField(
                                  controller: vehicleYear,
                                  cursorColor: customPurple,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                      hintText: '2015',
                                      contentPadding: EdgeInsets.all(15),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)),
                                        borderSide:
                                            BorderSide(color: Colors.black),
                                      ),
                                      filled: true,
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)),
                                        borderSide:
                                            BorderSide(color: Colors.yellow),
                                      )),
                                ),
                              ],
                            )),
                        const SizedBox(height: 10),
                        const Padding(
                          padding: EdgeInsets.only(left: 12),
                          child: Text(
                            'Vehicle Plate Number',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black),
                          ),
                        ),
                        Container(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              children: [
                                //TextField for name
                                TextField(
                                  controller: vehiclePlateNumber,
                                  cursorColor: customPurple,
                                  keyboardType: TextInputType.text,
                                  decoration: const InputDecoration(
                                      hintText: 'YYY-YYY-YYY',
                                      contentPadding: EdgeInsets.all(15),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)),
                                        borderSide:
                                            BorderSide(color: Colors.black),
                                      ),
                                      filled: true,
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)),
                                        borderSide:
                                            BorderSide(color: Colors.yellow),
                                      )),
                                ),
                              ],
                            )),
                        const SizedBox(height: 10),
                        const Padding(
                          padding: EdgeInsets.only(left: 12),
                          child: Text(
                            'Driver\'s License',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(12),
                          child: GestureDetector(
                            onTap: () {
                              _pickLicenseFile();
                            },
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  _pickLicenseFile != null
                                      ? _buildSelectedLicenseFile()
                                      : Container(),
                                  const SizedBox(height: 20),
                                  //_buildSelectLicenseFileButton(),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Padding(
                          padding: EdgeInsets.only(left: 12),
                          child: Text(
                            'Vehicle\'s Permit',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(12),
                          child: GestureDetector(
                            onTap: () {
                              _pickPermitFile();
                            },
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  _pickPermitFile != null
                                      ? _buildSelectedPermitFile()
                                      : Container(),
                                  const SizedBox(height: 20),
                                  //_buildSelectPermitFileButton(),
                                ],
                              ),
                            ),
                          ),
                        ),
                        //sign up button
                        Center(
                          child: ElevatedButton(
                              onPressed: () {
                                // Navigator.push(context,
                                //     MaterialPageRoute(builder: (BuildContext context) {
                                //   return BottomNavPage();
                                // }));
                                if (firstname.text != '' &&
                                    lastname.text != '' &&
                                    password.text != '' &&
                                    email.text != '' &&
                                    homeAddress.text != '' &&
                                    dateController.text != '' &&
                                    _image != null &&
                                    _permitFile != null &&
                                    _licenseFile != null) {
                                  setState(() {
                                    _errorMessage = '';
                                  });
                                  _serverResponse();
                                } else {
                                  setState(() {
                                    _errorMessage = 'This field is required';
                                  });
                                }
                                // signUp(firstname.text, lastname.text, password.text, widget.phoneNumber, email.text, homeAddress.text, dateController.text, _image, _licenseFile, _permitFile);
                              },
                              style: ElevatedButton.styleFrom(
                                  primary: customPurple,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20),
                                      bottom: Radius.circular(20),
                                    ),
                                  )),
                              child: const SizedBox(
                                width: 260,
                                height: 50,
                                child: Center(child: Text('Sign Up')),
                              )),
                        ),
                        const SizedBox(height: 10)
                      ],
                    ),
                  )
                ],
              ));
  }
}

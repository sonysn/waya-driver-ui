import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/colorscheme.dart';
import '/screens/bottom_nav.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  //Todo Text editing controller holds the user input for program execution, the names are self explanatory of what they do or hold
  TextEditingController firstname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController phoneNumber = TextEditingController(text: 'phone');
  TextEditingController password = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController homeAddress = TextEditingController();


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
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Icon(Icons.attach_file),
          SizedBox(width: 20.0),
          Expanded(
            child: Text(
              _licenseFile != null ? path.basename(_licenseFile!.path) : 'No file selected',
              style: TextStyle(fontSize: 16.0),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          SizedBox(width: 20.0),
          GestureDetector(
            onTap: () {
              setState(() {
                _licenseFile = null;
              });
            },
            child: Icon(Icons.close),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedPermitFile() {
    return Container(
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Icon(Icons.attach_file),
          SizedBox(width: 20.0),
          Expanded(
            child: Text(
              _permitFile != null ? path.basename(_permitFile!.path) : 'No file selected',
              style: TextStyle(fontSize: 16.0),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          SizedBox(width: 20.0),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
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
                      radius: 30,
                      backgroundImage:
                          _image != null ? FileImage(_image!) : null,
                      child: _image == null
                          ? const Icon(
                              Icons.person,
                              size: 30,
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
                        decoration: const InputDecoration(
                            hintText: 'Enter your First Name',
                            contentPadding: EdgeInsets.all(15),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              borderSide: BorderSide(color: Colors.yellow),
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
                        decoration: const InputDecoration(
                            hintText: 'Enter your First Name',
                            contentPadding: EdgeInsets.all(15),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              borderSide: BorderSide(color: Colors.yellow),
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
                        decoration: const InputDecoration(
                            hintText: 'Enter your First Name',
                            contentPadding: EdgeInsets.all(15),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              borderSide: BorderSide(color: Colors.yellow),
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
                        decoration: const InputDecoration(
                            hintText: 'hint: Phone Number',
                            contentPadding: EdgeInsets.all(15),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              borderSide: BorderSide(color: Colors.yellow),
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
                        decoration: const InputDecoration(
                            hintText: 'Enter your First Name',
                            contentPadding: EdgeInsets.all(15),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              borderSide: BorderSide(color: Colors.yellow),
                            )),
                      ),
                    ],
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
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.black),
                      ),
                      child: TextFormField(
                        controller: homeAddress,
                        cursorColor: customPurple,
                        keyboardType: TextInputType.multiline,
                        maxLines: 3, // set maxLines to 2 for a double-line input
                        decoration: const InputDecoration(
                          hintText: 'Enter your Address',
                          filled: true,
                          contentPadding: EdgeInsets.all(15),
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
                  onTap: (){
                    _pickLicenseFile();
                  },
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        _pickLicenseFile != null ? _buildSelectedLicenseFile() : Container(),
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
                        _pickPermitFile != null ? _buildSelectedPermitFile() : Container(),
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
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return BottomNavPage();
                      }));
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

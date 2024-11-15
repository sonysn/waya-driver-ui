import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qunot_driver/api/auth.dart';
import 'package:qunot_driver/screens/bottom_nav.dart';
import 'package:qunot_driver/colorscheme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:qunot_driver/screens/forgotpassword.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // bool hasGetter(dynamic object, String getterName) {
  //   try {
  //     // Try to access the getter and check if it throws an exception
  //     object.noSuchMethod(Invocation.getter(Symbol(getterName)));
  //     return true;
  //   } catch (e) {
  //     return false;
  //   }
  // }

  dynamic _serverResponse() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await signIn(
          emailOrPhone: emailOrPhoneTextController.text,
          password: passwordTextController.text,
          deviceID: firebaseDeviceID!);

      if (response.statusCode == 200) {
        setState(() {
          _futureData = response.data;
        });
        if (_futureData != null) {
          setState(() {
            _isLoading = false;
          });
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setInt('driverID', _futureData.id);
          _nav();
        }
      } else {
        var msg = response.body;
        //print(msg['message']);
        _showSnackBar(msg['message']);
        setState(() {
          _isLoading = false;
        });
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
    } finally {}
  }

  void _showSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _nav() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return BottomNavPage(
        data: _futureData,
      );
    }));
  }

  TextEditingController emailOrPhoneTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  // late FirebaseMessaging _firebaseDeviceToken;
  String? firebaseDeviceID;
  bool val = false;
  bool _passwordVisible = false;
  bool _rememberMe = true;
  bool _isLoading = false;
  dynamic _futureData;

  @override
  void initState() {
    super.initState();
    _loadCredentials();
    FirebaseMessaging.instance.getToken().then((devToken) {
      setState(() {
        firebaseDeviceID = devToken;
      });
    });
  }

  @override
  void dispose() {
    emailOrPhoneTextController.dispose();
    passwordTextController.dispose();
    super.dispose();
  }

  void _loadCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? emailOrPhone = prefs.getString('emailOrPhone');
    String? password = prefs.getString('password');
    if (emailOrPhone != null && password != null) {
      emailOrPhoneTextController.text = emailOrPhone;
      passwordTextController.text = password;
      setState(() {
        _rememberMe = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
              color: Colors.black,
            ))
          : Container(
              padding: const EdgeInsets.only(top: 10),
              margin: const EdgeInsets.symmetric(horizontal: 7),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 12, bottom: 10),
                    child: Text(
                      'Welcome Back',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 27,
                          color: Colors.black),
                    ),
                  ),
                  Container(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          //TextField for name
                          TextField(
                            controller: emailOrPhoneTextController,
                            cursorColor: customPurple,
                            keyboardType: TextInputType.text,
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp(r'\s')),
                              // Disallow whitespace
                            ],
                            decoration: InputDecoration(
                              hintText: 'Email or Phone Number',
                              contentPadding: const EdgeInsets.all(15),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide:
                                    const BorderSide(color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                    color: Colors.orangeAccent),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              prefixIcon: const Icon(
                                Icons.account_circle_outlined,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      )),
                  Container(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        //TextField for name
                        TextFormField(
                          controller: passwordTextController,
                          cursorColor: customPurple,
                          keyboardType: TextInputType.text,
                          obscureText: !_passwordVisible,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            contentPadding: const EdgeInsets.all(15),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide:
                                  const BorderSide(color: Colors.orangeAccent),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: const Icon(
                              Icons.lock,
                              color: Colors.black87,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // CheckboxListTile(
                  //   title: const Text('Remember me'),
                  //   activeColor: Colors.black,
                  //   value: _rememberMe,
                  //   onChanged: (bool? value) {
                  //     setState(() {
                  //       _rememberMe = value!;
                  //     });
                  //   },
                  // ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // Navigate to the forgot password page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return const ForgotPasswordPage();
                            },
                          ),
                        );
                      },
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: ElevatedButton(
                        onPressed: () async {
                          //print(signIn(emailOrPhoneTextController.text, passwordTextController.text));
                          // Navigator.push(context,
                          //     MaterialPageRoute(builder: (BuildContext context) {
                          //   return const BottomNavPage();
                          // }));
                          if (emailOrPhoneTextController.text == '' ||
                              passwordTextController.text == '') {
                            _showSnackBar(
                              "Input your Login Details",
                            );
                          }
                          if (emailOrPhoneTextController.text != '' &&
                              passwordTextController.text != '') {
                            _serverResponse();
                            if (_rememberMe) {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.setString('emailOrPhone',
                                  emailOrPhoneTextController.text);
                              await prefs.setString(
                                  'password', passwordTextController.text);
                              await prefs.setString(
                                  'deviceID', firebaseDeviceID!);
                            }
                            //print(_futureData);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: customPurple,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20),
                                bottom: Radius.circular(20),
                              ),
                            )),
                        child: const SizedBox(
                          width: 260,
                          height: 50,
                          child: Center(child: Text('Sign In')),
                        )),
                  ),
                ],
              ),
            ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:waya_driver/api/auth.dart';
import '/screens/bottom_nav.dart';
import '../colorscheme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  dynamic _serverResponse() async {
    try {
      final response = await signIn(
          emailOrPhoneTextController.text, passwordTextController.text
      );
      setState(() {
        _futureData = response;
      });
      if (_futureData != null) {
        _nav();
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  void _nav() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) {
      return BottomNavPage(
        data: _futureData,
      );
    }));
  }

  TextEditingController emailOrPhoneTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  bool val = false;
  bool _passwordVisible = false;
  bool _rememberMe = false;
  bool _isLoading = false;
  dynamic _futureData;

  @override
  void initState() {
    super.initState();
    _loadCredentials();
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
      body: _isLoading ? const Center(child: CircularProgressIndicator()) :  Container(
        padding: const EdgeInsets.only(top: 10),
        margin: const EdgeInsets.symmetric(horizontal: 7),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 12, bottom: 10),
              child: Text(
                'Login to your account',
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
                      decoration: const InputDecoration(
                        hintText: 'Email or Phone',
                        contentPadding: EdgeInsets.all(15),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          borderSide: BorderSide(color: Colors.yellow),
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
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      filled: true,
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        borderSide: BorderSide(color: Colors.yellow),
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
            CheckboxListTile(
              title: const Text('Remember me'),
              activeColor: Colors.black,
              value: _rememberMe,
              onChanged: (bool? value) {
                setState(() {
                  _rememberMe = value!;
                });
              },
            ),
            Center(
              child: ElevatedButton(
                  onPressed: () async {
                    //print(signIn(emailOrPhoneTextController.text, passwordTextController.text));
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (BuildContext context) {
                    //   return const BottomNavPage();
                    // }));
                    _serverResponse();
                    if (_rememberMe) {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.setString(
                          'emailOrPhone', emailOrPhoneTextController.text);
                      await prefs.setString(
                          'password', passwordTextController.text);
                    }

                    print(_futureData);
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
                    child: Center(child: Text('Sign In')),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

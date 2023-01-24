import 'package:flutter/material.dart';
import 'package:waya_driver/api/authApi.dart';
import '/screens/bottom_nav.dart';
import '../colorscheme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  dynamic _serverResponse() async{
    try {
      final response = await signIn(emailOrPhoneTextController.text, passwordTextController.text);
      //print(res.email);
      setState(() {
        _futureData = response;
      });
      _nav();
    } catch(e){
      print(e);
    }
  }

  void _nav() {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) {
          return BottomNavPage(data: _futureData,);
        }));
  }

  TextEditingController emailOrPhoneTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  bool val = false;
  dynamic _futureData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                          )),
                    ),
                  ],
                )),
            Container(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    //TextField for name
                    TextField(
                      controller: passwordTextController,
                      cursorColor: customPurple,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                          hintText: 'Password',
                          contentPadding: EdgeInsets.all(15),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            borderSide: BorderSide(color: Colors.yellow),
                          )),
                    ),
                  ],
                )),
            Center(
              child: ElevatedButton(
                  onPressed: () {
                    //print(signIn(emailOrPhoneTextController.text, passwordTextController.text));
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (BuildContext context) {
                    //   return const BottomNavPage();
                    // }));
                    _serverResponse();
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

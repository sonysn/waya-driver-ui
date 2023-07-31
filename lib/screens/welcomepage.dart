import 'package:flutter/material.dart';
import 'package:qunot_driver/colorscheme.dart';
import 'package:qunot_driver/screens/loginpage.dart';
import 'package:qunot_driver/screens/verificationpage.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  TextEditingController phoneInput = TextEditingController();
  String dropdownValue = '+234';

  var items = ['+234', '+233', '+235'];

  @override
  void initState() {
    super.initState();
    //_checkLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: ListView(
          children: [
            Center(
              child: Container(
                //margin: const EdgeInsets.only(top: 350),
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 5),
                child: Column(
                  children: [
                    const Center(
                        child: Image(
                      image: AssetImage("assets/icons/logo.png"),
                      width: 200.0,
                      height: 200.0,
                    )),
                    const Text(
                      "QuNot Driver: Your Drive Begins",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 24, color: customPurple),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //drop down button for country codes
                        DropdownButton(
                            underline: Container(),
                            value: dropdownValue,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            items: items.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(items),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                dropdownValue = newValue!;
                              });
                            }),
                        SizedBox(
                          width: 200,
                          child: TextField(
                            controller: phoneInput,
                            keyboardType: TextInputType.number,
                            cursorColor: customPurple,
                            decoration: const InputDecoration(
                                hintText: "9049583746",
                                contentPadding: EdgeInsets.all(10),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: customPurple))),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: 250,
                      height: 45,
                      child: ElevatedButton(
                          onPressed: () {
                            print(dropdownValue + phoneInput.text);
                            Navigator.push(context, MaterialPageRoute(
                                builder: (BuildContext context) {
                              return VerificationPage(
                                  phoneNumber: dropdownValue + phoneInput.text);
                            }));
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: customPurple,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20),
                                  bottom: Radius.circular(20),
                                ),
                              )),
                          child: const Text("Get Started")),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: 250,
                      height: 45,
                      child: ElevatedButton(
                          onPressed: () {
                            //print(dropdownValue + phoneInput.text);
                            Navigator.push(context, MaterialPageRoute(
                                builder: (BuildContext context) {
                              return const LoginPage();
                            }));
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: customPurple,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20),
                                  bottom: Radius.circular(20),
                                ),
                              )),
                          child: const Text("Login")),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}

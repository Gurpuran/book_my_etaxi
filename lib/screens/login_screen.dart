import 'package:book_my_taxi/Utils/constant.dart';
import 'package:book_my_taxi/service/authentication.dart';
import 'package:book_my_taxi/service/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  bool showLoading = false;

  Widget CenterCircularWidget(){
    return Flexible(child: Row(
      children: [
        SizedBox(width: 150,),
        CircularProgressIndicator(color: Colors.blue,),
        SizedBox(width: 150,)
      ],
    ));
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                        child: Image.asset("assets/images/taxi_app_logo.png")),
                  )),
              Expanded(
                  flex: 5,
                  child: Container(
                      child: Image.asset(
                          "assets/images/login_screen_image.png"))),
              Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Take a comfortable & safe ",
                              style:
                              TextStyle(fontSize: 18, color: Colors.deepPurple),
                            ),
                            Row(
                              children: const [
                                Text(
                                  " travel with ",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.deepPurple),
                                ),
                                Text(
                                  "BOOK MY ETAXI",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.deepPurple,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        showLoading ? CenterCircularWidget() : Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pushNamed(
                                    "/phoneNumberSetup");
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black),
                              child: const Text("Continue with Phone Number"),
                            ),
                            ElevatedButton.icon(
                              onPressed: () async {
                                setState(() {
                                  showLoading = true;
                                });
                                User? result = await doGmailLogin();
                                if (result != null) {
                                  List<String> values = await readData();
                                  if(values.contains(result.uid)){
                                    Navigator.of(context).pushNamed("/homeScreen");
                                  }
                                  else{
                                    addUserToDatabase(result.uid.toString());
                                    Navigator.of(context)
                                        .pushNamed("/registrationScreen");
                                  }
                                } else {
                                  context.showErrorSnackBar(
                                      message:
                                      "There is some error while LogIn. Please try again later");
                                }
                                setState(() {
                                  showLoading = false;
                                });
                              },
                              icon: const Icon(
                                Icons.mail_rounded,
                                color: Colors.red,
                              ),
                              label: const Text(
                                "Google",
                                style: TextStyle(color: Colors.black),
                              ),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Expanded(
                          flex: 1,
                          child: Text(
                            "By continuing, you agree that you have read and accept our T&C and Privacy Policy.",
                            style: TextStyle(
                                fontSize: 14, color: Colors.black54),
                          ),
                        ),
                      ],
                    ),
                  ))
            ],
          )),
    );
  }
}

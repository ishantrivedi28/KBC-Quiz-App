import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_builder.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:kbc/screen/home.dart';
import 'package:kbc/services/auth.dart';
import 'package:kbc/services/internetcon.dart';
import 'package:overlay_support/overlay_support.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    InternetConnectionChecker().onStatusChange.listen((status) {
      final connected = status == InternetConnectionStatus.connected;
      showSimpleNotification(
          Text(
              connected ? "CONNECTED TO INTERNET" : "NOT CONECTED TO INTERNET"),
          background: connected ? Colors.green : Colors.red);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple,
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/img/kbc.png'),
          const SizedBox(
            height: 10,
          ),
          const Text(
            "Welcome\nTo KBC Quiz App",
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 12,
          ),
          SignInButton(Buttons.GoogleDark, onPressed: () async {
            await signWithGoogle();
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return Home();
            }));
          }),
          const SizedBox(height: 10),
          const Text(
            "By Continuing, You Are Agree With Our TnC",
            style: TextStyle(color: Colors.white),
          )
        ],
      )),
    );
  }
}

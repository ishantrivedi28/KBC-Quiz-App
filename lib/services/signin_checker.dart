import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kbc/screen/home.dart';
import 'package:kbc/screen/login.dart';

class CheckSignin {
  static signinChecker() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          return Home();
        } else
          return Login();
      }),
    );
  }
}

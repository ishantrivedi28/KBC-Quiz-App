import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kbc/screen/about_us.dart';
import 'package:kbc/screen/facts_page.dart';
import 'package:kbc/screen/login.dart';
import 'package:kbc/screen/loser.dart';
import 'package:kbc/screen/mystery.dart';
import 'package:kbc/screen/profile.dart';
import 'package:kbc/screen/question.dart';
import 'package:kbc/screen/win.dart';
import 'package:kbc/services/localdb.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'screen/home.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'KBC Quiz',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isLogin = false;

  getLoggedinState() async {
    await LocalDB.getuserID().then((value) {
      setState(() {
        isLogin = value.toString() != "null";
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLoggedinState();
  }

  @override
  Widget build(BuildContext context) {
    return isLogin ? const Home() : const Login();
  }
}

import 'package:flutter/material.dart';

class Fifty50 extends StatefulWidget {
  String opt1;
  String opt2;
  String opt3;
  String opt4;
  String correctAnswer;
  Fifty50({
    required this.correctAnswer,
    required this.opt1,
    required this.opt2,
    required this.opt3,
    required this.opt4,
  });
  @override
  State<Fifty50> createState() => _Fifty50State();
}

class _Fifty50State extends State<Fifty50> {
  late String wrongOpt1;
  late String wrongOpt2;
  List WrongOptions = [];
  fetchWrongOptions() {
    setState(() {
      if (widget.opt1 != widget.correctAnswer) {
        WrongOptions.add(widget.opt1);
      }
      if (widget.opt2 != widget.correctAnswer) {
        WrongOptions.add(widget.opt2);
      }
      if (widget.opt3 != widget.correctAnswer) {
        WrongOptions.add(widget.opt3);
      }
      if (widget.opt4 != widget.correctAnswer) {
        WrongOptions.add(widget.opt4);
      }
      WrongOptions.shuffle();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    fetchWrongOptions();
    super.initState();
    Future.delayed(Duration(seconds: 10), (() {
      if (this.mounted) Navigator.pop(context);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple,
      body: Center(
        child: Container(
          decoration: BoxDecoration(
              color: Colors.purpleAccent,
              borderRadius: BorderRadius.circular(20)),
          margin: EdgeInsets.symmetric(horizontal: 30, vertical: 200),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              "FIFTY FIFTY LIFELINE",
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "${WrongOptions[0]} AND ${WrongOptions[1]} ARE INCORRECT OPTIONS",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
              textAlign: TextAlign.center,
            ),
            Text(
              "You Will Be Automatically Redirected to Quiz Screen in 10 Seconds",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color.fromARGB(255, 37, 29, 29)),
              textAlign: TextAlign.center,
            ),
          ]),
        ),
      ),
    );
  }
}

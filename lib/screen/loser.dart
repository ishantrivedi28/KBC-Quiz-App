import 'package:flutter/material.dart';

class Looser extends StatelessWidget {
  String wonMon;
  String correctAns;

  Looser({required this.wonMon, required this.correctAns});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/img/loose.png"), fit: BoxFit.cover)),
        child: Scaffold(
          // floatingActionButton: ElevatedButton(
          //   child: Text("Retry"),
          //   onPressed: () {},
          // ),
          backgroundColor: Colors.transparent,
          body: Center(
            child: Container(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Oh Sorry!",
                      style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const Text(
                      "YOUR ANSWER IS INCORRECT",
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                    Text(
                      "CORRECT ANSWER IS $correctAns",
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    const Text(
                      "You Won",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Colors.white),
                    ),
                    Text(
                      "Rs. ${int.parse(wonMon) == 2500 ? 0 : wonMon}",
                      style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Icon(Icons.error_outline, size: 100, color: Colors.white),
                    ElevatedButton(
                      child: Text("Go to Rewards",
                          style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}

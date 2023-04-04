import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:kbc/screen/question.dart';
import 'package:kbc/services/questionModel.dart';

class Win extends StatefulWidget {
  String queMoney;
  String quizID;
  Win(this.queMoney, this.quizID);

  @override
  State<Win> createState() => _WinState();
}

class _WinState extends State<Win> {
  late ConfettiController confettiController;

  playWinMusic() async {
    final player = AudioPlayer();

    await player.play(AssetSource("audio_effects/CORRECT.mp3"));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // playWinMusic();
    setState(() {
      initController();
    });
    confettiController.play();
  }

  void initController() {
    confettiController =
        ConfettiController(duration: const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WillPopScope(
          onWillPop: () async => false,
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/img/win.png"),
                    fit: BoxFit.cover)),
            child: Scaffold(
              floatingActionButton: ElevatedButton(
                child: Text("Share with Friends"),
                onPressed: () {},
              ),
              backgroundColor: Colors.transparent,
              body: Container(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "CONGRATULATIONS!",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        "YOUR ANSWER IS CORRECT",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      const Text(
                        "You Won",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w400),
                      ),
                      Text(
                        "Rs. ${widget.queMoney}",
                        style: TextStyle(
                            fontSize: 35, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Container(
                          margin: EdgeInsets.all(10),
                          child: Image.asset("assets/img/cheque.jpg")),
                      ElevatedButton(
                        child: Text("Next"),
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Question(
                                        queMoney:
                                            (int.parse(widget.queMoney) * 2)
                                                .toString(),
                                        quizID: widget.quizID,
                                      )));
                        },
                      ),
                    ]),
              ),
            ),
          ),
        ),
        builConfettiWidget(confettiController, pi / 2)
      ],
    );
  }

  Align builConfettiWidget(controller, double blastDirection) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConfettiWidget(
        maximumSize: Size(40, 30),
        shouldLoop: false,
        confettiController: controller,
        blastDirection: blastDirection,
        blastDirectionality: BlastDirectionality.explosive,
        maxBlastForce: 30,
        minBlastForce: 8,
        emissionFrequency: 0.02,
        numberOfParticles: 20,
        gravity: 0.8,
      ),
    );
  }
}

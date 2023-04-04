import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:kbc/screen/question.dart';
import 'package:kbc/services/localdb.dart';
import 'package:kbc/services/quizDhandha.dart';
import 'package:kbc/services/quizquecreator.dart';

import '../services/checkQuizUnlock.dart';

class QuizIntro extends StatefulWidget {
  String quizName;
  String quizImgUrl;
  String quizTopics;
  String quizDuration;
  String quizAbout;
  String quizid;
  String quizMoney;
  QuizIntro(
      {required this.quizAbout,
      required this.quizDuration,
      required this.quizImgUrl,
      required this.quizName,
      required this.quizTopics,
      required this.quizid,
      required this.quizMoney});

  @override
  State<QuizIntro> createState() => _QuizIntroState();
}

bool quizIsUnlocked = false;

class _QuizIntroState extends State<QuizIntro> {
  Future getQuizUnlock() async {
    await CheckQuizUnlock.checkQuizUnlockStatus(widget.quizid)
        .then((quizUnlockstatus) {
      setState(() {
        quizIsUnlocked = quizUnlockstatus;
      });
    });
  }

  setLifeLAvail() async {
    print("inside aud poll");
    await LocalDB.saveAud(true);
    await LocalDB.saveExp(true);
    await LocalDB.saveFifty(true);
    await LocalDB.saveJok(true);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                Question(quizID: widget.quizid, queMoney: "5000")));
  }

  // player() async {
  //   final player = AudioPlayer();

  //   await player.play(
  //     AssetSource("audio_effects/QUESTION.mp3"),
  //   );
  // }

  introMusic() async {
    final player = AudioPlayer();
    await player.play(AssetSource("audio_effects/KBC_INTRO.mp3"));
  }

  @override
  void initState() {
    // TODO: implement initState

    getQuizUnlock();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ElevatedButton(
        child: Text(quizIsUnlocked ? "Start Quiz" : "Unlock Quiz",
            style: TextStyle(fontSize: 20)),
        onPressed: () {
          quizIsUnlocked
              ? widget.quizName == 'Bollywood Quiz'
                  ? ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          "This is quiz is under development! Play General Knowledge Quiz")))
                  : setLifeLAvail()
              : QuizDhandha.buyQuiz(
                      quizId: widget.quizid,
                      QuizPrice: int.parse(widget.quizMoney))
                  .then((value) {
                  if (value) {
                    setState(() {
                      quizIsUnlocked = true;
                    });
                  } else {
                    showDialog(
                        context: context,
                        builder: ((context) => AlertDialog(
                              title: Text(
                                  "You don't have enough money to buy this quiz!"),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("OK"))
                              ],
                            )));
                  }
                });
        },
      ),
      appBar: AppBar(title: Text("KBC Quiz App")),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(bottom: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.quizName,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.w500),
                      )
                    ],
                  )),
              Image.network(
                widget.quizImgUrl,
                fit: BoxFit.cover,
                height: 230,
                width: MediaQuery.of(context).size.width,
              ),
              Container(
                padding: EdgeInsets.all(18),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.topic_outlined),
                          SizedBox(
                            width: 6,
                          ),
                          Text(
                            "Related to-:",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      Text(
                        widget.quizTopics,
                        style: TextStyle(fontSize: 20),
                      )
                    ]),
              ),
              Container(
                padding: EdgeInsets.all(18),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.timer),
                          SizedBox(
                            width: 6,
                          ),
                          Text(
                            "Duration-",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      Text(
                        "${widget.quizDuration} Minutes",
                        style: TextStyle(fontSize: 20),
                      )
                    ]),
              ),
              quizIsUnlocked
                  ? Container()
                  : Container(
                      padding: EdgeInsets.all(18),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.money),
                                SizedBox(
                                  width: 6,
                                ),
                                Text(
                                  "Money-",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            Text(
                              "Rs. ${widget.quizMoney}",
                              style: TextStyle(fontSize: 20),
                            )
                          ]),
                    ),
              Container(
                padding: EdgeInsets.all(18),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.topic_outlined),
                          SizedBox(
                            width: 6,
                          ),
                          Text(
                            "About Quiz",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      Text(
                        widget.quizAbout,
                        style: TextStyle(fontSize: 20),
                      )
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

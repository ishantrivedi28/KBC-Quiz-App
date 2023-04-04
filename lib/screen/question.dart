import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kbc/screen/loser.dart';
import 'package:kbc/screen/win.dart';
import 'package:kbc/services/questionModel.dart';
import 'package:kbc/widgets/lifeline_sidebar.dart';
import 'package:audioplayers/audioplayers.dart';
import '../services/firedb.dart';
import '../services/quizquecreator.dart';

class Question extends StatefulWidget {
  String quizID;
  String queMoney;

  Question({required this.quizID, required this.queMoney});
  @override
  State<Question> createState() => _QuestionState();
}

class _QuestionState extends State<Question> {
  QuesModel questionModel = new QuesModel();
  genQue() async {
    await QuizQueCreator.genQuizQue(widget.quizID, widget.queMoney)
        .then((quesData) {
      setState(() {
        questionModel.question = quesData["question"];
        questionModel.correctAnswer = quesData["correctAnswer"];
        questionModel.AnswerYTLinkID = quesData["AnswerYTLinkID"];
        print(widget.queMoney);

        List options = [
          quesData["opt1"],
          quesData["opt2"],
          quesData["opt3"],
          quesData["opt4"],
        ];
        options.shuffle();
        questionModel.opt1 = options[0];
        questionModel.opt2 = options[1];
        questionModel.opt3 = options[2];
        questionModel.opt4 = options[3];
      });
    });
  }

  bool optALocked = false;

  bool optBLocked = false;

  bool optCLocked = false;

  bool optDLocked = false;

  int maxSeconds = 30;
  int seconds = 30;
  Timer? timer;

  quesTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        seconds--;
      });
      if (seconds == 0) {
        timer?.cancel();
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => Looser(
                    wonMon: widget.queMoney.toString() == 5000
                        ? 0.toString()
                        : (int.parse(widget.queMoney) ~/ 2).toString(),
                    correctAns: questionModel.correctAnswer)));
      }
    });
  }

  final player1 = AudioPlayer();

  playIntroMusic() async {
    if (widget.queMoney != 5000) {
      final player = AudioPlayer();

      await player.play(AssetSource("audio_effects/QUESTION.mp3"));
      print("done done");
    }
  }

  playLooserMusic() async {
    final player = AudioPlayer();

    await player.play(AssetSource("audio_effects/WRONG_ANSWER.mp3"));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    genQue();
    playIntroMusic();
    quesTimer();
  }

  stopMyTimerbyDrawer() {
    timer?.cancel();
  }

  @override
  void dispose() {
    timer?.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image:
              DecorationImage(image: AssetImage('assets/img/background.png'))),
      child: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          floatingActionButton: ElevatedButton(
            child: Text(
              "Quit Game",
              style: TextStyle(fontSize: 27),
            ),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("DO YOU WANT TO QUIT THE GAME?"),
                      content: Text(
                          "You will get Rs. ${widget.queMoney == "5000" ? 0 : int.parse(widget.queMoney) / 2}"),
                      actions: [
                        ElevatedButton(
                            onPressed: () async {
                              await updateMoney(widget.queMoney == 5000
                                  ? 0
                                  : int.parse(widget.queMoney) ~/ 2);
                              timer?.cancel();
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            child: Text("Quit")),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("Cancel"))
                      ],
                    );
                  });
            },
          ),
          backgroundColor: Colors.transparent,
          appBar: AppBar(
              centerTitle: true,
              title: Text(
                "Rs. ${widget.queMoney}",
                style: TextStyle(fontSize: 25),
              )),
          onDrawerChanged: (isOpened) {
            isOpened ? stopMyTimerbyDrawer() : quesTimer();
          },
          drawer: Lifeline_Drawer(
            quizID: widget.quizID,
            quesMon: widget.queMoney,
            YTurl: questionModel.AnswerYTLinkID,
            question: questionModel.question,
            opt1: questionModel.opt1,
            opt2: questionModel.opt2,
            opt3: questionModel.opt3,
            opt4: questionModel.opt4,
            correctAns: questionModel.correctAnswer,
          ),
          body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 100,
                  width: 100,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CircularProgressIndicator(
                        value: seconds / maxSeconds,
                        strokeWidth: 12,
                        backgroundColor: Colors.yellow,
                      ),
                      Center(
                          child: Text(
                        seconds.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 45,
                          fontWeight: FontWeight.bold,
                        ),
                      ))
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.all(14),
                  margin: EdgeInsets.all(17),
                  child: Text(
                    questionModel.question,
                    style: TextStyle(
                      fontSize: 24,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                ),
                SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    print("double tap to lock the answer");
                  },
                  onLongPress: () async {
                    await player1
                        .play(AssetSource("audio_effects/LOCK_OPT_SHORT.mp3"));
                    timer?.cancel();
                    setState(() {
                      optALocked = true;
                    });
                    Future.delayed(Duration(seconds: 3), () async {
                      if (questionModel.correctAnswer == questionModel.opt1) {
                        print("badhai ho yrr");
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: ((context) =>
                                    Win(widget.queMoney, widget.quizID))));
                      } else {
                        print("bada dukh hua dekh kr ");
                        await updateMoney((int.parse(widget.queMoney) ~/ 2));
                        playLooserMusic();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: ((context) => Looser(
                                  wonMon: (int.parse(widget.queMoney) ~/ 2)
                                      .toString(),
                                  correctAns: questionModel.correctAnswer,
                                )),
                          ),
                        );
                      }
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(14),
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 17, vertical: 5),
                    child: Text(
                      "A. ${questionModel.opt1}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    decoration: BoxDecoration(
                        color: optALocked
                            ? Colors.yellow.withOpacity(0.4)
                            : Colors.white.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(35)),
                  ),
                ),
                InkWell(
                  onTap: () {
                    print("double tap to lock the answer");
                  },
                  onLongPress: () async {
                    await player1
                        .play(AssetSource("audio_effects/LOCK_OPT_SHORT.mp3"));
                    timer?.cancel();
                    setState(() {
                      optBLocked = true;
                    });
                    Future.delayed(Duration(seconds: 3), () async {
                      if (questionModel.correctAnswer == questionModel.opt2) {
                        print("badhai ho yrr");
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: ((context) =>
                                    Win(widget.queMoney, widget.quizID))));
                      } else {
                        print("bada dukh hua dekh kr ");
                        await updateMoney((int.parse(widget.queMoney) ~/ 2));
                        playLooserMusic();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: ((context) => Looser(
                                  wonMon: (int.parse(widget.queMoney) ~/ 2)
                                      .toString(),
                                  correctAns: questionModel.correctAnswer,
                                )),
                          ),
                        );
                      }
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(14),
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 17, vertical: 5),
                    child: Text(
                      "B. ${questionModel.opt2}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    decoration: BoxDecoration(
                        color: optBLocked
                            ? Colors.yellow.withOpacity(0.4)
                            : Colors.white.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(35)),
                  ),
                ),
                InkWell(
                  onTap: () {
                    print("double tap to lock the answer");
                  },
                  onLongPress: () async {
                    await player1
                        .play(AssetSource("audio_effects/LOCK_OPT_SHORT.mp3"));
                    timer?.cancel();
                    setState(() {
                      optCLocked = true;
                    });
                    Future.delayed(Duration(seconds: 3), () async {
                      if (questionModel.correctAnswer == questionModel.opt3) {
                        print("badhai ho yrr");
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: ((context) =>
                                    Win(widget.queMoney, widget.quizID))));
                      } else {
                        print("bada dukh hua dekh kr ");
                        await updateMoney((int.parse(widget.queMoney) ~/ 2));
                        playLooserMusic();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: ((context) => Looser(
                                  wonMon: (int.parse(widget.queMoney) ~/ 2)
                                      .toString(),
                                  correctAns: questionModel.correctAnswer,
                                )),
                          ),
                        );
                      }
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(14),
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 17, vertical: 5),
                    child: Text(
                      "C. ${questionModel.opt3}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    decoration: BoxDecoration(
                        color: optCLocked
                            ? Colors.yellow.withOpacity(0.4)
                            : Colors.white.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(35)),
                  ),
                ),
                InkWell(
                  onTap: () {
                    print("double tap to lock the answer");
                  },
                  onLongPress: () async {
                    await player1
                        .play(AssetSource("audio_effects/LOCK_OPT_SHORT.mp3"));
                    timer?.cancel();
                    setState(() {
                      optDLocked = true;
                    });
                    Future.delayed(Duration(seconds: 3), () async {
                      if (questionModel.correctAnswer == questionModel.opt4) {
                        print("badhai ho yrr");
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: ((context) =>
                                    Win(widget.queMoney, widget.quizID))));
                      } else {
                        print("bada dukh hua dekh kr ");
                        await updateMoney((int.parse(widget.queMoney) ~/ 2));
                        playLooserMusic();

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: ((context) => Looser(
                                  wonMon: (int.parse(widget.queMoney) ~/ 2)
                                      .toString(),
                                  correctAns: questionModel.correctAnswer,
                                )),
                          ),
                        );
                      }
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(14),
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 17, vertical: 5),
                    child: Text(
                      "D. ${questionModel.opt4}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    decoration: BoxDecoration(
                        color: optDLocked
                            ? Colors.yellow.withOpacity(0.4)
                            : Colors.white.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(35)),
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}

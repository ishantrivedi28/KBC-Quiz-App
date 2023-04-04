import 'package:flutter/material.dart';
import 'package:kbc/screen/askTheExpert.dart';
import 'dart:math';

import 'package:kbc/screen/audiencePoll.dart';
import 'package:kbc/screen/fifty50.dart';
import 'package:kbc/screen/question.dart';

import '../services/localdb.dart';

class Lifeline_Drawer extends StatefulWidget {
  String question;
  String opt1;
  String opt2;
  String opt3;
  String opt4;
  String correctAns;
  String quizID;
  String quesMon;
  String YTurl;
  Lifeline_Drawer(
      {required this.correctAns,
      required this.YTurl,
      required this.opt1,
      required this.opt2,
      required this.opt3,
      required this.opt4,
      required this.quesMon,
      required this.question,
      required this.quizID});

  @override
  State<Lifeline_Drawer> createState() => _Lifeline_DrawerState();
}

class _Lifeline_DrawerState extends State<Lifeline_Drawer> {
  Future<bool> checkAudAvail() async {
    bool AudAvail = true;

    await LocalDB.getAud().then((value) {
      AudAvail = value!;
    });
    return AudAvail;
  }

  Future<bool> checkJok() async {
    bool JokAvail = true;

    await LocalDB.getJok().then((value) {
      JokAvail = value!;
    });
    return JokAvail;
  }

  Future<bool> checkFifty() async {
    bool FiftyAvail = true;

    await LocalDB.getFifty().then((value) {
      FiftyAvail = value!;
    });
    return FiftyAvail;
  }

  Future<bool> checkExp() async {
    bool ExpAvail = true;

    await LocalDB.getExp().then((value) {
      ExpAvail = value!;
    });
    return ExpAvail;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 12),
              child: Text(
                "LifeLine",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: (() async {
                    if (await checkAudAvail()) {
                      await LocalDB.saveAud(false);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AudiencePoll(
                                  question: widget.question,
                                  opt1: widget.opt1,
                                  opt2: widget.opt2,
                                  opt3: widget.opt3,
                                  opt4: widget.opt4,
                                  correctAnswer: widget.correctAns)));
                    } else {
                      print("already user");
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Lifeline alraedy Used!")));
                    }
                  }),
                  child: Column(
                    children: [
                      Card(
                        elevation: 12,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32)),
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.purpleAccent),
                          child: Icon(
                            Icons.people,
                            size: 32,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Audience\n Poll",
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () async {
                    if (await checkJok()) {
                      await LocalDB.saveJok(false);

                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Question(
                                  quizID: widget.quizID,
                                  queMoney: widget.quesMon)));
                    } else {
                      print("joker already used");
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Lifeline alraedy Used!")));
                    }
                  },
                  child: Column(
                    children: [
                      Card(
                        elevation: 12,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32)),
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.purpleAccent),
                          child: Icon(
                            Icons.restart_alt_rounded,
                            size: 32,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Joker\n Question",
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () async {
                    if (await checkFifty()) {
                      LocalDB.saveFifty(false);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Fifty50(
                                  correctAnswer: widget.correctAns,
                                  opt1: widget.opt1,
                                  opt2: widget.opt2,
                                  opt3: widget.opt3,
                                  opt4: widget.opt4)));
                    } else {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Lifeline alraedy Used!")));
                    }
                  },
                  child: Column(
                    children: [
                      Card(
                        elevation: 12,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32)),
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.purpleAccent),
                          child: Icon(
                            Icons.star_half,
                            size: 32,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Fifty\n50",
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: (() async {
                    if (await checkExp()) {
                      LocalDB.saveExp(false);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ExpAdvice(
                                  YTurl: widget.YTurl,
                                  question: widget.question)));
                    } else {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Lifeline alraedy Used!")));
                    }
                  }),
                  child: Column(
                    children: [
                      Card(
                        elevation: 12,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32)),
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.purpleAccent),
                          child: Icon(
                            Icons.computer,
                            size: 32,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Expert\n Advice",
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Divider(
              color: Colors.black12,
              thickness: 1,
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 12),
              child: Text(
                "PRIZES",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            //   height: 600,
            Expanded(
              child: ListView.builder(
                  reverse: true,
                  itemCount: 12,
                  itemBuilder: (context, index) {
                    if ((2500) * (pow(2, index + 1)) ==
                        int.parse(widget.quesMon)) {
                      return ListTile(
                        leading: Text(
                          "${index + 1}.",
                          style: TextStyle(color: Colors.white),
                        ),
                        tileColor: Colors.deepPurpleAccent,
                        title: Text(
                          "Rs.${(2500) * (pow(2, index + 1))}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white),
                        ),
                        trailing:
                            Icon(Icons.circle, color: Colors.purpleAccent),
                      );
                    } else {
                      return ListTile(
                        leading: Text(
                          "${index + 1}.",
                          style: TextStyle(),
                        ),
                        title: Text(
                          "Rs.${(2500) * (pow(2, index + 1))}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        trailing: Icon(Icons.circle),
                      );
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

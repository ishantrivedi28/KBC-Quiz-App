import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

class QuizQueCreator {
  static Future<Map> genQuizQue(String quizID, String queMoney) async {
    late Map queData;
    await FirebaseFirestore.instance
        .collection("quizzes")
        .doc(quizID)
        .collection("questions")
        .where("money", isEqualTo: queMoney)
        .get()
        .then((value) {
      //TO DO: TASK GENERATE A RANDOM NUMBER BETWEEN TO VALUE.DOCS.LENGTH
      int random = Random().nextInt(value.docs.length);
      queData = value.docs.elementAt(random).data();
    });
    print(queData);
    return queData;
  }
}

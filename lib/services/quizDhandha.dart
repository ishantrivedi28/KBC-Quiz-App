import 'package:cloud_firestore/cloud_firestore.dart';

import 'localdb.dart';

class QuizDhandha {
  static Future<bool> buyQuiz(
      {required int QuizPrice, required String quizId}) async {
    String user_id = "";
    user_id = (await LocalDB.getuserID())!;
    bool paisaHaiKya = false;
    var balance;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user_id)
        .get()
        .then((user) {
      balance = user.data()!["money"];
      paisaHaiKya = QuizPrice <= balance;
    });
    if (paisaHaiKya) {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user_id)
          .collection("unlocked_quiz")
          .doc(quizId)
          .set({"unlocked_at": DateTime.now()});

      await FirebaseFirestore.instance
          .collection("users")
          .doc(user_id)
          .update({"money": (balance - QuizPrice).toInt()});
      await LocalDB.saveMoney(((balance) - QuizPrice).toString());
      return true;
    } else
      print("paisa kamao bsdk");
    return false;
  }
}

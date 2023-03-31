import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'localdb.dart';

class FireDB {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  createNewUser(String name, String email, String photoUrl, String uid) async {
    final User? current_user = _auth.currentUser;
    if (await getUser(uid))
      print("User already exists");
    else {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(current_user!.uid)
          .set({
        "name": name,
        "email": email,
        "photoUrl": photoUrl,
        "money": "0",
        "rank": "NA",
        "level": "0",
        "uid": uid
      }).then((value) async {
        await LocalDB.saveMoney("0");
        await LocalDB.saveLevel("0");
        await LocalDB.saveRank("NA");
        print("Succesfully Registered");
      });
    }
  }
}

updateMoney(int amount) async {
  if (amount != 2500) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(_auth.currentUser!.uid)
        .get()
        .then((value) async {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .update({
        "money": (int.parse((value.data()!["money"])) + amount).toString()
      });
      await LocalDB.saveMoney(
          (int.parse((value.data()!["money"])) + amount).toString());
    });
  }
}

fetchRank() async {
  String uid = await FirebaseAuth.instance.currentUser!.uid;
  int count = 1;
  await FirebaseFirestore.instance
      .collection("users")
      .orderBy("money")
      .get()
      .then((value) {
    value.docs.forEach((element) async {
      if (uid == element.data()["uid"]) {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(uid)
            .update({"rank": count.toString()});
        await LocalDB.saveRank(count.toString());
        print("rank is $count");
      } else
        count++;
    });
  });
}

Future<bool> getUser(String uid) async {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final User? current_user = _auth.currentUser;
  String user = "";
  var z;
  await FirebaseFirestore.instance
      .collection("users")
      .where("uid", isEqualTo: uid)
      .get()
      .then((value) {
    value.docs.forEach((element) {
      z = (element.id.toString());
    });
  });
  print(z);

  if (z.toString() == "null")
    return false;
  else {
    print("hello");
    await FirebaseFirestore.instance
        .collection("users")
        .doc(current_user!.uid)
        .get()
        .then((value) async {
      user = value.data().toString();
      await LocalDB.saveMoney(value["money"]);
      await LocalDB.saveLevel(value["level"]);
      await LocalDB.saveRank(value["rank"]);
    });

    return true;
  }
}

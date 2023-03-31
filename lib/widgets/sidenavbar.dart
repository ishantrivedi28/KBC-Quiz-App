import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kbc/screen/home.dart';
import 'package:kbc/screen/login.dart';
import 'package:kbc/screen/profile.dart';
import 'package:kbc/services/auth.dart';
import 'package:kbc/services/localdb.dart';

class SideNav extends StatelessWidget {
  String name;
  String money;
  String rank;
  String url;
  String level;
  String uid;
  SideNav(
      {required this.name,
      required this.money,
      required this.rank,
      required this.url,
      required this.level,
      required this.uid});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: Colors.deepPurple,
        child: ListView(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Profile(
                    name: name,
                    rank: rank,
                    proUrl: url,
                    money: money,
                    level: level,
                  );
                  ;
                }));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(url),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Rs. $money",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Center(
                    child: Container(
                      padding: EdgeInsets.only(left: 25),
                      child: Text(
                        "Leaderboard: Rank #${rank}",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 19),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 24,
            ),
            Divider(
              thickness: 1,
              indent: 10,
              endIndent: 10,
            ),
            SizedBox(
              height: 24,
            ),
            listItem(
              context: context,
              path: MaterialPageRoute(builder: (context) {
                return Home();
              }),
              label: "DAILY QUIZ",
              icon: Icons.quiz,
            ),
            listItem(
              context: context,
              path: MaterialPageRoute(builder: (context) {
                return Home();
              }),
              label: "Leaderboard",
              icon: Icons.leaderboard,
            ),
            listItem(
              context: context,
              path: MaterialPageRoute(builder: (context) {
                return Home();
              }),
              label: "How to Use",
              icon: Icons.question_answer,
            ),
            listItem(
              context: context,
              path: MaterialPageRoute(builder: (context) {
                return Home();
              }),
              label: "About Us",
              icon: Icons.face,
            ),
            listItemS(
              context: context,
              path: MaterialPageRoute(builder: (context) {
                return Login();
              }),
              label: "Sign Out",
              icon: Icons.logout_outlined,
            ),
          ],
        ),
      ),
    );
  }

  Widget listItemS({
    required String label,
    required IconData icon,
    required BuildContext context,
    required MaterialPageRoute path,
  }) {
    final color = Colors.white;
    final hovercolor = Colors.white60;

    return ListTile(
      leading: Icon(
        icon,
        color: color,
      ),
      hoverColor: hovercolor,
      title: Text(
        label,
        style: TextStyle(color: color),
      ),
      onTap: () async {
        await signOut();
        Navigator.pushReplacement(context, path);
      },
    );
  }

  Widget listItem({
    required String label,
    required IconData icon,
    required BuildContext context,
    required MaterialPageRoute path,
  }) {
    final color = Colors.white;
    final hovercolor = Colors.white60;

    return ListTile(
      leading: Icon(
        icon,
        color: color,
      ),
      hoverColor: hovercolor,
      title: Text(
        label,
        style: TextStyle(color: color),
      ),
      onTap: () {
        // QuerySnapshot? x;
        // print(uid);
        // var z;
        // await FirebaseFirestore.instance
        //     .collection("users")
        //     .where("uid", isEqualTo: uid)
        //     .get()
        //     .then((value) {
        //   value.docs.forEach((element) {
        //     z = (element.id.toString());
        //   });
        // });
        // print(z);

        // Navigator.pushReplacement(context, path);
      },
    );
  }
}

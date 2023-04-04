import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class Profile extends StatefulWidget {
  String name;
  String proUrl;
  String rank;
  String level;
  String money;
  Profile(
      {required this.name,
      required this.proUrl,
      required this.rank,
      required this.level,
      required this.money});
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  List leader = [];

  getLeaders() async {
    await FirebaseFirestore.instance
        .collection("users")
        .orderBy("money", descending: true)
        .get()
        .then((value) {
      setState(() {
        leader = value.docs.toList();
      });
    });
  }

  String k_m_b_generator(int num) {
    if (num > 999 && num < 99999) {
      return "${(num / 1000).toStringAsFixed(1)} K";
    } else if (num > 99999 && num < 999999) {
      return "${(num / 1000).toStringAsFixed(0)} K";
    } else if (num > 999999 && num < 999999999) {
      return "${(num / 1000000).toStringAsFixed(1)} M";
    } else if (num > 999999999) {
      return "${(num / 1000000000).toStringAsFixed(1)} B";
    } else {
      return num.toString();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLeaders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.share)),
          IconButton(onPressed: () {}, icon: Icon(Icons.person_add)),
        ],
        title: Text(
          "Profile",
          style: TextStyle(fontSize: 29),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 250,
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(widget.proUrl),
                        radius: 45,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.white),
                          child: Icon(
                            Icons.edit,
                            color: Colors.deepPurple,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "${widget.name}\nRs.${k_m_b_generator(int.parse(widget.money)).toString()}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Divider(
                    thickness: 1,
                    indent: 20,
                    endIndent: 20,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                            "#${widget.rank}",
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          ),
                          Text(
                            "Rank",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Leaderboard",
              style: TextStyle(fontSize: 20),
            ),
            Column(
              children: [
                Container(
                  height: 280,
                  margin: EdgeInsets.all(5),
                  child: ListView.separated(
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(
                                    leader[index].data()["photoUrl"]),
                              ),
                              SizedBox(
                                width: 6,
                              ),
                              Text(leader[index].data()["name"]),
                            ],
                          ),
                          leading: Text(
                            "#${index + 1}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          trailing: Text(
                            "Rs. ${k_m_b_generator(int.parse(leader[index].data()["money"].toString()))}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return Divider(
                          thickness: 1,
                          color: Colors.purple,
                          endIndent: 10,
                          indent: 10,
                        );
                      },
                      itemCount: leader.length),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

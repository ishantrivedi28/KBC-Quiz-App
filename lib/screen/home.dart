import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kbc/screen/about_us.dart';
import 'package:kbc/screen/home_widgets.dart';
import 'package:kbc/screen/mystery.dart';
import 'package:kbc/screen/quizintro.dart';
import 'package:kbc/services/firedb.dart';
import 'package:kbc/widgets/sidenavbar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/home_fire.dart';
import '../services/localdb.dart';
import 'facts_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String name = "user name";
  String money = "--";
  String lead = "--";
  String url = "";
  String level = "";
  String uid = "";
  List<Map<String, dynamic>> quizzes = [];
  var loading = false;
  bool isLoading = true;

  Future<void> getUserdetails() async {
    await LocalDB.getName().then((value) {
      setState(() {
        name = value.toString();
      });
    });
    await LocalDB.getMoney().then((value) {
      setState(() {
        money = value.toString();
      });
    });
    await LocalDB.getuserID().then((value) {
      setState(() {
        uid = value.toString();
      });
    });
    await LocalDB.getRank().then((value) {
      setState(() {
        lead = value.toString();
      });
    });
    await LocalDB.getUrl().then((value) {
      setState(() {
        url = value.toString();
      });
    });
    await LocalDB.getLevel().then((value) {
      setState(() {
        level = value.toString();
      });
    });
  }

  Future<void> getquiz() async {
    setState(() {
      loading = true;
    });
    await HomeFire.getQuizzes().then((returned_quizzes) {
      setState(() {
        quizzes = returned_quizzes;
        loading = false;
        isLoading = false;
      });
    });
  }

  var topMan;

  launchEmail() async {
    final url =
        'mailto:ishtri7@gmail.com?subject=${Uri.encodeFull('Report Problem on KBC App')}&body=${Uri.encodeFull('This App Has the following bugs please fix it!')}';
    // if (await canLaunchUrl(Uri.parse(url))) {
    launchUrl(Uri.parse(url));
    // }
  }

  getTopPlayer() async {
    setState(() {
      isLoading = true;
    });
    await FirebaseFirestore.instance
        .collection("users")
        .orderBy("money", descending: true)
        .get()
        .then((value) {
      setState(() {
        topMan = value.docs.elementAt(0).data();
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    fetchRank();
    getUserdetails();
    getquiz();
    getTopPlayer();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Scaffold(
            body: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "KBC QUIZ APP",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40.0, vertical: 20),
                  child: LinearProgressIndicator(),
                )
              ],
            )),
          )
        : RefreshIndicator(
            onRefresh: () async {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Home()));
            },
            child: Scaffold(
                appBar: AppBar(
                  title: Text('KBC - Quiz Game'),
                ),
                // onDrawerChanged: ((isOpened) {
                //   setState(() {
                //     print("set");
                //   });
                // }),
                drawer: SideNav(
                  name: name,
                  url: url,
                  level: level,
                  rank: lead,
                  money: money,
                  uid: uid,
                ),
                body: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Column(
                      children: [
                        CarouselSlider(
                            items: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return QuizIntro(
                                      quizAbout: (quizzes[1])["about_quiz"],
                                      quizDuration: (quizzes[1])["duration"],
                                      quizImgUrl:
                                          (quizzes[1])["quiz_thumbnail"],
                                      quizName: (quizzes[1])["quiz_name"],
                                      quizTopics: (quizzes[1])["topics"],
                                      quizid: (quizzes[1]["Quizid"]),
                                      quizMoney: (quizzes[1]["unlock_money"]),
                                    );
                                  }));
                                },
                                child: Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                "https://images.unsplash.com/photo-1593061231114-1798846fd643?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80",
                                              ),
                                              fit: BoxFit.cover)),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 13, vertical: 13),
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: Colors.deepPurple,
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              topRight: Radius.circular(20))),
                                      child: Text(
                                        "General Knowledge",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return QuizIntro(
                                      quizAbout: (quizzes[0])["about_quiz"],
                                      quizDuration: (quizzes[0])["duration"],
                                      quizImgUrl:
                                          (quizzes[0])["quiz_thumbnail"],
                                      quizName: (quizzes[0])["quiz_name"],
                                      quizTopics: (quizzes[0])["topics"],
                                      quizid: (quizzes[0]["Quizid"]),
                                      quizMoney: (quizzes[0]["unlock_money"]),
                                    );
                                  }));
                                },
                                child: Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                "https://img.buzzfeed.com/buzzfeed-static/static/2017-10/25/2/asset/buzzfeed-prod-fastlane-01/sub-buzz-8543-1508911289-3.jpg?downsize=700%3A%2A&output-quality=auto&output-format=auto",
                                              ),
                                              fit: BoxFit.cover)),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.black.withOpacity(0.3)),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 13, vertical: 13),
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: Colors.deepPurple,
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              topRight: Radius.circular(20))),
                                      child: Text(
                                        "Bollywood Quiz",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  await launchEmail();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              'https://images.unsplash.com/photo-1596524430615-b46475ddff6e?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80'),
                                          fit: BoxFit.cover)),
                                ),
                              )
                            ],
                            options: CarouselOptions(
                                height: 180,
                                enlargeCenterPage: true,
                                autoPlay: true,
                                aspectRatio: 16 / 9,
                                autoPlayCurve: Curves.fastOutSlowIn,
                                enableInfiniteScroll: true,
                                autoPlayAnimationDuration:
                                    Duration(milliseconds: 800),
                                viewportFraction: 0.8)),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CircularIcons(
                                  'https://img.freepik.com/free-photo/businesswoman-standing-thinking-near-big-question-mark-isolated-white-background_126523-3114.jpg?w=900&t=st=1680160566~exp=1680161166~hmac=f4dcb6ba9d455ccb2780a15e9570afcd74cc96e3144c7606bbdda74ad8e57ce4',
                                  'Facts', () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return FactsPage();
                                }));
                              }),
                              CircularIcons(
                                  'https://img.freepik.com/free-vector/mysterious-gangster-character_23-2148473800.jpg?w=740&t=st=1680160609~exp=1680161209~hmac=310b3e38794376ea41ba2affd0db10d370154d46afd0e7d24e13ce059436697d',
                                  'Mystery', () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return MysteryPage();
                                }));
                              }),
                              CircularIcons(
                                  'https://img.freepik.com/free-psd/3d-illustration-person-with-sunglasses_23-2149436188.jpg?w=740&t=st=1680160752~exp=1680161352~hmac=649e3604f59ad0ac606bf1212d78e8f4aa16e0b6b948a1f2084cf782c3d23260',
                                  'About Us', () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return AboutUs();
                                }));
                              })
                            ],
                          ),
                        ),
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: quizzes.length,
                          itemBuilder: (context, index) {
                            return quizBox(
                              (quizzes[index])["quiz_thumbnail"],
                              (quizzes[index])["quiz_name"],
                              () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return QuizIntro(
                                    quizAbout: (quizzes[index])["about_quiz"],
                                    quizDuration: (quizzes[index])["duration"],
                                    quizImgUrl:
                                        (quizzes[index])["quiz_thumbnail"],
                                    quizName: (quizzes[index])["quiz_name"],
                                    quizTopics: (quizzes[index])["topics"],
                                    quizid: (quizzes[index]["Quizid"]),
                                    quizMoney: (quizzes[index]["unlock_money"]),
                                  );
                                }));
                              },
                              double.parse(
                                  (quizzes[index])["thumbnail_opacity"]),
                            );
                          },
                        ),
                        // Container(
                        //   padding:
                        //       EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        //   child: Row(
                        //     children: [
                        //       Flexible(
                        //           flex: 1,
                        //           fit: FlexFit.tight,
                        //           child: Stack(
                        //             children: [
                        //               Card(
                        //                 elevation: 8,
                        //                 child: Container(
                        //                   height: 150,
                        //                   child: Image.network(
                        //                     "https://images.unsplash.com/photo-1632931612792-fbaacfd952f6?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1332&q=80",
                        //                     fit: BoxFit.cover,
                        //                   ),
                        //                 ),
                        //               ),
                        //             ],
                        //           )),
                        //       SizedBox(width: 10),
                        //       Flexible(
                        //           flex: 1,
                        //           fit: FlexFit.tight,
                        //           child: Stack(
                        //             children: [
                        //               Card(
                        //                 elevation: 8,
                        //                 child: Container(
                        //                   height: 150,
                        //                   child: Image.network(
                        //                       "https://images.unsplash.com/photo-1632931612792-fbaacfd952f6?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1332&q=80",
                        //                       fit: BoxFit.cover),
                        //                 ),
                        //               ),
                        //             ],
                        //           ))
                        //     ],
                        //   ),
                        // ),
                        // Container(
                        //   padding:
                        //       EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        //   child: Row(
                        //     children: [
                        //       Flexible(
                        //           flex: 1,
                        //           fit: FlexFit.tight,
                        //           child: Stack(
                        //             children: [
                        //               Card(
                        //                 elevation: 8,
                        //                 child: Container(
                        //                   height: 150,
                        //                   child: Image.network(
                        //                     "https://images.unsplash.com/photo-1632931612792-fbaacfd952f6?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1332&q=80",
                        //                     fit: BoxFit.cover,
                        //                   ),
                        //                 ),
                        //               ),
                        //             ],
                        //           )),
                        //       SizedBox(width: 10),
                        //       Flexible(
                        //           flex: 1,
                        //           fit: FlexFit.tight,
                        //           child: Stack(
                        //             children: [
                        //               Card(
                        //                 elevation: 8,
                        //                 child: Container(
                        //                   height: 150,
                        //                   child: Image.network(
                        //                       "https://images.unsplash.com/photo-1632931612792-fbaacfd952f6?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1332&q=80",
                        //                       fit: BoxFit.cover),
                        //                 ),
                        //               ),
                        //             ],
                        //           ))
                        //     ],
                        //   ),
                        // ),
                        //single    // Container(
                        //   padding: EdgeInsets.symmetric(horizontal: 12),
                        //   child: Stack(
                        //     children: [
                        //       Card(
                        //         elevation: 8,
                        //         child: Container(
                        //           width: MediaQuery.of(context).size.width,
                        //           height: 100,
                        //           child: Image.network(
                        //               "https://images.unsplash.com/photo-1632931612792-fbaacfd952f6?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1332&q=80",
                        //               fit: BoxFit.cover),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),

                        Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Top Player In This Week",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        backgroundImage:
                                            NetworkImage(topMan["photoUrl"]),
                                        radius: 50,
                                      ),
                                      SizedBox(
                                        width: 50,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            topMan["name"],
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text("Rs. ${topMan["money"]}",
                                              style: TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold))
                                        ],
                                      )
                                    ],
                                  )
                                ])),

                        ////if added more features and quizzes then use this design
                        // Container(
                        //   padding: EdgeInsets.all(15),
                        //   child: Column(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: [
                        //       Text(
                        //         "Unlock New Quizzes",
                        //         style: TextStyle(
                        //             fontSize: 19, fontWeight: FontWeight.w600),
                        //         textAlign: TextAlign.left,
                        //       ),
                        //       Container(
                        //         padding: EdgeInsets.symmetric(vertical: 5),
                        //         child: Row(
                        //           children: [
                        //             Flexible(
                        //                 flex: 1,
                        //                 fit: FlexFit.tight,
                        //                 child: InkWell(
                        //                   onTap: () {
                        //                     Navigator.push(context,
                        //                         MaterialPageRoute(
                        //                             builder: (context) {
                        //                       return QuizIntro(
                        //                         quizAbout:
                        //                             (quizzes[1])["about_quiz"],
                        //                         quizDuration:
                        //                             (quizzes[1])["duration"],
                        //                         quizImgUrl: (quizzes[1])[
                        //                             "quiz_thumbnail"],
                        //                         quizName:
                        //                             (quizzes[1])["quiz_name"],
                        //                         quizTopics:
                        //                             (quizzes[1])["topics"],
                        //                         quizid: (quizzes[1]["Quizid"]),
                        //                         quizMoney: (quizzes[1]
                        //                             ["unlock_money"]),
                        //                       );
                        //                     }));
                        //                   },
                        //                   child: Stack(
                        //                     children: [
                        //                       Card(
                        //                         elevation: 8,
                        //                         child: Container(
                        //                           height: 150,
                        //                           child: Image.network(
                        //                             loading
                        //                                 ? "https://images.unsplash.com/photo-1607434472257-d9f8e57a643d?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1172&q=80"
                        //                                 : (quizzes[0])[
                        //                                     "quiz_thumbnail"],
                        //                             fit: BoxFit.cover,
                        //                           ),
                        //                         ),
                        //                       ),
                        //                     ],
                        //                   ),
                        //                 )),
                        //             SizedBox(width: 10),
                        //             Flexible(
                        //                 flex: 1,
                        //                 fit: FlexFit.tight,
                        //                 child: Stack(
                        //                   children: [
                        //                     Card(
                        //                       elevation: 8,
                        //                       child: Container(
                        //                         height: 150,
                        //                         child: Image.network(
                        //                             "https://images.unsplash.com/photo-1632931612792-fbaacfd952f6?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1332&q=80",
                        //                             fit: BoxFit.cover),
                        //                       ),
                        //                     ),
                        //                   ],
                        //                 ))
                        //           ],
                        //         ),
                        //       ),
                        //       Container(
                        //         padding: EdgeInsets.symmetric(vertical: 5),
                        //         child: Row(
                        //           children: [
                        //             Flexible(
                        //                 flex: 1,
                        //                 fit: FlexFit.tight,
                        //                 child: Stack(
                        //                   children: [
                        //                     Card(
                        //                       elevation: 8,
                        //                       child: Container(
                        //                         height: 150,
                        //                         child: Image.network(
                        //                           "https://images.unsplash.com/photo-1632931612792-fbaacfd952f6?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1332&q=80",
                        //                           fit: BoxFit.cover,
                        //                         ),
                        //                       ),
                        //                     ),
                        //                   ],
                        //                 )),
                        //             SizedBox(width: 10),
                        //             Flexible(
                        //                 flex: 1,
                        //                 fit: FlexFit.tight,
                        //                 child: Stack(
                        //                   children: [
                        //                     Card(
                        //                       elevation: 8,
                        //                       child: Container(
                        //                         height: 150,
                        //                         child: Image.network(
                        //                             "https://images.unsplash.com/photo-1632931612792-fbaacfd952f6?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1332&q=80",
                        //                             fit: BoxFit.cover),
                        //                       ),
                        //                     ),
                        //                   ],
                        //                 ))
                        //           ],
                        //         ),
                        //       ),
                        //       Container(
                        //         padding: EdgeInsets.symmetric(vertical: 5),
                        //         child: Row(
                        //           children: [
                        //             Flexible(
                        //                 flex: 1,
                        //                 fit: FlexFit.tight,
                        //                 child: Stack(
                        //                   children: [
                        //                     Card(
                        //                       elevation: 8,
                        //                       child: Container(
                        //                         height: 150,
                        //                         child: Image.network(
                        //                           "https://images.unsplash.com/photo-1632931612792-fbaacfd952f6?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1332&q=80",
                        //                           fit: BoxFit.cover,
                        //                         ),
                        //                       ),
                        //                     ),
                        //                   ],
                        //                 )),
                        //             SizedBox(width: 10),
                        //             Flexible(
                        //                 flex: 1,
                        //                 fit: FlexFit.tight,
                        //                 child: Stack(
                        //                   children: [
                        //                     Card(
                        //                       elevation: 8,
                        //                       child: Container(
                        //                         height: 150,
                        //                         child: Image.network(
                        //                             "https://images.unsplash.com/photo-1632931612792-fbaacfd952f6?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1332&q=80",
                        //                             fit: BoxFit.cover),
                        //                       ),
                        //                     ),
                        //                   ],
                        //                 ))
                        //           ],
                        //         ),
                        //       ),
                        //       Container(
                        //         padding: EdgeInsets.symmetric(vertical: 5),
                        //         child: Row(
                        //           children: [
                        //             Flexible(
                        //                 flex: 1,
                        //                 fit: FlexFit.tight,
                        //                 child: Stack(
                        //                   children: [
                        //                     Card(
                        //                       elevation: 8,
                        //                       child: Container(
                        //                         height: 150,
                        //                         child: Image.network(
                        //                           "https://images.unsplash.com/photo-1632931612792-fbaacfd952f6?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1332&q=80",
                        //                           fit: BoxFit.cover,
                        //                         ),
                        //                       ),
                        //                     ),
                        //                   ],
                        //                 )),
                        //             SizedBox(width: 10),
                        //             Flexible(
                        //                 flex: 1,
                        //                 fit: FlexFit.tight,
                        //                 child: Stack(
                        //                   children: [
                        //                     Card(
                        //                       elevation: 8,
                        //                       child: Container(
                        //                         height: 150,
                        //                         child: Image.network(
                        //                             "https://images.unsplash.com/photo-1632931612792-fbaacfd952f6?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1332&q=80",
                        //                             fit: BoxFit.cover),
                        //                       ),
                        //                     ),
                        //                   ],
                        //                 ))
                        //           ],
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // Container(
                        //   padding: EdgeInsets.symmetric(horizontal: 12),
                        //   child: Stack(
                        //     children: [
                        //       Card(
                        //         elevation: 8,
                        //         child: Container(
                        //           width: MediaQuery.of(context).size.width,
                        //           height: 100,
                        //           child: Image.network(
                        //               "https://images.unsplash.com/photo-1632931612792-fbaacfd952f6?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1332&q=80",
                        //               fit: BoxFit.cover),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // SizedBox(
                        //   height: 30,
                        // ),
                        // CarouselSlider(
                        //     items: [
                        //       Container(
                        //         margin: EdgeInsets.symmetric(horizontal: 10),
                        //         decoration: BoxDecoration(
                        //             image: DecorationImage(
                        //                 image: NetworkImage(
                        //                   "https://images.unsplash.com/photo-1632931612792-fbaacfd952f6?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1332&q=80",
                        //                 ),
                        //                 fit: BoxFit.cover)),
                        //       ),
                        //     ],
                        //     options: CarouselOptions(
                        //         height: 180,
                        //         autoPlay: true,
                        //         aspectRatio: 16 / 9,
                        //         autoPlayCurve: Curves.fastOutSlowIn,
                        //         enableInfiniteScroll: true,
                        //         autoPlayAnimationDuration:
                        //             Duration(milliseconds: 800),
                        //         viewportFraction: 0.8)),
                        // Container(
                        //   padding: EdgeInsets.symmetric(vertical: 20),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                        //     children: [
                        //       CircleAvatar(
                        //           backgroundColor: Colors.purple, radius: 35),
                        //       CircleAvatar(
                        //           backgroundColor: Colors.redAccent,
                        //           radius: 35),
                        //       CircleAvatar(
                        //           backgroundColor: Colors.green, radius: 35),
                        //     ],
                        //   ),
                        // ),
                        // Container(
                        //   padding: EdgeInsets.symmetric(vertical: 20),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                        //     children: [
                        //       CircleAvatar(
                        //           backgroundColor: Colors.purple, radius: 35),
                        //       CircleAvatar(
                        //           backgroundColor: Colors.redAccent,
                        //           radius: 35),
                        //       CircleAvatar(
                        //           backgroundColor: Colors.green, radius: 35),
                        //     ],
                        //   ),
                        // ),
                        // Container(
                        //   padding: EdgeInsets.symmetric(vertical: 20),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                        //     children: [
                        //       CircleAvatar(
                        //           backgroundColor: Colors.purple, radius: 35),
                        //       CircleAvatar(
                        //           backgroundColor: Colors.redAccent,
                        //           radius: 35),
                        //       CircleAvatar(
                        //           backgroundColor: Colors.green, radius: 35),
                        //     ],
                        //   ),
                        // ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          width: double.infinity,
                          height: 170,
                          decoration: BoxDecoration(
                              color: Colors.deepPurple,
                              borderRadius: BorderRadius.circular(20)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'We Are Working To Add More\nQuizzes.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Give Your Ideas For Quizzes",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white),
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: TextField(
                                  controller: TextEditingController(),
                                  decoration: InputDecoration(
                                      hintStyle: TextStyle(
                                          color: Colors.black.withOpacity(0.7)),
                                      hintText: "Engineering, Medical..."),
                                  onSubmitted: (value) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                "Feedback Submitted Successfully")));
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "v1.0 Made By ISHAN",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.grey),
                        )
                      ],
                    ),
                  ),
                )),
          );
  }

  Widget CircularIcons(ImageUrl, textLabel, onTapFunction) {
    return InkWell(
      onTap: onTapFunction,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
              backgroundImage: NetworkImage(
                ImageUrl,
              ),
              radius: 35),
          SizedBox(
            height: 5,
          ),
          Text(
            textLabel,
            style: TextStyle(fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }
}

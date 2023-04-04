import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MysteryPage extends StatefulWidget {
  const MysteryPage({super.key});

  @override
  State<MysteryPage> createState() => _MysteryPageState();
}

class _MysteryPageState extends State<MysteryPage> {
  var mystery;
  Future getMystery() async {
    String xApiKey = (dotenv.env['X_API_KEY'])!;
    Uri uri = Uri.parse('https://api.api-ninjas.com/v1/riddles');
    Map<String, String> headers = {'X-Api-Key': xApiKey};
    http.Response response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      print(response.body);

      mystery = jsonDecode(response.body)[0];

      return mystery;
    } else {
      print('failed');
      return mystery;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mystery Zone'),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
            future: getMystery(),
            builder: ((context, snapshot) {
              return snapshot.hasData
                  ? Column(
                      children: [
                        Image(
                          image: NetworkImage(
                              'https://i.pinimg.com/originals/35/3c/15/353c155abb976444d0633f5df6bd2aa7.gif'),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            children: [
                              Text(
                                mystery['title'],
                                style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.deepPurple,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                mystery['question'],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  ElevatedButton(
                                      onPressed: () {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                          mystery['answer'],
                                          style: TextStyle(fontSize: 15),
                                        )));
                                      },
                                      child: Text("Show Answer")),
                                  ElevatedButton(
                                      onPressed: () {
                                        // mystery = await getMystery();

                                        setState(() {});
                                      },
                                      child: Text("Next Mystery"))
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    );
            })),
      ),
    );
  }
}

import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FactsPage extends StatefulWidget {
  const FactsPage({super.key});

  @override
  State<FactsPage> createState() => _FactsPageState();
}

class _FactsPageState extends State<FactsPage> {
  String xApiKey = (dotenv.env['X_API_KEY'])!;
  String fact = '';
  getFacts() async {
    Uri uri = Uri.parse('https://api.api-ninjas.com/v1/facts?limit=1');

    Map<String, String> headers = {'X-Api-Key': xApiKey};
    http.Response response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      setState(() {
        fact = jsonDecode(response.body)[0]['fact'];
      });

      print(fact);
      // print(response.body);
    } else {
      print(response.statusCode);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getFacts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Facts Corner"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: NetworkImage(
                  'https://upload.wikimedia.org/wikipedia/commons/8/8d/Facts_-_Idil_Keysan_-_Wikimedia_Giphy_stickers_2019.gif'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                "Fact Of The Day:",
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                fact,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30, color: Colors.black),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  getFacts();
                },
                child: Text("Next Fact"))
          ],
        ),
      ),
    );
  }
}

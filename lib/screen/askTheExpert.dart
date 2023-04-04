import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ExpAdvice extends StatefulWidget {
  String question;
  String YTurl;
  ExpAdvice({
    required this.YTurl,
    required this.question,
  });

  @override
  State<ExpAdvice> createState() => _ExpAdviceState();
}

class _ExpAdviceState extends State<ExpAdvice> {
  String videoId = "";
  urltoIDConverter() {
    videoId = YoutubePlayer.convertUrlToId(widget.YTurl)!;
    print(videoId);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    urltoIDConverter();
    Future.delayed(Duration(seconds: 50), () {
      if (this.mounted) Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple,
      body: Center(
          child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.purpleAccent,
            borderRadius: BorderRadius.circular(30)),
        margin: EdgeInsets.symmetric(vertical: 100, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "EXPERT ADVICE LIFELINE",
              style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "QUESTION: ${widget.question}",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.white),
              textAlign: TextAlign.center,
            ),
            Container(
                child: YoutubePlayer(
                    controller: YoutubePlayerController(
                        initialVideoId: videoId,
                        flags: YoutubePlayerFlags(
                            autoPlay: true,
                            hideControls: true,
                            controlsVisibleAtStart: false,
                            mute: false)))),
            Text(
              "You Will Be Redirected to Quiz Screen In 50 Seconds",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      )),
    );
  }
}

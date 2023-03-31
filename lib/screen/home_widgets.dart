import 'package:flutter/material.dart';

Widget quizBox(quizImgUrl, quizName, onTapFunction, imgOpacity) {
  return InkWell(
    onTap: onTapFunction,
    child: Stack(
      children: [
        Container(
          margin: EdgeInsets.all(10),
          height: 200,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                  image: NetworkImage(
                    quizImgUrl,
                  ),
                  fit: BoxFit.cover)),
        ),
        Container(
          height: 200,
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(imgOpacity),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        Positioned.fill(
          child: Center(
            child: Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.symmetric(horizontal: 13, vertical: 13),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.deepPurple,
              ),
              child: Text(
                quizName,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

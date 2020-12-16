import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mario/jumping_mario.dart';
import 'package:mario/mario.dart';
import 'package:mario/mushroom.dart';
import 'package:mario/my_button.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static double marioX = 0;
  static double marioY = 1;
  double marioSize = 50;
  double mushroomX = 0.5;
  double mushroomY = 1;
  double time = 0;
  double height = 0;
  double initialHeight = marioY;
  String direction = "right";
  bool midRun = false;
  bool midJump = false;
  var gameFont = GoogleFonts.pressStart2p(
      textStyle: TextStyle(color: Colors.white, fontSize: 20));

  void checkIfAteMushrooms() {
    if ((marioX - mushroomX).abs() < 0.05 &&
        (marioY - mushroomY).abs() < 0.05) {
      setState(() {
        mushroomX = 2;
        marioSize = 100;
      });
    }
  }

  void preJump() {
    time = 0;
    initialHeight = marioY;
  }

  void jump() {
    if (!midJump) {
      midJump = true;
      preJump();
      Timer.periodic(Duration(milliseconds: 50), (timer) {
        time += 0.05;
        height = -4.9 * time * time + 5 * time;

        if (initialHeight - height > 1) {
          midJump = false;

          setState(() {
            marioY = 1;
          });

          timer.cancel();
        } else {
          setState(() {
            marioY = initialHeight - height;
          });
        }
      });
    }
  }

  void moveLeft() {
    direction = "left";
    checkIfAteMushrooms();
    Timer.periodic(Duration(milliseconds: 50), (timer) {
      checkIfAteMushrooms();
      if (MyButton().isUserHoldingButton() && (marioX - 0.2) > -1) {
        setState(() {
          marioX -= 0.02;
          midRun = !midRun;
        });
      } else {
        timer.cancel();
      }
    });
  }

  void moveRight() {
    direction = "right";
    checkIfAteMushrooms();
    Timer.periodic(Duration(milliseconds: 50), (timer) {
      checkIfAteMushrooms();
      if (MyButton().isUserHoldingButton() && (marioX + 0.2) < 1) {
        setState(() {
          marioX += 0.02;
          midRun = !midRun;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: Stack(
              children: [
                Container(
                  color: Colors.blue,
                  child: AnimatedContainer(
                    alignment: Alignment(marioX, marioY),
                    duration: Duration(milliseconds: 0),
                    child: midJump
                        ? JumpingMario(
                            direction: direction,
                            size: marioSize,
                          )
                        : Mario(
                            direction: direction,
                            midRun: midRun,
                            size: marioSize,
                          ),
                  ),
                ),
                Container(
                  alignment: Alignment(mushroomX, mushroomY),
                  child: Mushroom(),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text(
                            "MARIO",
                            style: gameFont,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "0000",
                            style: gameFont,
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            "WORLD",
                            style: gameFont,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "1-1",
                            style: gameFont,
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            "TIME",
                            style: gameFont,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "9999",
                            style: gameFont,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.brown,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MyButton(
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    function: moveLeft,
                  ),
                  MyButton(
                    child: Icon(Icons.arrow_upward, color: Colors.white),
                    function: jump,
                  ),
                  MyButton(
                    child: Icon(Icons.arrow_forward, color: Colors.white),
                    function: moveRight,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

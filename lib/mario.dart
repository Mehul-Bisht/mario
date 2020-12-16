import 'package:flutter/material.dart';
import 'dart:math';

class Mario extends StatelessWidget {
  final direction;
  final midRun;
  final size;

  const Mario({Key key, this.direction, this.midRun, this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (direction == "right") {
      return Container(
        width: size,
        height: size,
        child: midRun
            ? Image.asset('lib/images/marioStand.png')
            : Image.asset('lib/images/marioWalk.png'),
      );
    } else {
      return Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotationY(pi),
        child: Container(
          width: size,
          height: size,
          child: midRun
              ? Image.asset('lib/images/marioStand.png')
              : Image.asset('lib/images/marioWalk.png'),
        ),
      );
    }
  }
}

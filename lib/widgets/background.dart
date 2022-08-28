import 'dart:ui';
import 'package:flutter/material.dart';
import '../constants.dart';

class Background extends StatelessWidget {
  const Background({Key? key, required this.child}) : super(key: key);
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // blur Circle for background
        Center(
            child: Padding(
          padding: const EdgeInsets.only(left: 200, top: 200),
          child: CircleAvatar(
            radius: 1000,
            backgroundColor: kRedColor.withOpacity(.4),
          ),
        )),
        // blur Circle for background
        Center(
            child: Padding(
          padding: const EdgeInsets.only(right: 200, bottom: 200),
          child: CircleAvatar(
            radius: 1000,
            backgroundColor: Colors.blue.withOpacity(.4),
          ),
        )),
        ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
            child: child,
          ),
        )
      ],
    );
  }
}

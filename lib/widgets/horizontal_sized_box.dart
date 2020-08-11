import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class HorizontalSizedBox extends StatelessWidget {
  HorizontalSizedBox({this.boxWidth});

  final double boxWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: boxWidth,
    );
  }
}

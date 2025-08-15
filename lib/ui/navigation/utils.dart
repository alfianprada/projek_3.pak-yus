import 'package:flutter/material.dart';
import '../theme.dart';

Widget commonTabScene(Widget content) {
  return Container(
    decoration: BoxDecoration(color: RiveAppTheme.background),
    alignment: Alignment.center,
    child: content,
  );
}

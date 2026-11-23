import 'package:flutter/material.dart';

class Height extends StatelessWidget {
  final double height;
  const Height(this.height, {super.key});

  @override
  Widget build(BuildContext context) => SizedBox(height: height);
}

class Width extends StatelessWidget {
  final double width;
  const Width(this.width, {super.key});

  @override
  Widget build(BuildContext context) => SizedBox(width: width);
}

extension SizeExtension on num {
  Widget get h => SizedBox(height: toDouble());
  Widget get w => SizedBox(width: toDouble());
}

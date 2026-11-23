import 'package:flutter/material.dart';

class CustomTransformArabic extends StatelessWidget {
  final Widget child;

  const CustomTransformArabic({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    if (isRtl) {
      return Transform.flip(
        flipX: true,
        child: child,
      );
    }
    return child;
  }
}

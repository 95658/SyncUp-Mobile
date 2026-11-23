import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:syncup/app/core/constants/constants.dart';
import 'package:syncup/app/core/themes/app_colors.dart';

class ShimmerBox extends StatelessWidget {
  final double? width;
  final double? height;
  final double borderRadius;
  final ShapeBorder? shapeBorder;

  const ShimmerBox({
    super.key,
    this.width,
    this.height,
    this.borderRadius = Constants.borderRadius,
    this.shapeBorder,
  });

  const ShimmerBox.circular({
    super.key,
    required double size,
  })  : width = size,
        height = size,
        borderRadius = size / 2,
        shapeBorder = const CircleBorder();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      child: Container(
        width: width,
        height: height,
        decoration: shapeBorder == null
            ? BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(borderRadius),
              )
            : ShapeDecoration(
                color: Colors.white,
                shape: shapeBorder!,
              ),
      ),
    );
  }
}

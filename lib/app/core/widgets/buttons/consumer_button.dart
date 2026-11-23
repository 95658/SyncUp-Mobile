import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncup/app/core/models/custom_state.dart';
import 'package:syncup/app/core/widgets/buttons/custom_button.dart';

class ConsumerButton extends ConsumerWidget {
  final String title;
  final VoidCallback? onPress;
  final CustomState<bool> stateProvider;
  final bool isDisabled;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final double? borderRadius;
  final double? height;
  final double? width;
  final Widget? icon;

  const ConsumerButton({
    super.key,
    required this.title,
    required this.onPress,
    required this.stateProvider,
    this.isDisabled = false,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.borderRadius,
    this.height,
    this.width,
    this.icon,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(stateProvider.provider);

    return CustomButton(
      title: title,
      onPress: onPress,
      isLoading: isLoading,
      isDisabled: isDisabled,
      backgroundColor: backgroundColor,
      textColor: textColor,
      borderColor: borderColor,
      borderRadius: borderRadius,
      height: height,
      width: width,
      icon: icon,
    );
  }
}

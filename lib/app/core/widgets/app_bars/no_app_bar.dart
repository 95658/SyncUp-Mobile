import 'package:flutter/material.dart';

class NoAppBar extends StatelessWidget implements PreferredSizeWidget {
  const NoAppBar({super.key});

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();

  @override
  Size get preferredSize => Size.zero;
}

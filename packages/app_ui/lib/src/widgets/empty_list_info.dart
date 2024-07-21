import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class EmptyListInfo extends StatelessWidget {
  const EmptyListInfo({
    super.key,
    required this.text,
    this.icon = AppIcons.emptyListInfoIcon,
    this.iconColor = AppColors.emptyListInfoIconColor,
    this.iconSize = AppInsets.xxLarge,
  });

  final String text;
  final IconData icon;
  final Color iconColor;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: iconColor,
            size: iconSize,
          ),
          const SizedBox(height: AppInsets.xLarge),
          Text(
            text,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}

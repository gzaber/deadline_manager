import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class DescriptionText extends StatelessWidget {
  const DescriptionText({
    super.key,
    required this.description,
  });

  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppInsets.medium),
      child: Text(
        description,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}

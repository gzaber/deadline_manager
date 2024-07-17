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
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        description,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}

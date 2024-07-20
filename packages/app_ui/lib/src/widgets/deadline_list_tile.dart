import 'package:app_ui/app_ui.dart';
import 'package:deadlines_api/deadlines_api.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DeadlineListTile extends StatelessWidget {
  const DeadlineListTile({
    super.key,
    required this.deadline,
    required this.currentDate,
    this.trailing,
    this.subtitle,
  });

  final Deadline deadline;
  final DateTime currentDate;
  final Widget? trailing;
  final Widget? subtitle;

  @override
  Widget build(BuildContext context) {
    final formattedDate =
        DateFormat('dd-MM-yyyy').format(deadline.expirationDate);

    return ListTile(
      leading: Icon(Icons.description,
          color: switch (
              deadline.expirationDate.difference(currentDate).inDays) {
            <= 7 => AppColors.shortExpirationDateColor,
            > 7 && <= 30 => AppColors.mediumExpirationDateColor,
            _ => AppColors.longExpirationDateColor,
          }),
      title: Row(
        children: [Text(deadline.name), const Spacer(), Text(formattedDate)],
      ),
      subtitle: subtitle,
      trailing: trailing,
    );
  }
}

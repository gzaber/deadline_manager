import 'package:deadline_manager/ui/ui.dart';
import 'package:deadlines_repository/deadlines_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DeadlineListTile extends StatelessWidget {
  const DeadlineListTile({
    super.key,
    required this.deadline,
    required this.currentDate,
    this.trailing,
  });

  final Deadline deadline;
  final DateTime currentDate;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final isSmallWidth = MediaQuery.sizeOf(context).width < 640;
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
      title: isSmallWidth
          ? Text(deadline.name)
          : Row(
              children: [
                Text(deadline.name),
                const Spacer(),
                Text(formattedDate)
              ],
            ),
      subtitle: isSmallWidth ? Text(formattedDate) : null,
      trailing: trailing,
    );
  }
}

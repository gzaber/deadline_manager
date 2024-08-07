import 'package:deadlines_repository/deadlines_repository.dart';
import 'package:equatable/equatable.dart';

class SummaryDeadline extends Equatable {
  const SummaryDeadline({
    required this.name,
    required this.expirationDate,
    required this.isShared,
    required this.categoryName,
    required this.categoryIcon,
    required this.sharedBy,
  });

  final String name;
  final DateTime expirationDate;
  final bool isShared;
  final String categoryName;
  final int categoryIcon;
  final String sharedBy;

  Deadline toDeadline() => Deadline(
        categoryId: '',
        name: name,
        expirationDate: expirationDate,
      );

  @override
  List<Object> get props => [
        name,
        expirationDate,
        isShared,
        categoryName,
        categoryIcon,
        sharedBy,
      ];
}

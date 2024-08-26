part of 'add_edit_deadline_cubit.dart';

enum AddEditDeadlineStatus { initial, loading, success, failure }

final class AddEditDeadlineState extends Equatable {
  const AddEditDeadlineState({
    this.status = AddEditDeadlineStatus.initial,
    this.initialDeadline,
    this.categoryId = '',
    this.name = '',
    required this.expirationDate,
  });

  final AddEditDeadlineStatus status;
  final Deadline? initialDeadline;
  final String categoryId;
  final String name;
  final DateTime expirationDate;

  AddEditDeadlineState copyWith({
    AddEditDeadlineStatus? status,
    Deadline? initialDeadline,
    String? categoryId,
    String? name,
    DateTime? expirationDate,
  }) {
    return AddEditDeadlineState(
      status: status ?? this.status,
      initialDeadline: initialDeadline ?? this.initialDeadline,
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      expirationDate: expirationDate ?? this.expirationDate,
    );
  }

  @override
  List<Object?> get props =>
      [status, initialDeadline, categoryId, name, expirationDate];
}

part of 'add_edit_deadline_cubit.dart';

enum AddEditDeadlineStatus { initial, loading, success, failure }

class AddEditDeadlineState extends Equatable {
  const AddEditDeadlineState({
    this.status = AddEditDeadlineStatus.initial,
    this.initialDeadline,
    required this.categoryId,
    required this.name,
    required this.expirationDate,
  });

  final AddEditDeadlineStatus status;
  final Deadline? initialDeadline;
  final String categoryId;
  final String name;
  final DateTime expirationDate;

  @override
  List<Object?> get props => [status, initialDeadline, name, expirationDate];

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
}

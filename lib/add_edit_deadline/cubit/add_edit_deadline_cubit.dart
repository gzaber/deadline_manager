import 'package:bloc/bloc.dart';
import 'package:deadlines_repository/deadlines_repository.dart';
import 'package:equatable/equatable.dart';

part 'add_edit_deadline_state.dart';

class AddEditDeadlineCubit extends Cubit<AddEditDeadlineState> {
  AddEditDeadlineCubit({
    required DeadlinesRepository deadlinesRepository,
    required String? categoryId,
    required Deadline? deadline,
  })  : _deadlinesRepository = deadlinesRepository,
        super(
          AddEditDeadlineState(
            initialDeadline: deadline,
            categoryId: deadline?.categoryId ?? categoryId,
            name: deadline?.name ?? '',
            expirationDate: deadline?.expirationDate ?? DateTime.now(),
          ),
        );

  final DeadlinesRepository _deadlinesRepository;

  void onNameChanged(String name) {
    emit(state.copyWith(name: name));
  }

  void onDateTimeChanged(DateTime expirationDate) {
    emit(state.copyWith(expirationDate: expirationDate));
  }

  void saveDeadline() async {
    emit(
      state.copyWith(status: AddEditDeadlineStatus.loading),
    );

    final deadline = Deadline(
      id: state.initialDeadline?.id,
      categoryId: state.initialDeadline?.categoryId ?? state.categoryId ?? '',
      name: state.name,
      expirationDate: state.expirationDate,
    );

    try {
      state.initialDeadline == null
          ? await _deadlinesRepository.createDeadline(deadline)
          : await _deadlinesRepository.updateDeadline(deadline);
      emit(state.copyWith(status: AddEditDeadlineStatus.success));
    } catch (_) {
      emit(state.copyWith(status: AddEditDeadlineStatus.failure));
    }
  }
}

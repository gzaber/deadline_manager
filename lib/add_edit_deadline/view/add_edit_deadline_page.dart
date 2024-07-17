import 'package:deadline_manager/add_edit_deadline/add_edit_deadline.dart';
import 'package:deadline_manager/ui/ui.dart';
import 'package:deadlines_repository/deadlines_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class AddEditDeadlinePage extends StatelessWidget {
  const AddEditDeadlinePage({
    super.key,
    this.deadline,
    this.categoryId,
  });

  final String? categoryId;
  final Deadline? deadline;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddEditDeadlineCubit(
        deadlinesRepository: context.read<DeadlinesRepository>(),
        categoryId: categoryId,
        deadline: deadline,
      ),
      child: const AddEditDeadlineView(),
    );
  }
}

class AddEditDeadlineView extends StatelessWidget {
  const AddEditDeadlineView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.read<AddEditDeadlineCubit>().state.initialDeadline == null
              ? 'Create deadline'
              : 'Update deadline',
        ),
        actions: const [_SaveButton()],
      ),
      body: BlocListener<AddEditDeadlineCubit, AddEditDeadlineState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == AddEditDeadlineStatus.success) {
            context.pop();
          }
          if (state.status == AddEditDeadlineStatus.failure) {
            FailureSnackBar.show(
              context: context,
              text: 'Something went wrong',
            );
          }
        },
        child: const Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _NameField(),
              DescriptionText(description: 'Select expiration date:'),
              _DatePicker(),
            ],
          ),
        ),
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton();

  @override
  Widget build(BuildContext context) {
    final stateStatus =
        context.select((AddEditDeadlineCubit cubit) => cubit.state.status);

    return IconButton(
      onPressed: () {
        context.read<AddEditDeadlineCubit>().saveDeadline();
      },
      icon: stateStatus == AddEditDeadlineStatus.loading
          ? const CircularProgressIndicator()
          : const Icon(AppIcons.saveIcon),
    );
  }
}

class _NameField extends StatelessWidget {
  const _NameField();

  @override
  Widget build(BuildContext context) {
    final stateName =
        context.select((AddEditDeadlineCubit cubit) => cubit.state.name);

    return TextFormField(
      initialValue: stateName,
      onChanged: (value) {
        context.read<AddEditDeadlineCubit>().onNameChanged(value);
      },
      decoration: const InputDecoration(labelText: 'Deadline name'),
    );
  }
}

class _DatePicker extends StatelessWidget {
  const _DatePicker();

  @override
  Widget build(BuildContext context) {
    final stateDate = context.select(
      (AddEditDeadlineCubit cubit) => cubit.state.expirationDate,
    );
    final currentDate = DateTime.now();
    final formattedDate = DateFormat('dd-MM-yyyy').format(stateDate);

    return OutlinedButton(
      onPressed: () async {
        await showDatePicker(
          context: context,
          initialDate: DateTime(stateDate.year, stateDate.month, stateDate.day),
          firstDate: DateTime(currentDate.year - 10),
          lastDate: DateTime(currentDate.year + 10),
        ).then((value) {
          if (value != null) {
            context.read<AddEditDeadlineCubit>().onDateTimeChanged(value);
          }
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(AppIcons.calendarIcon),
          const SizedBox(width: 10),
          Text(formattedDate),
        ],
      ),
    );
  }
}

import 'package:app_ui/app_ui.dart';
import 'package:deadline_manager/add_edit_deadline/add_edit_deadline.dart';
import 'package:deadlines_repository/deadlines_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class AddEditDeadlinePage extends StatelessWidget {
  const AddEditDeadlinePage({
    super.key,
    required this.categoryId,
    this.deadline,
  });

  final String categoryId;
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
              ? AppLocalizations.of(context)!.addEditCreateTitle
              : AppLocalizations.of(context)!.addEditUpdateTitle,
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
              text: AppLocalizations.of(context)!.failureMessage,
            );
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppInsets.xLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _NameField(),
                DescriptionText(
                    description: AppLocalizations.of(context)!
                        .addEditDeadlineSelectDateLabel),
                const _DatePicker(),
              ],
            ),
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
    final stateEmptyName = context
        .select((AddEditDeadlineCubit cubit) => cubit.state.name.isEmpty);

    return IconButton(
      onPressed: () {
        stateEmptyName
            ? null
            : context.read<AddEditDeadlineCubit>().saveDeadline();
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
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)!.addEditDeadlineNameLabel,
      ),
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
          const SizedBox(width: AppInsets.medium),
          Text(formattedDate),
        ],
      ),
    );
  }
}

import 'package:deadline_manager/add_edit_deadline/add_edit_deadline.dart';
import 'package:deadlines_repository/deadlines_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddEditDeadlinePage extends StatelessWidget {
  const AddEditDeadlinePage({
    super.key,
    this.deadline,
    required this.categoryId,
  });

  final Deadline? deadline;
  final String categoryId;

  static Future<void> show({
    required BuildContext context,
    required String categoryId,
    final Deadline? deadline,
  }) {
    return showDialog(
        context: context,
        builder: (_) {
          final showFullScreenDialog = MediaQuery.sizeOf(context).width < 640;
          final dialogContent = BlocProvider(
            create: (context) => AddEditDeadlineCubit(
              deadlinesRepository: context.read<DeadlinesRepository>(),
              initialDeadline: deadline,
              categoryId: categoryId,
            ),
            child: AddEditDeadlinePage(
              deadline: deadline,
              categoryId: categoryId,
            ),
          );

          if (showFullScreenDialog) {
            return Dialog.fullscreen(
              child: dialogContent,
            );
          } else {
            return Dialog(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: dialogContent,
              ),
            );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddEditDeadlineCubit, AddEditDeadlineState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == AddEditDeadlineStatus.success) {
          Navigator.pop(context);
        }
        if (state.status == AddEditDeadlineStatus.failure) {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Error'),
              content:
                  const Text('Something went wrong during saving deadline'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('OK')),
              ],
            ),
          );
        }
      },
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
        centerTitle: true,
        title: Text(
          context.read<AddEditDeadlineCubit>().state.initialDeadline == null
              ? 'Create deadline'
              : 'Update deadline',
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.cancel),
        ),
        actions: const [_SaveButton()],
      ),
      body: const Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _NameField(),
            SizedBox(height: 10),
            _DatePicker(),
          ],
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
          : const Icon(Icons.save),
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
      decoration: const InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))),
      ),
    );
  }
}

class _DatePicker extends StatelessWidget {
  const _DatePicker();

  @override
  Widget build(BuildContext context) {
    final date = context
        .select((AddEditDeadlineCubit cubit) => cubit.state.expirationDate);
    final formattedDate = '${date.day}-${date.month}-${date.year}';
    return OutlinedButton(
      onPressed: () async {
        await showDatePicker(
          context: context,
          initialDate: DateTime(date.year, date.month, date.day),
          firstDate: DateTime.now(),
          lastDate: DateTime(DateTime.now().year + 10),
        ).then((value) {
          if (value != null) {
            context.read<AddEditDeadlineCubit>().onDateTimeChanged(value);
          }
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.date_range),
          const SizedBox(width: 10),
          Text(formattedDate),
        ],
      ),
    );
  }
}

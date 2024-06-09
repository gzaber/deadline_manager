import 'package:deadlines_repository/deadlines_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:deadline_manager/deadlines/deadlines.dart';

class DeadlinesPage extends StatelessWidget {
  const DeadlinesPage({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  final String categoryId;
  final String categoryName;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DeadlinesCubit(
        deadlinesRepository: context.read<DeadlinesRepository>(),
        categoryId: categoryId,
        categoryName: categoryName,
      ),
      child: const DeadlinesView(),
    );
  }
}

class DeadlinesView extends StatelessWidget {
  const DeadlinesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(context.read<DeadlinesCubit>().state.categoryName),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      body: BlocConsumer<DeadlinesCubit, DeadlinesState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == DeadlinesStatus.failure) {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Error'),
                content: const Text('Something went wrong with deadlines'),
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
        builder: (context, state) {
          return ListView.builder(
            itemCount: state.deadlines.length,
            itemBuilder: (_, index) {
              return _DeadlineItem(deadline: state.deadlines[index]);
            },
          );
        },
      ),
    );
  }
}

class _DeadlineItem extends StatelessWidget {
  const _DeadlineItem({
    required this.deadline,
  });

  final Deadline deadline;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.description),
      title: Text(deadline.name),
      subtitle: Text(deadline.expirationDate.toIso8601String()),
    );
  }
}

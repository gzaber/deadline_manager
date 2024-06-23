import 'package:categories_repository/categories_repository.dart';
import 'package:deadline_manager/app/app.dart';
import 'package:deadline_manager/summary/summary.dart';
import 'package:deadline_manager/ui/ui.dart';
import 'package:deadlines_repository/deadlines_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SummaryPage extends StatelessWidget {
  const SummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SummaryCubit(
        categoriesRepository: context.read<CategoriesRepository>(),
        deadlinesRepository: context.read<DeadlinesRepository>(),
        user: context.read<AppCubit>().state.user,
      ),
      child: const SummaryView(),
    );
  }
}

class SummaryView extends StatelessWidget {
  const SummaryView({super.key});

  @override
  Widget build(BuildContext context) {
    final currentDate = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Summary'),
      ),
      body: BlocConsumer<SummaryCubit, SummaryState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == SummaryStatus.failure) {
            FailureSnackBar.show(
              context: context,
              text: 'Something went wrong',
            );
          }
        },
        builder: (context, state) {
          return ListView.builder(
            itemCount: state.deadlines.length,
            itemBuilder: (_, index) {
              return DeadlineListTile(
                deadline: state.deadlines[index],
                currentDate: currentDate,
              );
            },
          );
        },
      ),
    );
  }
}

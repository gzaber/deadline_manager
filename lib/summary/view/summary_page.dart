import 'package:categories_repository/categories_repository.dart';
import 'package:deadlines_repository/deadlines_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permissions_repository/permissions_repository.dart';

import 'package:deadline_manager/app/app.dart';
import 'package:deadline_manager/summary/summary.dart';
import 'package:deadline_manager/ui/ui.dart';

class SummaryPage extends StatelessWidget {
  const SummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SummaryCubit(
        categoriesRepository: context.read<CategoriesRepository>(),
        deadlinesRepository: context.read<DeadlinesRepository>(),
        permissionsRepository: context.read<PermissionsRepository>(),
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
        title: const Text('Summary'),
        actions: const [_FilterDeadlinesMenuButton()],
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
          if (state.status == SummaryStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final deadlines =
              state.showShared ? state.summaryDeadlines : state.userDeadlines;
          return ListView.separated(
            separatorBuilder: (_, __) => const Divider(),
            itemCount: deadlines.length,
            itemBuilder: (_, index) {
              final summaryDeadline = deadlines[index];
              return DeadlineListTile(
                deadline: summaryDeadline.toDeadline(),
                currentDate: currentDate,
                subtitle: state.showDetails
                    ? _DeadlineListTileSubtitle(deadline: summaryDeadline)
                    : null,
              );
            },
          );
        },
      ),
    );
  }
}

class _DeadlineListTileSubtitle extends StatelessWidget {
  const _DeadlineListTileSubtitle({
    required this.deadline,
  });

  final SummaryDeadline deadline;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(deadline.isShared ? 'shared by:' : 'category:'),
        const SizedBox(width: AppInsets.small),
        Icon(
          deadline.isShared
              ? Icons.person
              : IconData(
                  deadline.categoryIcon,
                  fontFamily: AppIcons.iconFontFamily,
                ),
          size: AppInsets.large,
        ),
        const SizedBox(width: AppInsets.small),
        Text(deadline.isShared ? deadline.sharedBy : deadline.categoryName),
      ],
    );
  }
}

class _FilterDeadlinesMenuButton extends StatelessWidget {
  const _FilterDeadlinesMenuButton();

  @override
  Widget build(BuildContext context) {
    final summaryCubit = context.read<SummaryCubit>();
    return PopupMenuButton(
      itemBuilder: (_) => [
        PopupMenuItem(
          onTap: () => summaryCubit.toggleShowDetails(),
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(right: AppInsets.medium),
                child: Text('Show details'),
              ),
              summaryCubit.state.showDetails
                  ? const Icon(Icons.check)
                  : const SizedBox(),
            ],
          ),
        ),
        PopupMenuItem(
          onTap: () => context.read<SummaryCubit>().toggleShowShared(),
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(right: AppInsets.medium),
                child: Text('Show shared'),
              ),
              summaryCubit.state.showShared
                  ? const Icon(Icons.check)
                  : const SizedBox(),
            ],
          ),
        ),
      ],
    );
  }
}

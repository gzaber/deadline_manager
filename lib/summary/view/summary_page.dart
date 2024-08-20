import 'package:app_ui/app_ui.dart';
import 'package:categories_repository/categories_repository.dart';
import 'package:deadline_manager/app/app.dart';
import 'package:deadline_manager/summary/summary.dart';
import 'package:deadlines_repository/deadlines_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:permissions_repository/permissions_repository.dart';

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
      )..readDeadlines(),
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
        title: Text(AppLocalizations.of(context)!.summaryTitle),
        actions: const [_FilterDeadlinesMenuButton()],
      ),
      body: BlocConsumer<SummaryCubit, SummaryState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == SummaryStatus.failure) {
            FailureSnackBar.show(
              context: context,
              text: AppLocalizations.of(context)!.failureMessage,
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
          if (deadlines.isEmpty) {
            return EmptyListInfo(
              text: AppLocalizations.of(context)!.emptyListMessage,
            );
          }
          return ListView.separated(
            separatorBuilder: (_, __) => const Divider(),
            itemCount: deadlines.length,
            itemBuilder: (_, index) {
              final summaryDeadline = deadlines[index];
              return _DeadlineListTile(
                deadline: summaryDeadline,
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

class _DeadlineListTile extends StatelessWidget {
  const _DeadlineListTile({
    required this.deadline,
    required this.currentDate,
    this.subtitle,
  });

  final SummaryDeadline deadline;
  final DateTime currentDate;
  final Widget? subtitle;

  @override
  Widget build(BuildContext context) {
    final formattedDate =
        DateFormat(AppDateFormat.pattern).format(deadline.expirationDate);

    return ListTile(
      leading: AppIcons.getDeadlineIcon(currentDate, deadline.expirationDate),
      title: Text(deadline.name),
      trailing: Text(
        formattedDate,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      subtitle: subtitle,
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
    final label = deadline.isShared
        ? AppLocalizations.of(context)!.summarySharedByLabel
        : AppLocalizations.of(context)!.summaryCategoryLabel;
    final detail =
        deadline.isShared ? deadline.sharedBy : deadline.categoryName;
    return Text('$label $detail');
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
              Padding(
                padding: const EdgeInsets.only(right: AppInsets.medium),
                child: Text(
                    AppLocalizations.of(context)!.summaryShowDetailsMenuOption),
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
              Padding(
                padding: const EdgeInsets.only(right: AppInsets.medium),
                child: Text(
                    AppLocalizations.of(context)!.summaryShowSharedMenuOption),
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

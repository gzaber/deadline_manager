import 'package:app_ui/app_ui.dart';
import 'package:categories_repository/categories_repository.dart';
import 'package:deadline_manager/app/app.dart';
import 'package:deadline_manager/category_details/category_details.dart';
import 'package:deadlines_repository/deadlines_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class CategoryDetailsPage extends StatelessWidget {
  const CategoryDetailsPage({
    super.key,
    required this.categoryId,
  });

  final String categoryId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CategoryDetailsCubit(
        categoriesRepository: context.read<CategoriesRepository>(),
        deadlinesRepository: context.read<DeadlinesRepository>(),
        categoryId: categoryId,
      )
        ..readCategory(categoryId)
        ..subscribeToDeadlines(categoryId),
      child: const CategoryDetailsView(),
    );
  }
}

class CategoryDetailsView extends StatelessWidget {
  const CategoryDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final currentDate = DateTime.now();
    final category =
        context.select((CategoryDetailsCubit cubit) => cubit.state.category);

    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
        backgroundColor: Color(category.color),
        actions: [
          AddIconButton(
            onPressed: () => context.go(
              '${AppRouter.categoriesToCategoryDetailsLocation}/${category.id}/${AppRouter.addEditDeadlinePath}/${category.id}',
            ),
          ),
        ],
      ),
      body: BlocConsumer<CategoryDetailsCubit, CategoryDetailsState>(
        listenWhen: (previous, current) =>
            previous.futureStatus != current.futureStatus ||
            previous.streamStatus != current.streamStatus,
        listener: (context, state) {
          if (state.futureStatus == CategoryDetailsFutureStatus.failure ||
              state.streamStatus == CategoryDetailsStreamStatus.failure) {
            FailureSnackBar.show(
              context: context,
              text: AppLocalizations.of(context)!.failureMessage,
            );
          }
        },
        builder: (context, state) {
          if (state.futureStatus == CategoryDetailsFutureStatus.loading ||
              state.streamStatus == CategoryDetailsStreamStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state.streamStatus == CategoryDetailsStreamStatus.success &&
              state.deadlines.isEmpty) {
            return EmptyListInfo(
              text: AppLocalizations.of(context)!.emptyListMessage,
            );
          }
          return ListView.separated(
            separatorBuilder: (_, __) => const Divider(),
            itemCount: state.deadlines.length,
            itemBuilder: (_, index) {
              return _DeadlineListTile(
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

class _DeadlineListTile extends StatelessWidget {
  const _DeadlineListTile({
    required this.deadline,
    required this.currentDate,
  });

  final Deadline deadline;
  final DateTime currentDate;

  @override
  Widget build(BuildContext context) {
    final formattedDate =
        DateFormat(AppDateFormat.pattern).format(deadline.expirationDate);
    final screenSize = AppScreenSize.getSize(context);

    return ListTile(
      leading: AppIcons.getDeadlineIcon(currentDate, deadline.expirationDate),
      title: Text(deadline.name),
      subtitle: screenSize == ScreenSize.mobile ? Text(formattedDate) : null,
      trailing: screenSize == ScreenSize.mobile
          ? _DeadlineMenuButton(deadline: deadline)
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  formattedDate,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(width: AppInsets.medium),
                _DeadlineMenuButton(deadline: deadline)
              ],
            ),
    );
  }
}

class _DeadlineMenuButton extends StatelessWidget {
  const _DeadlineMenuButton({
    required this.deadline,
  });

  final Deadline deadline;

  @override
  Widget build(BuildContext context) {
    return UpdateDeleteMenuButton(
      updateText: AppLocalizations.of(context)!.menuUpdateOption,
      deleteText: AppLocalizations.of(context)!.menuDeleteOption,
      onUpdateTap: () {
        context.go(
          '${AppRouter.categoriesToCategoryDetailsLocation}/${deadline.categoryId}/${AppRouter.addEditDeadlinePath}/${deadline.categoryId}',
          extra: deadline,
        );
      },
      onDeleteTap: () async {
        await ConfirmationAlertDialog.show(
          context: context,
          title: AppLocalizations.of(context)!.dialogDeleteTitle,
          content: AppLocalizations.of(context)!.dialogDeleteDeadlineContent,
          confirmButtonText:
              AppLocalizations.of(context)!.dialogConfirmButtonText,
          cancelButtonText:
              AppLocalizations.of(context)!.dialogCancelButtonText,
        ).then(
          (value) {
            if (value == true && context.mounted) {
              context.read<CategoryDetailsCubit>().deleteDeadline(deadline.id);
            }
          },
        );
      },
    );
  }
}

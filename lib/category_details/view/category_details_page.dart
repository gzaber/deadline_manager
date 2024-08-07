import 'package:app_ui/app_ui.dart';
import 'package:categories_repository/categories_repository.dart';
import 'package:deadlines_repository/deadlines_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:deadline_manager/app/app.dart';
import 'package:deadline_manager/category_details/category_details.dart';

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
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              IconData(
                category.icon,
                fontFamily: AppIcons.iconFontFamily,
              ),
            ),
            const SizedBox(width: AppInsets.large),
            Text(category.name),
          ],
        ),
        backgroundColor: Color(category.color),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go(
            '${AppRouter.categoriesToCategoryDetailsLocation}/${category.id}/${AppRouter.addEditDeadlinePath}/${category.id}',
          );
        },
        child: const Icon(AppIcons.fabIcon),
      ),
      body: BlocConsumer<CategoryDetailsCubit, CategoryDetailsState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == CategoryDetailsStatus.failure) {
            FailureSnackBar.show(
              context: context,
              text: 'Something went wrong',
            );
          }
        },
        builder: (context, state) {
          if (state.deadlines.isEmpty) {
            return const EmptyListInfo(text: 'Your list is empty.');
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
        DateFormat('dd-MM-yyyy').format(deadline.expirationDate);
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
      updateText: 'Update',
      deleteText: 'Delete',
      onUpdateTap: () {
        context.go(
          '${AppRouter.categoriesToCategoryDetailsLocation}/${deadline.categoryId}/${AppRouter.addEditDeadlinePath}/${deadline.categoryId}',
          extra: deadline,
        );
      },
      onDeleteTap: () async {
        await ConfirmationAlertDialog.show(
          context: context,
          title: 'Delete',
          content: 'Delete this deadline?',
          confirmButtonText: 'Yes',
          cancelButtonText: 'No',
        ).then(
          (value) {
            if (value == true) {
              context.read<CategoryDetailsCubit>().deleteDeadline(deadline.id);
            }
          },
        );
      },
    );
  }
}

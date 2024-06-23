import 'package:categories_repository/categories_repository.dart';
import 'package:deadlines_repository/deadlines_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:deadline_manager/app/app.dart';
import 'package:deadline_manager/category_details/category_details.dart';
import 'package:deadline_manager/ui/ui.dart';

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
      ),
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
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              IconData(
                category.icon,
                fontFamily: 'MaterialIcons',
              ),
            ),
            const SizedBox(width: 15),
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
        child: const Icon(Icons.add),
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
          return ListView.builder(
            itemCount: state.deadlines.length,
            itemBuilder: (_, index) {
              return _DeadlineItem(
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

class _DeadlineItem extends StatelessWidget {
  const _DeadlineItem({
    required this.deadline,
    required this.currentDate,
  });

  final Deadline deadline;
  final DateTime currentDate;

  @override
  Widget build(BuildContext context) {
    return DeadlineListTile(
      deadline: deadline,
      currentDate: currentDate,
      trailing: UpdateDeleteMenuButton(
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
                context
                    .read<CategoryDetailsCubit>()
                    .deleteDeadline(deadline.id ?? '');
              }
            },
          );
        },
      ),
    );
  }
}

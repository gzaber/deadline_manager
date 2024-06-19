import 'package:categories_repository/categories_repository.dart';
import 'package:deadline_manager/app/app.dart';
import 'package:deadline_manager/categories/categories.dart';
import 'package:deadline_manager/ui/ui.dart';
import 'package:deadlines_repository/deadlines_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CategoriesCubit(
        categoriesRepository: context.read<CategoriesRepository>(),
        deadlinesRepository: context.read<DeadlinesRepository>(),
        user: context.read<AppCubit>().state.user,
      ),
      child: const CategoriesView(),
    );
  }
}

class CategoriesView extends StatelessWidget {
  const CategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Categories'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go(AppRouter.categoriesToAddEditCategoryLocation);
        },
        child: const Icon(Icons.add),
      ),
      body: BlocConsumer<CategoriesCubit, CategoriesState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == CategoriesStatus.failure) {
            FailureSnackBar.show(
              context: context,
              text: 'Something went wrong',
            );
          }
        },
        builder: (context, state) {
          return MasonryGridView.extent(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            maxCrossAxisExtent: 400,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            itemCount: state.categories.length,
            itemBuilder: (context, index) {
              return _CategoryItem(category: state.categories[index]);
            },
          );
        },
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  const _CategoryItem({
    required this.category,
  });

  final Category category;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        context.go(
          '${AppRouter.categoriesToCategoryDetailsLocation}/${category.id}',
        );
      },
      leading: Icon(IconData(category.icon)),
      trailing: _PopupMenuButton(
        onUpdateTap: () {
          context.go(
            AppRouter.categoriesToAddEditCategoryLocation,
            extra: category,
          );
        },
        onDeleteTap: () async {
          return await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Delete'),
              content: const Text('Delete this category?'),
              actionsAlignment: MainAxisAlignment.spaceBetween,
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: const Text('Yes'),
                ),
              ],
            ),
          ).then(
            (value) {
              if (value == true) {
                context
                    .read<CategoriesCubit>()
                    .deleteCategoryWithDeadlines(category.id ?? '');
              }
            },
          );
        },
      ),
      title: Text(category.name),
      subtitle: Text(category.userEmail),
      tileColor: Color(category.color),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    );
  }
}

class _PopupMenuButton extends StatelessWidget {
  const _PopupMenuButton({
    required this.onUpdateTap,
    required this.onDeleteTap,
  });

  final Function() onUpdateTap;
  final Function() onDeleteTap;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (_) => [
        PopupMenuItem(onTap: onUpdateTap, child: const Text('Update')),
        PopupMenuItem(onTap: onDeleteTap, child: const Text('Delete')),
      ],
    );
  }
}

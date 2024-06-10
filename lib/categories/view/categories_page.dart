import 'package:categories_repository/categories_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:deadline_manager/add_edit_category/view/add_edit_category_page.dart';
import 'package:deadline_manager/app/app.dart';
import 'package:deadline_manager/categories/categories.dart';
import 'package:go_router/go_router.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CategoriesCubit(
        categoriesRepository: context.read<CategoriesRepository>(),
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
          AddEditCategoryPage.show(context: context);
        },
        child: const Icon(Icons.add),
      ),
      body: BlocConsumer<CategoriesCubit, CategoriesState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == CategoriesStatus.failure) {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Error'),
                content: const Text('Something went wrong with categories'),
                actions: [
                  TextButton(
                      onPressed: () {
                        context.pop();
                      },
                      child: const Text('OK')),
                ],
              ),
            );
          }
        },
        builder: (context, state) {
          return GridView.extent(
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            maxCrossAxisExtent: 350,
            childAspectRatio: 3,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            children: [
              ...state.categories.map(
                (category) => _CategoryItem(category: category),
              ),
            ],
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
          '${RouterConfiguration.categoriesToDeadlinesPath}/${category.id}',
        );
      },
      leading: Icon(IconData(category.icon)),
      title: Text(category.name),
      subtitle: Text(category.userEmail),
      tileColor: Color(category.color),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    );
  }
}

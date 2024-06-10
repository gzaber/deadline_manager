import 'package:categories_repository/categories_repository.dart';
import 'package:deadline_manager/category_details/category_details.dart';
import 'package:deadlines_repository/deadlines_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    final category =
        context.select((CategoryDetailsCubit cubit) => cubit.state.category);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(category.name),
        backgroundColor: Color(category.color),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      body: BlocConsumer<CategoryDetailsCubit, CategoryDetailsState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == CategoryDetailsStatus.failure) {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Error'),
                content: const Text('Something went wrong'),
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

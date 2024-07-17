import 'package:categories_repository/categories_repository.dart';
import 'package:deadline_manager/add_edit_category/add_edit_category.dart';
import 'package:deadline_manager/app/app.dart';
import 'package:deadline_manager/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AddEditCategoryPage extends StatelessWidget {
  const AddEditCategoryPage({
    super.key,
    this.category,
  });

  final Category? category;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddEditCategoryCubit(
        categoriesRepository: context.read<CategoriesRepository>(),
        category: category,
        user: context.read<AppCubit>().state.user,
      ),
      child: const AddEditCategoryView(),
    );
  }
}

class AddEditCategoryView extends StatelessWidget {
  const AddEditCategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.read<AddEditCategoryCubit>().state.initialCategory == null
              ? 'Create category'
              : 'Update category',
        ),
        actions: const [_SaveButton()],
      ),
      body: BlocListener<AddEditCategoryCubit, AddEditCategoryState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == AddEditCategoryStatus.success) {
            context.pop();
          }
          if (state.status == AddEditCategoryStatus.failure) {
            FailureSnackBar.show(
              context: context,
              text: 'Something went wrong',
            );
          }
        },
        child: const Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _NameField(),
              DescriptionText(description: 'Select color:'),
              _ColorSelector(colors: AppColors.categoryColors),
              DescriptionText(description: 'Select icon:'),
              _IconSelector(icons: AppIcons.categoryIcons),
            ],
          ),
        ),
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton();

  @override
  Widget build(BuildContext context) {
    final stateStatus =
        context.select((AddEditCategoryCubit cubit) => cubit.state.status);

    return IconButton(
      onPressed: () {
        context.read<AddEditCategoryCubit>().saveCategory();
      },
      icon: stateStatus == AddEditCategoryStatus.loading
          ? const CircularProgressIndicator()
          : const Icon(AppIcons.saveIcon),
    );
  }
}

class _NameField extends StatelessWidget {
  const _NameField();

  @override
  Widget build(BuildContext context) {
    final stateName =
        context.select((AddEditCategoryCubit cubit) => cubit.state.name);

    return TextFormField(
      initialValue: stateName,
      onChanged: (value) {
        context.read<AddEditCategoryCubit>().onNameChanged(value);
      },
      decoration: const InputDecoration(labelText: 'Category name'),
    );
  }
}

class _IconSelector extends StatelessWidget {
  const _IconSelector({
    required this.icons,
  });

  final List<IconData> icons;

  @override
  Widget build(BuildContext context) {
    final stateIcon =
        context.select((AddEditCategoryCubit cubit) => cubit.state.icon);

    return Wrap(
      spacing: 8,
      children: [
        ...icons.map(
          (icon) => ChoiceChip(
            onSelected: (_) {
              context
                  .read<AddEditCategoryCubit>()
                  .onIconChanged(icon.codePoint);
            },
            selected: icon.codePoint == stateIcon,
            label: Icon(icon),
          ),
        ),
      ],
    );
  }
}

class _ColorSelector extends StatelessWidget {
  const _ColorSelector({
    required this.colors,
  });

  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    final stateColor =
        context.select((AddEditCategoryCubit cubit) => cubit.state.color);

    return Wrap(
      spacing: 8,
      children: [
        ...colors.map(
          (color) => ChoiceChip(
            onSelected: (_) {
              context.read<AddEditCategoryCubit>().onColorChanged(color.value);
            },
            selected: color.value == stateColor,
            label: CircleAvatar(backgroundColor: color),
          ),
        ),
      ],
    );
  }
}

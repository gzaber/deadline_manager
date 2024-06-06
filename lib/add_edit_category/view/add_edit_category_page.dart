import 'package:categories_repository/categories_repository.dart';
import 'package:deadline_manager/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:deadline_manager/add_edit_category/add_edit_category.dart';

class AddEditCategoryPage extends StatelessWidget {
  const AddEditCategoryPage({
    super.key,
    this.category,
  });

  final Category? category;

  static Future<void> show({
    required BuildContext context,
    final Category? category,
  }) {
    return showDialog(
        context: context,
        builder: (_) {
          final showFullScreenDialog = MediaQuery.sizeOf(context).width < 640;
          final dialogContent = BlocProvider(
            create: (context) => AddEditCategoryCubit(
              categoriesRepository: context.read<CategoriesRepository>(),
              initialCategory: category,
              user: context.read<AppCubit>().state.user,
            ),
            child: AddEditCategoryPage(category: category),
          );

          if (showFullScreenDialog) {
            return Dialog.fullscreen(
              child: dialogContent,
            );
          } else {
            return Dialog(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: dialogContent,
              ),
            );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddEditCategoryCubit, AddEditCategoryState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == AddEditCategoryStatus.success) {
          Navigator.pop(context);
        }
        if (state.status == AddEditCategoryStatus.failure) {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Error'),
              content:
                  const Text('Something went wrong during saving category'),
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
        centerTitle: true,
        title: Text(
          context.read<AddEditCategoryCubit>().state.initialCategory == null
              ? 'Create category'
              : 'Update category',
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.cancel),
        ),
        actions: const [_SaveButton()],
      ),
      body: const Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _NameField(),
            SizedBox(height: 10),
            _IconSelector(icons: [Icons.share, Icons.edit, Icons.alarm]),
            SizedBox(height: 10),
            _ColorSelector(
                colors: [Colors.indigo, Colors.orange, Colors.purple]),
          ],
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
          : const Icon(Icons.save),
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
      decoration: const InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))),
      ),
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

    return ToggleButtons(
      onPressed: (index) => context
          .read<AddEditCategoryCubit>()
          .onIconChanged(icons[index].codePoint),
      isSelected: List.of(
        icons.map((icon) => icon.codePoint == stateIcon),
      ),
      children: [
        ...icons.map(
          (icon) => Icon(icon),
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

    return ToggleButtons(
      onPressed: (index) => context
          .read<AddEditCategoryCubit>()
          .onColorChanged(colors[index].value),
      isSelected: List.of(
        colors.map((color) => color.value == stateColor),
      ),
      children: [
        ...colors.map(
          (color) => CircleAvatar(backgroundColor: color),
        ),
      ],
    );
  }
}

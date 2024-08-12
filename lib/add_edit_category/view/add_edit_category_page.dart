import 'package:app_ui/app_ui.dart';
import 'package:categories_repository/categories_repository.dart';
import 'package:deadline_manager/add_edit_category/add_edit_category.dart';
import 'package:deadline_manager/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
              ? AppLocalizations.of(context)!.addEditCreateTitle
              : AppLocalizations.of(context)!.addEditUpdateTitle,
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
              text: AppLocalizations.of(context)!.failureMessage,
            );
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppInsets.xLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _NameField(),
                DescriptionText(
                    description: AppLocalizations.of(context)!
                        .addEditCategorySelectColorLabel),
                const _ColorSelector(colors: AppColors.categoryColors),
                DescriptionText(
                    description: AppLocalizations.of(context)!
                        .addEditCategorySelectIconLabel),
                const _IconSelector(icons: AppIcons.categoryIcons),
              ],
            ),
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
    final stateEmptyName = context
        .select((AddEditCategoryCubit cubit) => cubit.state.name.isEmpty);

    return IconButton(
      onPressed: () {
        stateEmptyName
            ? null
            : context.read<AddEditCategoryCubit>().saveCategory();
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
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)!.addEditCategoryNameLabel,
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

    return Wrap(
      spacing: AppInsets.medium,
      runSpacing: AppInsets.medium,
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
      spacing: AppInsets.medium,
      runSpacing: AppInsets.medium,
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

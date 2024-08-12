import 'package:app_ui/app_ui.dart';
import 'package:categories_repository/categories_repository.dart';
import 'package:deadline_manager/app/app.dart';
import 'package:deadline_manager/categories/categories.dart';
import 'package:deadlines_repository/deadlines_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:permissions_repository/permissions_repository.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CategoriesCubit(
        categoriesRepository: context.read<CategoriesRepository>(),
        deadlinesRepository: context.read<DeadlinesRepository>(),
        permissionsRepository: context.read<PermissionsRepository>(),
        user: context.read<AppCubit>().state.user,
      )..subscribeToCategories(),
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
        title: Text(AppLocalizations.of(context)!.categoriesTitle),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go(AppRouter.categoriesToAddEditCategoryLocation);
        },
        child: const Icon(AppIcons.fabIcon),
      ),
      body: BlocConsumer<CategoriesCubit, CategoriesState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == CategoriesStatus.failure) {
            FailureSnackBar.show(
              context: context,
              text: AppLocalizations.of(context)!.failureMessage,
            );
          }
        },
        builder: (context, state) {
          if (state.status == CategoriesStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state.categories.isEmpty) {
            return EmptyListInfo(
              text: AppLocalizations.of(context)!.emptyListMessage,
            );
          }
          return MasonryGridView.extent(
            padding: const EdgeInsets.symmetric(horizontal: AppInsets.medium),
            maxCrossAxisExtent: AppInsets.xxxLarge,
            mainAxisSpacing: AppInsets.medium,
            crossAxisSpacing: AppInsets.medium,
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
      leading: Icon(
        IconData(
          category.icon,
          fontFamily: AppIcons.iconFontFamily,
        ),
      ),
      trailing: UpdateDeleteMenuButton(
        updateText: AppLocalizations.of(context)!.menuUpdateOption,
        deleteText: AppLocalizations.of(context)!.menuDeleteOption,
        onUpdateTap: () {
          context.go(
            AppRouter.categoriesToAddEditCategoryLocation,
            extra: category,
          );
        },
        onDeleteTap: () async {
          await ConfirmationAlertDialog.show(
            context: context,
            title: AppLocalizations.of(context)!.dialogDeleteTitle,
            content: AppLocalizations.of(context)!.dialogDeleteCategoryContent,
            confirmButtonText:
                AppLocalizations.of(context)!.dialogConfirmButtonText,
            cancelButtonText:
                AppLocalizations.of(context)!.dialogCancelButtonText,
          ).then(
            (value) {
              if (value == true) {
                context.read<CategoriesCubit>().deleteCategory(category.id);
              }
            },
          );
        },
      ),
      title: Text(category.name),
      tileColor: Color(category.color),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(AppInsets.large),
        ),
      ),
    );
  }
}

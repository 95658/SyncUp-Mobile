import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncup/app/core/constants/constants.dart';
import 'package:syncup/app/core/extensions/size_extensions.dart';
import 'package:syncup/app/core/widgets/buttons/consumer_button.dart';
import 'package:syncup/app/core/widgets/inputs/custom_text_form_field.dart';
import 'package:syncup/app/features/projects/presentation/controller/projects_controller.dart';
import 'package:syncup/generated/i18n/translations.g.dart';

class CreateProjectBody extends ConsumerWidget {
  const CreateProjectBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logic = ref.read(projectsProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: Constants.horizontalPadding,
        vertical: Constants.verticalPadding,
      ),
      child: Form(
        key: logic.createFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextFormField(
              title: tr.projects.name,
              hint: tr.projects.nameHint,
              controller: logic.nameController,
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return tr.projects.nameRequired;
                }
                return null;
              },
            ),
            const Height(16),
            CustomTextFormField(
              title: tr.projects.description,
              hint: tr.projects.descriptionHint,
              controller: logic.descriptionController,
              maxLines: 4,
            ),
            const Height(32),
            ConsumerButton(
              title: tr.projects.create,
              onPress: logic.createProject,
              stateProvider: logic.isCreating,
            ),
          ],
        ),
      ),
    );
  }
}

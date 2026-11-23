import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncup/app/core/constants/constants.dart';
import 'package:syncup/app/core/extensions/size_extensions.dart';
import 'package:syncup/app/core/styles/style_atoms.dart';
import 'package:syncup/app/core/widgets/buttons/consumer_button.dart';
import 'package:syncup/app/core/widgets/buttons/custom_ink_well.dart';
import 'package:syncup/app/core/widgets/inputs/custom_text_form_field.dart';
import 'package:syncup/app/features/tasks/presentation/controller/tasks_controller.dart';
import 'package:syncup/generated/i18n/translations.g.dart';

class CreateTaskBody extends ConsumerWidget {
  final String projectId;

  const CreateTaskBody({super.key, required this.projectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logic = ref.read(tasksProvider);
    final selectedPriority = ref.watch(logic.selectedPriority.provider);

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
              title: tr.tasks.name,
              hint: tr.tasks.titleHint,
              controller: logic.titleController,
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return tr.tasks.titleRequired;
                }
                return null;
              },
            ),
            const Height(16),
            CustomTextFormField(
              title: tr.tasks.description,
              hint: tr.tasks.descriptionHint,
              controller: logic.descriptionController,
              maxLines: 4,
            ),
            const Height(20),
            Text(tr.tasks.priority, style: context.medium14TextMain),
            const Height(8),
            Row(
              children: [
                _PrioritySelector(
                  label: tr.tasks.priorityLow,
                  value: 'LOW',
                  isSelected: selectedPriority == 'LOW',
                  onTap: () => logic.selectedPriority.state = 'LOW',
                ),
                const Width(8),
                _PrioritySelector(
                  label: tr.tasks.priorityMedium,
                  value: 'MEDIUM',
                  isSelected: selectedPriority == 'MEDIUM',
                  onTap: () => logic.selectedPriority.state = 'MEDIUM',
                ),
                const Width(8),
                _PrioritySelector(
                  label: tr.tasks.priorityHigh,
                  value: 'HIGH',
                  isSelected: selectedPriority == 'HIGH',
                  onTap: () => logic.selectedPriority.state = 'HIGH',
                ),
                const Width(8),
                _PrioritySelector(
                  label: tr.tasks.priorityUrgent,
                  value: 'URGENT',
                  isSelected: selectedPriority == 'URGENT',
                  onTap: () => logic.selectedPriority.state = 'URGENT',
                ),
              ],
            ),
            const Height(36),
            ConsumerButton(
              title: tr.tasks.create,
              onPress: () => logic.createTask(projectId: projectId),
              stateProvider: logic.isCreating,
            ),
          ],
        ),
      ),
    );
  }
}

class _PrioritySelector extends StatelessWidget {
  final String label;
  final String value;
  final bool isSelected;
  final VoidCallback onTap;

  const _PrioritySelector({
    required this.label,
    required this.value,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CustomInkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? Theme.of(context).primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? Theme.of(context).primaryColor : const Color(0xFFE2E8F0),
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: isSelected
                ? context.medium12Primary.copyWith(color: Colors.white)
                : context.roman12Secondary,
          ),
        ),
      ),
    );
  }
}

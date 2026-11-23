import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncup/app/core/constants/constants.dart';
import 'package:syncup/app/core/extensions/size_extensions.dart';
import 'package:syncup/app/core/styles/style_atoms.dart';
import 'package:syncup/app/core/themes/app_colors.dart';
import 'package:syncup/app/core/widgets/common/empty_state_view.dart';
import 'package:syncup/app/core/widgets/common/shimmer_box.dart';
import 'package:syncup/app/features/teams/data/models/team_model.dart';
import 'package:syncup/app/features/teams/presentation/controller/teams_controller.dart';
import 'package:syncup/generated/i18n/translations.g.dart';

class TeamsBody extends ConsumerWidget {
  const TeamsBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logic = ref.read(teamsProvider);
    final isLoading = ref.watch(logic.isLoading.provider);
    final teams = ref.watch(logic.teams.provider);

    if (isLoading && teams.isEmpty) {
      return ListView.separated(
        padding: const EdgeInsets.all(Constants.horizontalPadding),
        itemCount: 4,
        separatorBuilder: (_, __) => const Height(12),
        itemBuilder: (_, __) => const ShimmerBox(height: 90),
      );
    }

    if (teams.isEmpty) {
      return EmptyStateView(
        title: tr.teams.noTeams,
        subtitle: tr.teams.noTeamsSubtitle,
        icon: Icons.groups_2_outlined,
        actionTitle: tr.teams.createFirstTeam,
        onAction: () => _showCreateTeamDialog(context, logic),
      );
    }

    return RefreshIndicator.adaptive(
      onRefresh: logic.fetchTeams,
      child: ListView.separated(
        padding: const EdgeInsets.all(Constants.horizontalPadding),
        itemCount: teams.length,
        separatorBuilder: (_, __) => const Height(12),
        itemBuilder: (context, index) {
          final team = teams[index];
          return _TeamCard(team: team, logic: logic);
        },
      ),
    );
  }

  void _showCreateTeamDialog(BuildContext context, dynamic logic) {
    final nameCtrl = TextEditingController();
    final descCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.bgSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(tr.teams.createTeam, style: ctx.bold18TextMain),
              const Height(16),
              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(
                  labelText: tr.teams.teamName,
                  hintText: tr.teams.teamNameHint,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const Height(12),
              TextField(
                controller: descCtrl,
                decoration: InputDecoration(
                  labelText: tr.teams.teamDescription,
                  hintText: tr.teams.teamDescriptionHint,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const Height(20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () async {
                    if (nameCtrl.text.trim().isNotEmpty) {
                      Navigator.pop(ctx);
                      await logic.createTeam(
                        name: nameCtrl.text.trim(),
                        description: descCtrl.text.trim(),
                      );
                    }
                  },
                  child: Text(tr.teams.createTeam, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TeamCard extends StatelessWidget {
  final TeamModel team;
  final dynamic logic;

  const _TeamCard({required this.team, required this.logic});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(Constants.borderRadius),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.groups_outlined, color: AppColors.primary, size: 20),
              ),
              const Width(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(team.name, style: context.bold16TextMain),
                    if (team.description != null && team.description!.isNotEmpty)
                      Text(
                        team.description!,
                        style: context.roman12Secondary,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.bgSubtle,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: Text(
                  '${team.memberCount} Members',
                  style: context.medium10Muted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

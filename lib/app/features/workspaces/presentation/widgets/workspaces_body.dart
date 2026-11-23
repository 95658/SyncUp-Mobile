import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncup/app/core/constants/constants.dart';
import 'package:syncup/app/core/extensions/size_extensions.dart';
import 'package:syncup/app/core/styles/style_atoms.dart';
import 'package:syncup/app/core/themes/app_colors.dart';
import 'package:syncup/app/core/widgets/buttons/custom_ink_well.dart';
import 'package:syncup/app/core/widgets/common/empty_state_view.dart';
import 'package:syncup/app/core/widgets/common/shimmer_box.dart';
import 'package:syncup/app/core/widgets/images/custom_cached_network_image.dart';
import 'package:syncup/app/features/super_admin/presentation/controller/super_admin_controller.dart';
import 'package:syncup/app/features/super_admin/presentation/widgets/admin_profile_modal.dart';
import 'package:syncup/app/features/workspaces/data/models/organization_model.dart';
import 'package:syncup/app/features/workspaces/presentation/controller/workspaces_controller.dart';
import 'package:syncup/app/services/storage_service.dart';
import 'package:syncup/generated/i18n/translations.g.dart';

class WorkspacesBody extends ConsumerWidget {
  const WorkspacesBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logic = ref.read(workspacesProvider);
    final storage = ref.read(storageServiceProvider);
    final user = storage.getUser();
    final isPlatformOwner = user?['isPlatformOwner'] == true;
    final superAdminLogic = ref.read(superAdminProvider);
    final analytics = ref.watch(superAdminLogic.analytics.provider);

    final isLoading = ref.watch(logic.isLoading.provider);
    final orgs = ref.watch(logic.organizations.provider);
    final selected = ref.watch(logic.selectedOrg.provider);

    if (isLoading && orgs.isEmpty) {
      return ListView.separated(
        padding: const EdgeInsets.all(Constants.horizontalPadding),
        itemCount: 4,
        separatorBuilder: (_, __) => const Height(12),
        itemBuilder: (_, __) => const ShimmerBox(height: 72),
      );
    }

    if (orgs.isEmpty) {
      return EmptyStateView(
        title: tr.workspace.noWorkspaces,
        subtitle: tr.workspace.noWorkspacesSubtitle,
        actionTitle: tr.common.retry,
        onAction: logic.fetchOrganizations,
      );
    }

    // Platform Owner Super Admin View (Matching Web Dashboard)
    if (isPlatformOwner) {
      final totalOrgsCount = (analytics['totalOrganizations'] as num?)?.toInt() ?? orgs.length;
      final totalUsersCount = (analytics['totalUsers'] as num?)?.toInt() ?? (analytics['activeUsers'] as num?)?.toInt() ?? orgs.length;
      final systemHealth = (analytics['systemHealth'] as String?) ?? '100%';

      return RefreshIndicator.adaptive(
        onRefresh: () async {
          await logic.fetchOrganizations();
          await superAdminLogic.fetchAnalytics();
        },
        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: Constants.horizontalPadding,
            vertical: 16,
          ),
          children: [
            // 1. Control Plane Pill Badge & Admin Profile Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.primaryBorder),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const Width(6),
                      Text(
                        tr.superAdmin.controlPlane.toUpperCase(),
                        style: context.bold10Primary.copyWith(letterSpacing: 0.5),
                      ),
                    ],
                  ),
                ),
                CustomInkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => showAdminProfileModal(context, ref),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.bgSurface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.borderLight),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.account_circle_outlined, size: 16, color: AppColors.primary),
                        const Width(5),
                        Text(
                          tr.settings.profile,
                          style: context.bold10Primary,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const Height(10),

            // 2. Title & Subtitle
            Text(
              tr.superAdmin.dashboardTitle,
              style: context.bold22TextMain,
            ),
            const Height(4),
            Text(
              tr.superAdmin.dashboardSubtitle,
              style: context.roman13Secondary,
            ),
            const Height(18),

            // 3. ERP Financial & Platform Metrics Cards
            Row(
              children: [
                Expanded(
                  child: _MetricCard(
                    icon: Icons.payments_outlined,
                    iconColor: AppColors.success,
                    title: '\$${((analytics['totalRevenue'] as num?) ?? 0).toInt()}',
                    subtitle: tr.superAdmin.paidRevenue,
                    badge: tr.superAdmin.erpIncome,
                  ),
                ),
                const Width(12),
                Expanded(
                  child: _MetricCard(
                    icon: Icons.domain_rounded,
                    iconColor: AppColors.primary,
                    title: '$totalOrgsCount',
                    subtitle: tr.superAdmin.clientOrgs,
                    badge: tr.superAdmin.enterprise,
                  ),
                ),
              ],
            ),
            const Height(12),
            Row(
              children: [
                Expanded(
                  child: _MetricCard(
                    icon: Icons.people_outline_rounded,
                    iconColor: const Color(0xFF0284C7),
                    title: '$totalUsersCount',
                    subtitle: tr.superAdmin.platformUsers,
                    badge: tr.superAdmin.verified,
                  ),
                ),
                const Width(12),
                Expanded(
                  child: _MetricCard(
                    icon: Icons.dns_outlined,
                    iconColor: const Color(0xFF10B981),
                    title: systemHealth,
                    subtitle: tr.superAdmin.engineStatus,
                    badge: tr.superAdmin.operational,
                  ),
                ),
              ],
            ),
            const Height(24),

            // 4. Client Organizations Section Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${tr.superAdmin.activeClientTenants} (${orgs.length})',
                  style: context.bold16TextMain,
                ),
                CustomInkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () => _showProvisionOrgModal(context, ref),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.add_rounded, color: Colors.white, size: 14),
                        const Width(4),
                        Text(
                          tr.superAdmin.provisionTenant,
                          style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const Height(12),

            // 5. Tenant Cards
            ...orgs.map((org) {
              final isCurrent = selected?.id == org.id;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _OrganizationCard(
                  org: org,
                  isCurrent: isCurrent,
                  isPlatformOwner: true,
                  onTap: () => _showTenantGovernanceModal(context, ref, org),
                ),
              );
            }),
          ],
        ),
      );
    }

    // Regular Organization Member Workspaces List
    return RefreshIndicator.adaptive(
      onRefresh: logic.fetchOrganizations,
      child: ListView.separated(
        padding: const EdgeInsets.all(Constants.horizontalPadding),
        itemCount: orgs.length,
        separatorBuilder: (_, __) => const Height(12),
        itemBuilder: (context, index) {
          final org = orgs[index];
          final isCurrent = selected?.id == org.id;

          return _OrganizationCard(
            org: org,
            isCurrent: isCurrent,
            isPlatformOwner: false,
            onTap: () => logic.selectOrganization(org),
          );
        },
      ),
    );
  }

  void _showTenantGovernanceModal(BuildContext context, WidgetRef ref, OrganizationModel org) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.bgSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final isSuspended = org.status.toUpperCase() != 'ACTIVE';

        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 12,
            bottom: MediaQuery.of(ctx).padding.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Drag Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.borderLight,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const Height(16),

              // 2. Organization Header
              Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.primaryBorder),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      org.name.isNotEmpty ? org.name[0].toUpperCase() : 'O',
                      style: context.bold16Primary,
                    ),
                  ),
                  const Width(14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                org.name,
                                style: context.bold18TextMain,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const Width(8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.primaryLight,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: AppColors.primaryBorder),
                              ),
                              child: Text(
                                org.plan.toUpperCase(),
                                style: context.bold10Primary,
                              ),
                            ),
                          ],
                        ),
                        const Height(4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: !isSuspended
                                    ? AppColors.success.withAlpha(20)
                                    : AppColors.danger.withAlpha(20),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                org.status.toUpperCase(),
                                style: !isSuspended
                                    ? context.bold10Success
                                    : context.bold10Primary.copyWith(color: AppColors.danger),
                              ),
                            ),
                            const Width(8),
                            Text(
                              '${tr.superAdmin.slug}: /${org.slug}',
                              style: context.roman12Secondary,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Height(16),
              const Divider(height: 1, color: AppColors.borderLight),
              const Height(16),

              // 3. Organization Metadata & Resources Grid (2x2)
              Text(
                tr.superAdmin.tenantResources,
                style: context.bold14TextMain,
              ),
              const Height(10),
              Row(
                children: [
                  Expanded(
                    child: _DetailMiniCard(
                      icon: Icons.people_outline_rounded,
                      iconColor: const Color(0xFF0284C7),
                      label: tr.superAdmin.totalMembers,
                      value: '${org.memberCount}',
                    ),
                  ),
                  const Width(10),
                  Expanded(
                    child: _DetailMiniCard(
                      icon: Icons.folder_outlined,
                      iconColor: AppColors.primary,
                      label: tr.superAdmin.activeProjects,
                      value: '${org.projectCount}',
                    ),
                  ),
                ],
              ),
              const Height(10),
              Row(
                children: [
                  Expanded(
                    child: _DetailMiniCard(
                      icon: Icons.groups_outlined,
                      iconColor: const Color(0xFF8B5CF6),
                      label: tr.superAdmin.workTeams,
                      value: '${org.teamCount}',
                    ),
                  ),
                  const Width(10),
                  Expanded(
                    child: _DetailMiniCard(
                      icon: Icons.tag_rounded,
                      iconColor: AppColors.success,
                      label: tr.superAdmin.chatChannels,
                      value: '${org.channelCount}',
                    ),
                  ),
                ],
              ),
              const Height(16),

              // 4. Primary Admin Lead Info
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.bgSubtle,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.admin_panel_settings_outlined, size: 16, color: AppColors.primary),
                        const Width(6),
                        Text(
                          tr.superAdmin.primaryAdminLead,
                          style: context.bold12TextMain,
                        ),
                      ],
                    ),
                    const Height(8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${tr.common.name}:', style: context.roman12Secondary),
                        Text(
                          org.adminName ?? tr.superAdmin.primaryAdminLead,
                          style: context.medium12TextMain,
                        ),
                      ],
                    ),
                    const Height(4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${tr.superAdmin.adminWorkEmail}:', style: context.roman12Secondary),
                        Text(
                          org.adminEmail ?? 'admin@${org.slug}.com',
                          style: context.medium12TextMain,
                        ),
                      ],
                    ),
                    const Height(4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${tr.superAdmin.tenantId}:', style: context.roman12Secondary),
                        Text(
                          org.id.length > 14 ? '${org.id.substring(0, 14)}...' : org.id,
                          style: context.roman12Secondary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Height(20),

              // 5. Governance Control Actions
              // Action 1: Suspend / Reactivate Organization
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSuspended ? AppColors.success : AppColors.danger,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  icon: Icon(
                    isSuspended ? Icons.play_circle_outline : Icons.pause_circle_outline,
                    color: Colors.white,
                    size: 18,
                  ),
                  label: Text(
                    isSuspended ? tr.superAdmin.reactivateOrg : tr.superAdmin.suspendOrg,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  onPressed: () async {
                    Navigator.pop(ctx);
                    final success = await ref.read(superAdminProvider).toggleOrgStatus(org.id, org.status);
                    if (success && context.mounted) {
                      ref.read(workspacesProvider).fetchOrganizations();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isSuspended
                                ? '${tr.superAdmin.orgReactivated}: ${org.name}'
                                : '${tr.superAdmin.orgSuspended}: ${org.name}',
                          ),
                          backgroundColor: isSuspended ? AppColors.success : AppColors.danger,
                        ),
                      );
                    }
                  },
                ),
              ),
              const Height(10),

              // Action 2: Delete Organization
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.danger,
                    side: const BorderSide(color: AppColors.danger),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  icon: const Icon(Icons.delete_outline_rounded, color: AppColors.danger, size: 18),
                  label: Text(
                    tr.superAdmin.deleteOrg,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (dialogCtx) => AlertDialog(
                        backgroundColor: AppColors.bgSurface,
                        title: Text(tr.superAdmin.deleteOrgConfirmTitle, style: dialogCtx.bold18TextMain),
                        content: Text(
                          tr.superAdmin.deleteOrgConfirmMessage,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(dialogCtx),
                            child: Text(tr.common.cancel),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
                            onPressed: () async {
                              Navigator.pop(dialogCtx);
                              Navigator.pop(ctx);
                              final success = await ref.read(superAdminProvider).deleteOrganization(org.id);
                              if (success && context.mounted) {
                                ref.read(workspacesProvider).fetchOrganizations();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('${tr.superAdmin.orgDeleted}: ${org.name}'),
                                    backgroundColor: AppColors.danger,
                                  ),
                                );
                              }
                            },
                            child: Text(tr.superAdmin.deletePermanently, style: const TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showProvisionOrgModal(BuildContext context, WidgetRef ref) {
    final nameCtrl = TextEditingController();
    final adminEmailCtrl = TextEditingController();
    final adminNameCtrl = TextEditingController();

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
              Text(tr.superAdmin.provisionModalTitle, style: ctx.bold18TextMain),
              const Height(16),
              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(
                  labelText: tr.superAdmin.companyName,
                  hintText: tr.superAdmin.companyNameHint,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const Height(12),
              TextField(
                controller: adminNameCtrl,
                decoration: InputDecoration(
                  labelText: tr.superAdmin.primaryAdminName,
                  hintText: tr.superAdmin.primaryAdminNameHint,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const Height(12),
              TextField(
                controller: adminEmailCtrl,
                decoration: InputDecoration(
                  labelText: tr.superAdmin.adminWorkEmail,
                  hintText: tr.superAdmin.adminWorkEmailHint,
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
                    if (nameCtrl.text.trim().isNotEmpty && adminEmailCtrl.text.trim().isNotEmpty) {
                      Navigator.pop(ctx);
                      final success = await ref.read(superAdminProvider).createOrganization(
                        name: nameCtrl.text.trim(),
                        adminEmail: adminEmailCtrl.text.trim(),
                        adminName: adminNameCtrl.text.trim(),
                      );
                      if (success) {
                        ref.read(workspacesProvider).fetchOrganizations();
                      }
                    }
                  },
                  child: Text(tr.superAdmin.provisionTenant, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DetailMiniCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _DetailMiniCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.bgSubtle,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: iconColor.withAlpha(20),
              borderRadius: BorderRadius.circular(6),
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: iconColor, size: 16),
          ),
          const Width(10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: context.bold16TextMain,
              ),
              Text(
                label,
                style: context.roman10Muted,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String badge;

  const _MetricCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(Constants.borderRadius + 2),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: iconColor.withAlpha(25),
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Icon(icon, color: iconColor, size: 17),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.bgSubtle,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  badge,
                  style: context.medium10Muted,
                ),
              ),
            ],
          ),
          const Height(10),
          Text(
            title,
            style: context.bold18TextMain.copyWith(letterSpacing: -0.4),
          ),
          const Height(2),
          Text(
            subtitle,
            style: context.roman12Secondary,
          ),
        ],
      ),
    );
  }
}

class _OrganizationCard extends StatelessWidget {
  final OrganizationModel org;
  final bool isCurrent;
  final bool isPlatformOwner;
  final VoidCallback onTap;

  const _OrganizationCard({
    required this.org,
    required this.isCurrent,
    this.isPlatformOwner = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomInkWell(
      borderRadius: BorderRadius.circular(Constants.borderRadius),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.bgSurface,
          borderRadius: BorderRadius.circular(Constants.borderRadius + 2),
          border: Border.all(
            color: isCurrent ? AppColors.primary : AppColors.borderLight,
            width: isCurrent ? 1.5 : 1.0,
          ),
          boxShadow: isCurrent
              ? [
                  BoxShadow(
                    color: AppColors.primary.withAlpha(25),
                    offset: const Offset(0, 4),
                    blurRadius: 12,
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            CustomCachedNetworkImage(
              imageUrl: org.logoUrl,
              width: 44,
              height: 44,
              borderRadius: 8,
              errorWidget: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.primaryBorder),
                ),
                alignment: Alignment.center,
                child: Text(
                  org.name.isNotEmpty ? org.name[0].toUpperCase() : 'O',
                  style: context.bold16Primary,
                ),
              ),
            ),
            const Width(14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          org.name,
                          style: context.bold16TextMain,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Width(8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: AppColors.primaryBorder),
                        ),
                        child: Text(
                          org.plan.toUpperCase(),
                          style: context.bold10Primary,
                        ),
                      ),
                    ],
                  ),
                  const Height(4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                        decoration: BoxDecoration(
                          color: org.status.toUpperCase() == 'ACTIVE'
                              ? AppColors.success.withAlpha(20)
                              : AppColors.danger.withAlpha(20),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          org.status.toUpperCase(),
                          style: org.status.toUpperCase() == 'ACTIVE'
                              ? context.bold10Success
                              : context.bold10Primary.copyWith(color: AppColors.danger),
                        ),
                      ),
                      const Width(8),
                      Text(
                        org.role != null && org.role!.isNotEmpty
                            ? '${org.role} • ${tr.workspace.title}'
                            : tr.common.activeWorkspace,
                        style: context.roman12Secondary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Width(8),
            if (isPlatformOwner)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.primaryBorder),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.settings_outlined,
                      size: 13,
                      color: AppColors.primary,
                    ),
                    const Width(4),
                    Text(
                      tr.common.manage,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              )
            else if (isCurrent)
              const Icon(
                Icons.check_circle_rounded,
                color: AppColors.primary,
                size: 22,
              )
            else
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textMuted,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}

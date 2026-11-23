import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncup/app/core/constants/constants.dart';
import 'package:syncup/app/core/extensions/size_extensions.dart';
import 'package:syncup/app/core/styles/style_atoms.dart';
import 'package:syncup/app/core/themes/app_colors.dart';
import 'package:syncup/app/core/widgets/common/empty_state_view.dart';
import 'package:syncup/app/core/widgets/common/shimmer_box.dart';
import 'package:syncup/app/features/calendar/data/models/meeting_model.dart';
import 'package:syncup/app/features/calendar/presentation/controller/calendar_controller.dart';
import 'package:syncup/generated/i18n/translations.g.dart';

class CalendarBody extends ConsumerWidget {
  const CalendarBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logic = ref.read(calendarProvider);
    final isLoading = ref.watch(logic.isLoading.provider);
    final meetings = ref.watch(logic.meetings.provider);

    if (isLoading && meetings.isEmpty) {
      return ListView.separated(
        padding: const EdgeInsets.all(Constants.horizontalPadding),
        itemCount: 4,
        separatorBuilder: (_, __) => const Height(12),
        itemBuilder: (_, __) => const ShimmerBox(height: 80),
      );
    }

    if (meetings.isEmpty) {
      return EmptyStateView(
        title: tr.calendar.noMeetings,
        subtitle: tr.calendar.noMeetingsSubtitle,
        icon: Icons.calendar_today_outlined,
        actionTitle: tr.calendar.scheduleMeeting,
        onAction: () => _showScheduleDialog(context, logic),
      );
    }

    return RefreshIndicator.adaptive(
      onRefresh: logic.fetchMeetings,
      child: ListView.separated(
        padding: const EdgeInsets.all(Constants.horizontalPadding),
        itemCount: meetings.length,
        separatorBuilder: (_, __) => const Height(12),
        itemBuilder: (context, index) {
          final meeting = meetings[index];
          return _MeetingCard(meeting: meeting);
        },
      ),
    );
  }

  void _showScheduleDialog(BuildContext context, dynamic logic) {
    final titleCtrl = TextEditingController();
    final urlCtrl = TextEditingController();

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
              Text(tr.calendar.scheduleNewMeeting, style: ctx.bold18TextMain),
              const Height(16),
              TextField(
                controller: titleCtrl,
                decoration: InputDecoration(
                  labelText: tr.calendar.meetingTitle,
                  hintText: tr.calendar.meetingTitleHint,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const Height(12),
              TextField(
                controller: urlCtrl,
                decoration: InputDecoration(
                  labelText: tr.calendar.meetingUrl,
                  hintText: tr.calendar.meetingUrlHint,
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
                    if (titleCtrl.text.trim().isNotEmpty) {
                      Navigator.pop(ctx);
                      final now = DateTime.now();
                      await logic.createMeeting(
                        title: titleCtrl.text.trim(),
                        startTime: now.add(const Duration(hours: 1)),
                        endTime: now.add(const Duration(hours: 2)),
                        meetingUrl: urlCtrl.text.trim(),
                      );
                    }
                  },
                  child: Text(tr.calendar.scheduleMeeting, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MeetingCard extends StatelessWidget {
  final MeetingModel meeting;

  const _MeetingCard({required this.meeting});

  @override
  Widget build(BuildContext context) {
    final startHour = '${meeting.startTime.hour.toString().padLeft(2, '0')}:${meeting.startTime.minute.toString().padLeft(2, '0')}';
    final endHour = '${meeting.endTime.hour.toString().padLeft(2, '0')}:${meeting.endTime.minute.toString().padLeft(2, '0')}';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(Constants.borderRadius),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.primaryBorder),
            ),
            child: Column(
              children: [
                Text(
                  '${meeting.startTime.day}',
                  style: context.bold18TextMain.copyWith(color: AppColors.primary),
                ),
                Text(
                  startHour,
                  style: context.bold10Primary,
                ),
              ],
            ),
          ),
          const Width(14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(meeting.title, style: context.bold16TextMain),
                const Height(2),
                Text('$startHour - $endHour', style: context.roman12Secondary),
                if (meeting.meetingUrl != null && meeting.meetingUrl!.isNotEmpty)
                  Text(
                    meeting.meetingUrl!,
                    style: context.roman12Secondary.copyWith(color: const Color(0xFF2563EB)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          const Icon(Icons.videocam_outlined, color: AppColors.primary, size: 22),
        ],
      ),
    );
  }
}

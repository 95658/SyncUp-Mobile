import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncup/app/core/api_helper/exceptions.dart';
import 'package:syncup/app/core/models/custom_state.dart';
import 'package:syncup/app/features/calendar/data/models/meeting_model.dart';
import 'package:syncup/app/features/calendar/data/service/calendar_service.dart';

final calendarProvider = Provider<_CalendarLogic>(
  (ref) => _CalendarLogic(
    ref: ref,
    service: ref.watch(calendarServiceProvider),
  ),
);

class _CalendarLogic extends _CalendarStates {
  final CalendarService service;

  _CalendarLogic({
    required super.ref,
    required this.service,
  });

  Future<void> fetchMeetings() async {
    try {
      isLoading.state = true;
      isError.state = '';
      final list = await service.getMeetings();
      meetings.state = list;
    } on ApiException catch (e) {
      isError.state = e.toString();
    } catch (e) {
      isError.state = 'Failed to load meetings';
    } finally {
      isLoading.state = false;
    }
  }

  Future<bool> createMeeting({
    required String title,
    String? description,
    required DateTime startTime,
    required DateTime endTime,
    String? meetingUrl,
  }) async {
    try {
      isActionLoading.state = true;
      final created = await service.createMeeting(
        title: title,
        description: description,
        startTime: startTime,
        endTime: endTime,
        meetingUrl: meetingUrl,
      );
      meetings.state = [...meetings.state, created];
      return true;
    } catch (e) {
      isError.state = 'Failed to schedule meeting';
      return false;
    } finally {
      isActionLoading.state = false;
    }
  }
}

class _CalendarStates {
  final Ref ref;
  final CustomState<bool> isLoading;
  final CustomState<bool> isActionLoading;
  final CustomState<String> isError;
  final CustomState<List<MeetingModel>> meetings;

  _CalendarStates({required this.ref})
      : isLoading = CustomState(ref, false),
        isActionLoading = CustomState(ref, false),
        isError = CustomState(ref, ''),
        meetings = CustomState(ref, []);
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncup/app/core/api_helper/dio_client.dart';
import 'package:syncup/app/core/api_helper/endpoints.dart';
import 'package:syncup/app/core/api_helper/exceptions.dart';
import 'package:syncup/app/core/api_helper/response_client.dart';
import 'package:syncup/app/core/constants/typedefs.dart';
import 'package:syncup/app/features/calendar/data/models/meeting_model.dart';
import 'package:syncup/app/services/storage_service.dart';

final calendarServiceProvider = Provider<CalendarService>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  return CalendarService(ref.watch(dioClientProvider), storageService);
});

class CalendarService {
  final DioClient client;
  final StorageService storageService;

  CalendarService(this.client, this.storageService);

  String _getOrgId() {
    final orgId = storageService.getActiveOrgId();
    if (orgId == null || orgId.isEmpty) {
      throw ApiExceptionMessage('No active organization selected');
    }
    return orgId;
  }

  // 1. GET /organizations/:orgId/calendar/meetings
  Future<List<MeetingModel>> getMeetings() async {
    final orgId = _getOrgId();
    final res = ResponseClient<dynamic>(
      await client.get(Endpoints.meetings(orgId)),
    );

    if (res.isError) {
      throw ApiExceptionMessage(res.message, statusCode: res.statusCode);
    }

    final data = res.data;
    if (data is List) {
      return data.map((item) => MeetingModel.fromJson(item as Json)).toList();
    }
    return [];
  }

  // 2. POST /organizations/:orgId/calendar/meetings
  Future<MeetingModel> createMeeting({
    required String title,
    String? description,
    required DateTime startTime,
    required DateTime endTime,
    String? meetingUrl,
    String? location,
  }) async {
    final orgId = _getOrgId();
    final res = ResponseClient<Json>(
      await client.post(
        Endpoints.meetings(orgId),
        body: {
          'title': title.trim(),
          if (description != null && description.isNotEmpty) 'description': description.trim(),
          'startTime': startTime.toIso8601String(),
          'endTime': endTime.toIso8601String(),
          if (meetingUrl != null && meetingUrl.isNotEmpty) 'meetingUrl': meetingUrl.trim(),
          if (location != null && location.isNotEmpty) 'location': location.trim(),
        },
      ),
    );

    if (res.isError) {
      throw ApiExceptionMessage(res.message, statusCode: res.statusCode);
    }

    return MeetingModel.fromJson(res.data!);
  }
}

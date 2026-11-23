import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncup/app/core/api_helper/exceptions.dart';
import 'package:syncup/app/core/models/custom_state.dart';
import 'package:syncup/app/features/teams/data/models/team_model.dart';
import 'package:syncup/app/features/teams/data/service/teams_service.dart';

final teamsProvider = Provider<_TeamsLogic>(
  (ref) => _TeamsLogic(
    ref: ref,
    service: ref.watch(teamsServiceProvider),
  ),
);

class _TeamsLogic extends _TeamsStates {
  final TeamsService service;

  _TeamsLogic({
    required super.ref,
    required this.service,
  });

  Future<void> fetchTeams() async {
    try {
      isLoading.state = true;
      isError.state = '';
      final list = await service.getTeams();
      teams.state = list;
    } on ApiException catch (e) {
      isError.state = e.toString();
    } catch (e) {
      isError.state = 'Failed to load teams';
    } finally {
      isLoading.state = false;
    }
  }

  Future<bool> createTeam({required String name, String? description, String? leadId}) async {
    try {
      isActionLoading.state = true;
      final created = await service.createTeam(name: name, description: description, leadId: leadId);
      teams.state = [...teams.state, created];
      return true;
    } catch (e) {
      isError.state = 'Failed to create team';
      return false;
    } finally {
      isActionLoading.state = false;
    }
  }

  Future<bool> deleteTeam(String teamId) async {
    try {
      isActionLoading.state = true;
      await service.deleteTeam(teamId);
      teams.state = teams.state.where((t) => t.id != teamId).toList();
      return true;
    } catch (e) {
      isError.state = 'Failed to delete team';
      return false;
    } finally {
      isActionLoading.state = false;
    }
  }
}

class _TeamsStates {
  final Ref ref;
  final CustomState<bool> isLoading;
  final CustomState<bool> isActionLoading;
  final CustomState<String> isError;
  final CustomState<List<TeamModel>> teams;

  _TeamsStates({required this.ref})
      : isLoading = CustomState(ref, false),
        isActionLoading = CustomState(ref, false),
        isError = CustomState(ref, ''),
        teams = CustomState(ref, []);
}

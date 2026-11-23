class Endpoints {
  Endpoints._();

  // Auth
  static const String login = '/auth/login';
  static const String acceptInvitation = '/auth/accept-invitation';
  static const String refresh = '/auth/refresh';
  static const String logout = '/auth/logout';
  static const String me = '/auth/me';
  static const String changePassword = '/auth/change-password';

  // Super Admin (Platform Control Plane)
  static const String superAdminOrganizations = '/super-admin/organizations';
  static const String superAdminAnalytics = '/super-admin/analytics';
  static String superAdminOrgStatus(String id) => '/super-admin/organizations/$id/status';
  static String superAdminOrgDelete(String id) => '/super-admin/organizations/$id';
  static const String superAdminAdministrators = '/super-admin/administrators';
  static String superAdminAdminStatus(String id) => '/super-admin/administrators/$id/status';

  // Organizations & Members
  static const String organizations = '/organizations';
  static String organization(String orgId) => '/organizations/$orgId';
  static String orgSettings(String orgId) => '/organizations/$orgId/settings';
  static String orgMembers(String orgId) => '/organizations/$orgId/members';
  static String orgMemberRole(String orgId, String memberId) => '/organizations/$orgId/members/$memberId/role';
  static String orgMemberStatus(String orgId, String memberId) => '/organizations/$orgId/members/$memberId/status';
  static String orgMemberDelete(String orgId, String memberId) => '/organizations/$orgId/members/$memberId';
  static String orgInvitations(String orgId) => '/organizations/$orgId/invitations';
  static String orgInvitationDelete(String orgId, String invId) => '/organizations/$orgId/invitations/$invId';

  // Projects
  static String projects(String orgId) => '/organizations/$orgId/projects';
  static String project(String orgId, String projectId) => '/organizations/$orgId/projects/$projectId';
  static String projectMembers(String orgId, String projectId) => '/organizations/$orgId/projects/$projectId/members';
  static String projectMemberDelete(String orgId, String projectId, String memberId) =>
      '/organizations/$orgId/projects/$projectId/members/$memberId';
  static String projectDocuments(String orgId, String projectId) =>
      '/organizations/$orgId/projects/$projectId/documents';
  static String projectAnalytics(String orgId, String projectId) =>
      '/organizations/$orgId/projects/$projectId/analytics';

  // Tasks
  static String tasks(String orgId) => '/organizations/$orgId/tasks';
  static String task(String orgId, String taskId) => '/organizations/$orgId/tasks/$taskId';
  static String taskStatus(String orgId, String taskId) => '/organizations/$orgId/tasks/$taskId/status';
  static String taskSubtasks(String orgId, String taskId) => '/organizations/$orgId/tasks/$taskId/subtasks';
  static String taskSubtask(String orgId, String taskId, String subtaskId) =>
      '/organizations/$orgId/tasks/$taskId/subtasks/$subtaskId';
  static String taskComments(String orgId, String taskId) => '/organizations/$orgId/tasks/$taskId/comments';

  // Channels & Messages
  static String channels(String orgId) => '/organizations/$orgId/channels';
  static String channel(String orgId, String channelId) => '/organizations/$orgId/channels/$channelId';
  static String channelMessages(String orgId, String channelId) =>
      '/organizations/$orgId/channels/$channelId/messages';
  static String messageReactions(String orgId, String messageId) =>
      '/organizations/$orgId/messages/$messageId/reactions';
  static String messageThread(String orgId, String messageId) =>
      '/organizations/$orgId/messages/$messageId/thread';

  // Teams & Squads
  static String teams(String orgId) => '/organizations/$orgId/teams';
  static String team(String orgId, String teamId) => '/organizations/$orgId/teams/$teamId';
  static String teamMembers(String orgId, String teamId) => '/organizations/$orgId/teams/$teamId/members';
  static String teamMemberDelete(String orgId, String teamId, String memberId) =>
      '/organizations/$orgId/teams/$teamId/members/$memberId';

  // Calendar & Meetings
  static String meetings(String orgId) => '/organizations/$orgId/calendar/meetings';

  // Notifications
  static const String notifications = '/notifications';
  static String readNotification(String id) => '/notifications/$id/read';
  static const String readAllNotifications = '/notifications/read-all';
  static const String notificationDeviceToken = '/notifications/device-token';

  // Users
  static const String usersProfile = '/users/profile';
  static String user(String id) => '/users/$id';
}

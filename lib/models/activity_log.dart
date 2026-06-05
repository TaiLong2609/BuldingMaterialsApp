class ActivityLog {
  const ActivityLog({this.id, required this.actor, required this.action, required this.detail, required this.createdAt});
  final int? id; final String actor; final String action; final String detail; final DateTime createdAt;
}

import 'package:app_bachhoa/models/activity_log.dart';
import 'package:app_bachhoa/models/user_session.dart';
import 'package:app_bachhoa/services/activity_log_repository.dart';
import 'package:app_bachhoa/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';

class AdminActivityLogPage extends StatefulWidget {
  const AdminActivityLogPage({super.key, required this.session, required this.onMenuSelected});
  final UserSession session;
  final ValueChanged<String> onMenuSelected;
  @override
  State<AdminActivityLogPage> createState() => _AdminActivityLogPageState();
}

class _AdminActivityLogPageState extends State<AdminActivityLogPage> {
  final _repo = ActivityLogRepository();
  List<ActivityLog> _logs = [];
  bool _loading = true;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    setState(() => _loading = true);
    final data = await _repo.getRecent();
    if (!mounted) return;
    setState(() { _logs = data; _loading = false; });
  }

  String _date(DateTime d) => '${d.day}/${d.month}/${d.year} ${d.hour}:${d.minute.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      session: widget.session,
      title: 'Nhật ký hoạt động',
      onMenuSelected: widget.onMenuSelected,
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: _logs.isEmpty
                  ? ListView(children: const [SizedBox(height: 220), Center(child: Text('Chưa có nhật ký hoạt động.'))])
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: _logs.length,
                      separatorBuilder: (_, index) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final log = _logs[index];
                        return Card(
                          child: ListTile(
                            leading: const Icon(Icons.history),
                            title: Text(log.action),
                            subtitle: Text('${log.actor} • ${_date(log.createdAt)}\n${log.detail}'),
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}

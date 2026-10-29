import 'package:client/screens/admin/admin_complaints.dart';
import 'package:client/screens/admin/widget/card_box.dart';
import 'package:client/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AdminKpiGrid extends StatelessWidget {
  const AdminKpiGrid({
    super.key,
    required this.totalIssues,
    required this.inProgressCount,
    required this.resolvedCount,
    required this.pendingCount,
    this.onComplaintsUpdated,
  });

  final int totalIssues;
  final int inProgressCount;
  final int resolvedCount;
  final int pendingCount;
  final VoidCallback? onComplaintsUpdated;

  Future<void> _goToComplaints(BuildContext context, String status) async {
    final updated = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => AdminComplaint(initialStatus: status),
      ),
    );
    if (updated == true) onComplaintsUpdated?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: CardBox(
                title: 'Total Issues',
                count: totalIssues,
                icon: Icons.folder_open_outlined,
                subtitle: 'Campus wide',
                accentColor: AppColors.onSurface,
                onTap: () => _goToComplaints(context, 'all'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CardBox(
                title: 'In Progress',
                count: inProgressCount,
                icon: Icons.autorenew,
                subtitle: 'Active resolution',
                accentColor: AppColors.primary,
                isLive: true,
                onTap: () => _goToComplaints(context, 'in progress'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: CardBox(
                title: 'Resolved',
                count: resolvedCount,
                icon: Icons.task_alt,
                subtitle: 'Closed on-time',
                accentColor: AppColors.secondary,
                onTap: () => _goToComplaints(context, 'resolved'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CardBox(
                title: 'Pending',
                count: pendingCount,
                icon: Icons.pending_actions_outlined,
                tag: pendingCount == 0 ? '' : 'requires review',
                subtitle: 'Action needed',
                accentColor: AppColors.tertiary,
                onTap: () => _goToComplaints(context, 'pending'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

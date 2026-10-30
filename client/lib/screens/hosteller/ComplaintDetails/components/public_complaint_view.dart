import 'package:client/screens/hosteller/ComplaintDetails/components/activity_timeline_card.dart';
import 'package:client/screens/hosteller/ComplaintDetails/components/admin_control_hub.dart';
import 'package:client/screens/hosteller/ComplaintDetails/components/evidence_viewer.dart';
import 'package:client/screens/hosteller/ComplaintDetails/components/reporter_profile_card.dart';
import 'package:client/screens/hosteller/ComplaintDetails/components/voting_widget.dart';
import 'package:client/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class PublicComplaintView extends StatelessWidget {
  const PublicComplaintView({
    super.key,
    required this.complaint,
    required this.user,
    required this.isUpvoted,
    required this.isDownvoted,
    required this.upvoteCount,
    required this.downvoteCount,
    required this.isVotingLoading,
    required this.remarksController,
    required this.onUpVote,
    required this.onDownVote,
    required this.onStatusChanged,
    required this.onPostRemark,
  });

  final Map<String, dynamic> complaint;
  final Map<String, dynamic>? user;
  final bool isUpvoted;
  final bool isDownvoted;
  final int upvoteCount;
  final int downvoteCount;
  final bool isVotingLoading;
  final TextEditingController remarksController;
  final ValueChanged<String> onStatusChanged;
  final VoidCallback onPostRemark;
  final VoidCallback onUpVote;
  final VoidCallback onDownVote;

  String _formatTicketId(String rawId) {
    if (rawId.length >= 6) {
      return '#CMP-${rawId.substring(rawId.length - 6).toUpperCase()}';
    }
    return '#CMP-$rawId';
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase().trim()) {
      case 'resolved':
        return AppColors.secondary;
      case 'in progress':
      case 'in-progress':
        return AppColors.primary;
      case 'pending':
      default:
        return AppColors.tertiary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final creator = complaint['createdBy'] as Map<String, dynamic>?;
    final reporterName = creator?['name']?.toString() ?? 'Student';
    final hostelBlock = creator?['hostelBlock']?.toString() ?? 'B';
    final roomNumber = complaint['roomNo']?.toString() ?? creator?['roomNumber']?.toString() ?? creator?['roomNo']?.toString() ?? '';
    final rollNo = creator?['rollNo']?.toString() ?? creator?['rollNumber']?.toString() ?? 'CS-2022';
    final status = complaint['status']?.toString().toLowerCase().trim() ?? 'pending';
    final statusColor = _getStatusColor(status);
    final priority = complaint['priority']?.toString() ?? 'high';
    final rawId = complaint['_id']?.toString() ?? '000000';
    final ticketId = _formatTicketId(rawId);
    final images = (complaint['images'] as List?) ?? [];
    final adminRemarks = complaint['adminRemarks']?.toString();
    final isAdmin = user?['role'] == 'admin';

    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 40),
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Metadata & Status Quick Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(9999),
                    ),
                    child: Text(
                      ticketId,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Status badge (Interactive if Admin)
                  if (isAdmin)
                    PopupMenuButton<String>(
                      onSelected: onStatusChanged,
                      color: AppColors.surfaceContainerHigh,
                      itemBuilder: (context) => const [
                        PopupMenuItem(value: 'pending', child: Text('Pending')),
                        PopupMenuItem(value: 'in progress', child: Text('In Progress')),
                        PopupMenuItem(value: 'resolved', child: Text('Resolved')),
                      ],
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(9999),
                          border: Border.all(color: statusColor.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: statusColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              status.toUpperCase(),
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: statusColor,
                              ),
                            ),
                            const SizedBox(width: 2),
                            Icon(Icons.arrow_drop_down, size: 16, color: statusColor),
                          ],
                        ),
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: statusColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            status.toUpperCase(),
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: statusColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),

              // Action buttons (Share / Copy)
              Row(
                children: [
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.surfaceContainerLow,
                      padding: const EdgeInsets.all(7),
                    ),
                    icon: const Icon(Icons.share_outlined, size: 16, color: AppColors.onSurfaceVariant),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: 'Check hostel grievance $ticketId: ${complaint['title']}'));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: AppColors.surfaceContainerHigh,
                          behavior: SnackBarBehavior.floating,
                          content: Text(
                            'Grievance link copied to clipboard',
                            style: GoogleFonts.plusJakartaSans(color: AppColors.onSurface),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 2. Primary Grievance Header & Description Card
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AppColors.outlineVariant.withValues(alpha: 0.35),
                width: 0.8,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category & Priority
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryContainer.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      child: Text(
                        'Public Grievance',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.secondary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '• Priority ${priority.toUpperCase()}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: AppColors.outline,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Main Title
                Text(
                  complaint['title']?.toString() ?? 'No Title',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 6),

                // Time & Location subtitle
                Row(
                  children: [
                    const Icon(Icons.apartment, size: 14, color: AppColors.tertiary),
                    const SizedBox(width: 4),
                    Text(
                      'Block $hostelBlock${roomNumber.isNotEmpty ? ' • Room $roomNumber' : ''}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Description Text
                Text(
                  complaint['description']?.toString() ?? 'No description provided.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    height: 1.5,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),

                // Attached Evidence Thumbnails
                if (images.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  EvidenceViewer(images: images, isHeroMode: false),
                ],
              ],
            ),
          ),
          const SizedBox(height: 14),

          // 3. Resident Reporter Profile Card
          ReporterProfileCard(
            name: reporterName,
            rollNo: rollNo,
            block: hostelBlock,
            room: roomNumber,
          ),
          const SizedBox(height: 14),

          // 4. Community Endorsement & Voting Widget
          VotingWidget(
            upvotesCount: upvoteCount,
            downvotesCount: downvoteCount,
            isUpvoted: isUpvoted,
            isDownvoted: isDownvoted,
            isLoading: isVotingLoading,
            onUpVote: onUpVote,
            onDownVote: onDownVote,
          ),
          const SizedBox(height: 14),

          // 5. Admin Operational Controls Hub (if admin)
          if (isAdmin) ...[
            AdminControlHub(
              currentStatus: status,
              onStatusChanged: onStatusChanged,
              remarksController: remarksController,
              onPostRemark: onPostRemark,
              existingRemarks: adminRemarks,
            ),
            const SizedBox(height: 14),
          ],

          // 6. Operational Activity Timeline / Audit Trail
          ActivityTimelineCard(
            reporterName: reporterName,
            status: status,
            adminRemarks: adminRemarks,
          ),
        ],
      ),
    );
  }
}


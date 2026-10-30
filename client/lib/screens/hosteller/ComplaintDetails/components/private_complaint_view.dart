import 'package:client/screens/hosteller/ComplaintDetails/components/evidence_viewer.dart';
import 'package:client/screens/hosteller/ComplaintDetails/components/reporter_profile_card.dart';
import 'package:client/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivateComplaintView extends StatelessWidget {
  const PrivateComplaintView({
    super.key,
    required this.complaint,
    required this.user,
    required this.remarksController,
    required this.onStatusChanged,
    required this.onPostRemark,
  });

  final Map<String, dynamic> complaint;
  final Map<String, dynamic>? user;
  final TextEditingController remarksController;
  final ValueChanged<String> onStatusChanged;
  final VoidCallback onPostRemark;

  String _formatTicketId(String rawId) {
    if (rawId.length >= 6) {
      return '#PRV-${rawId.substring(rawId.length - 6).toUpperCase()}';
    }
    return '#PRV-$rawId';
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

  IconData _getCategoryIcon(String? category) {
    final cat = (category ?? '').toLowerCase();
    if (cat.contains('furniture') || cat.contains('carpenter')) return Icons.chair_outlined;
    if (cat.contains('water') || cat.contains('plumb')) return Icons.water_drop_outlined;
    if (cat.contains('elect') || cat.contains('light')) return Icons.flash_on_outlined;
    if (cat.contains('wifi') || cat.contains('internet')) return Icons.wifi_outlined;
    return Icons.domain;
  }

  @override
  Widget build(BuildContext context) {
    final creator = complaint['createdBy'] as Map<String, dynamic>?;
    final reporterName = creator?['name']?.toString() ?? 'Student';
    final hostelBlock = creator?['hostelBlock']?.toString() ?? 'B';
    final roomNumber = complaint['roomNo']?.toString() ?? creator?['roomNumber']?.toString() ?? creator?['roomNo']?.toString() ?? '108';
    final rollNo = creator?['rollNo']?.toString() ?? creator?['rollNumber']?.toString() ?? 'CS-2022-89';
    final status = complaint['status']?.toString().toLowerCase().trim() ?? 'pending';
    final statusColor = _getStatusColor(status);
    final priority = complaint['priority']?.toString() ?? 'high';
    final category = complaint['category']?.toString() ?? 'Furniture & Carpentry';
    final rawId = complaint['_id']?.toString() ?? '000000';
    final ticketId = _formatTicketId(rawId);
    final images = (complaint['images'] as List?) ?? [];
    final adminRemarks = complaint['adminRemarks']?.toString();
    final hasRemarks = adminRemarks != null && adminRemarks.trim().isNotEmpty;
    final isAdmin = user?['role'] == 'admin';

    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 96),
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Ticket Overview Context Card
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
                // Meta row: Ticket ID & Confidentiality Badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          'TICKET ID ',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.8,
                            color: AppColors.outline,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.lock, size: 12, color: AppColors.onSurfaceVariant),
                          const SizedBox(width: 4),
                          Text(
                            'Confidential / Private',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Title & Classification
                Text(
                  complaint['title']?.toString() ?? 'No Title',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(_getCategoryIcon(category), size: 15, color: AppColors.tertiary),
                    const SizedBox(width: 5),
                    Text(
                      category,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text('•', style: TextStyle(color: AppColors.outlineVariant)),
                    const SizedBox(width: 6),
                    Text(
                      'Block $hostelBlock',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Badges Row
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    // Status Badge (Interactive if Admin)
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
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(9999),
                            border: Border.all(color: statusColor.withValues(alpha: 0.3)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                status == 'resolved' ? Icons.check_circle : Icons.circle,
                                size: 13,
                                color: statusColor,
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
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(9999),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              status == 'resolved' ? Icons.check_circle : Icons.circle,
                              size: 13,
                              color: statusColor,
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

                    // Room Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.domain, size: 13, color: AppColors.onSurfaceVariant),
                          const SizedBox(width: 4),
                          Text(
                            'Room $roomNumber',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Priority Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.priority_high, size: 13, color: AppColors.tertiary),
                          const SizedBox(width: 4),
                          Text(
                            '${priority.toUpperCase()} PRIORITY',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Grievance Statement in recessed box
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    complaint['description']?.toString() ?? 'No description provided.',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      height: 1.5,
                      color: AppColors.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // 2. Inspection Evidence Photo (Hero Mode)
          if (images.isNotEmpty) ...[
            EvidenceViewer(
              images: images,
              isHeroMode: true,
              tagLabel: 'Room $roomNumber Evidence',
            ),
            const SizedBox(height: 14),
          ],

          // 3. Reporter Student Profile Card
          ReporterProfileCard(
            name: reporterName,
            rollNo: rollNo,
            block: hostelBlock,
            room: roomNumber,
          ),
          const SizedBox(height: 14),

          // 4. Assigned Facilities Crew & Resolution History Card
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
                Row(
                  children: [
                    const Icon(
                      Icons.engineering_outlined,
                      size: 19,
                      color: AppColors.secondary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Resolution History & Assigned Crew',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurface,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Assigned Crew Info Tile
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerHighest,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.build, size: 18, color: AppColors.primary),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Facilities Staff (${category.split('&').first.trim()})',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.onSurface,
                              ),
                            ),
                            Text(
                              'Hostel Maintenance Wing',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.call, size: 18, color: AppColors.primary),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: AppColors.surfaceContainerHigh,
                              behavior: SnackBarBehavior.floating,
                              content: Text(
                                'Dialing Facilities Maintenance Desk...',
                                style: GoogleFonts.plusJakartaSans(color: AppColors.onSurface),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // 2-Step Timeline
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: statusColor,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: statusColor.withValues(alpha: 0.3),
                              width: 3,
                            ),
                          ),
                        ),
                        Container(
                          width: 1.5,
                          height: 32,
                          color: AppColors.outlineVariant.withValues(alpha: 0.3),
                        ),
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.6),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            status == 'resolved' ? 'Work Verified & Closed' : 'Ticket Under Process',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.onSurface,
                            ),
                          ),
                          Text(
                            hasRemarks ? adminRemarks : 'Maintenance request logged with warden desk.',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Ticket Created',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                          Text(
                            'Logged by $reporterName',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              color: AppColors.outline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // 5. Warden / Admin Remarks Section (if admin and remarks empty, or to edit)
          if (isAdmin)
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: AppColors.outlineVariant.withValues(alpha: 0.35),
                  width: 0.8,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.rate_review_outlined, size: 18, color: AppColors.tertiary),
                      const SizedBox(width: 8),
                      Text(
                        'Warden / Admin Remarks',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.onSurface,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: remarksController,
                    maxLength: 200,
                    maxLines: 3,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      color: AppColors.onSurface,
                    ),
                    decoration: InputDecoration(
                      counterText: '',
                      hintText: 'Add internal maintenance follow-up notes...',
                      hintStyle: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: AppColors.outline,
                      ),
                      fillColor: AppColors.surfaceContainerLowest,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.all(12),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: onPostRemark,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.surfaceContainerHighest,
                        foregroundColor: AppColors.primary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      icon: const Icon(Icons.save_outlined, size: 15),
                      label: Text(
                        'Post Remarks',
                        style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}


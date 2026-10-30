import 'package:client/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ActivityTimelineCard extends StatelessWidget {
  const ActivityTimelineCard({
    super.key,
    required this.reporterName,
    required this.status,
    this.adminRemarks,
    this.createdAtString,
  });

  final String reporterName;
  final String status;
  final String? adminRemarks;
  final String? createdAtString;

  @override
  Widget build(BuildContext context) {
    final hasRemarks = adminRemarks != null && adminRemarks!.trim().isNotEmpty;

    return Container(
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
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.history,
                    size: 19,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Audit Trail & Activity Log',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurface,
                    ),
                  ),
                ],
              ),
              Text(
                'Audit Trail',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: AppColors.outline,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Timeline Items
          Stack(
            children: [
              // Continuous Vertical Line
              Positioned(
                left: 10,
                top: 10,
                bottom: 20,
                child: Container(
                  width: 1.5,
                  color: AppColors.outlineVariant.withValues(alpha: 0.3),
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Step 1: Issue Reported
                  _buildTimelineItem(
                    icon: Icons.edit_note,
                    iconBg: AppColors.primary,
                    iconFg: AppColors.onPrimary,
                    title: 'Issue Reported',
                    time: createdAtString ?? 'Initial Filing',
                    description: 'Logged by $reporterName via Mobile Portal',
                  ),
                  const SizedBox(height: 16),

                  // Step 2: Current Status
                  _buildTimelineItem(
                    icon: status.toLowerCase().contains('resolved')
                        ? Icons.check
                        : Icons.visibility,
                    iconBg: status.toLowerCase().contains('resolved')
                        ? AppColors.secondary
                        : AppColors.surfaceContainerHigh,
                    iconFg: status.toLowerCase().contains('resolved')
                        ? AppColors.onSecondary
                        : AppColors.secondary,
                    title: 'Reviewed by Admin Desk',
                    time: 'Operational Update',
                    description: 'Current status set to: ${status.toUpperCase()}',
                  ),

                  // Step 3: Admin Remarks (if present)
                  if (hasRemarks) ...[
                    const SizedBox(height: 16),
                    _buildTimelineItem(
                      icon: Icons.done_all,
                      iconBg: AppColors.secondaryContainer,
                      iconFg: AppColors.onSecondaryContainer,
                      title: 'Official Admin Response',
                      time: 'Warden Remark',
                      description: adminRemarks!,
                      isHighlighted: true,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem({
    required IconData icon,
    required Color iconBg,
    required Color iconFg,
    required String title,
    required String time,
    required String description,
    bool isHighlighted = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: iconBg,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: iconBg.withValues(alpha: 0.4),
                blurRadius: 6,
              ),
            ],
          ),
          child: Icon(icon, size: 13, color: iconFg),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurface,
                    ),
                  ),
                  Text(
                    time,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppColors.outline,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 3),
              Container(
                padding: isHighlighted
                    ? const EdgeInsets.symmetric(horizontal: 10, vertical: 8)
                    : EdgeInsets.zero,
                decoration: isHighlighted
                    ? BoxDecoration(
                        color: AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.outlineVariant.withValues(alpha: 0.25),
                        ),
                      )
                    : null,
                child: Text(
                  description,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    height: 1.4,
                    color: isHighlighted
                        ? AppColors.onSurface
                        : AppColors.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


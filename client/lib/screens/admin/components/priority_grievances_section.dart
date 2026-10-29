import 'package:client/screens/admin/widget/issue_card.dart';
import 'package:client/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PriorityGrievancesSection extends StatefulWidget {
  const PriorityGrievancesSection({
    super.key,
    required this.complaints,
    required this.onComplaintTap,
  });

  final List<dynamic> complaints;
  final void Function(Map<String, dynamic> complaint) onComplaintTap;

  @override
  State<PriorityGrievancesSection> createState() => _PriorityGrievancesSectionState();
}

class _PriorityGrievancesSectionState extends State<PriorityGrievancesSection> {
  String _activeTab = 'Critical';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Priority Grievances Header Line
        Row(
          children: [
            Text(
              'Priority Grievances',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface,
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 7,
                vertical: 1.5,
              ),
              decoration: BoxDecoration(
                color: AppColors.errorContainer,
                borderRadius: BorderRadius.circular(9999),
              ),
              child: Text(
                '${widget.complaints.length}',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.error,
                ),
              ),
            ),
            const Spacer(),

            // Segmented Tab Filter Pill
            Container(
              padding: const EdgeInsets.all(2.5),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.outlineVariant.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _activeTab = 'Critical';
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _activeTab == 'Critical'
                            ? AppColors.surfaceContainer
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Critical',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: _activeTab == 'Critical'
                              ? AppColors.primary
                              : AppColors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _activeTab = 'Latest';
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _activeTab == 'Latest'
                            ? AppColors.surfaceContainer
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Latest',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: _activeTab == 'Latest'
                              ? AppColors.primary
                              : AppColors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Priority Grievances Feed List
        if (widget.complaints.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              vertical: 24,
              horizontal: 16,
            ),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AppColors.outlineVariant.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.verified_outlined,
                  color: AppColors.secondary,
                  size: 32,
                ),
                const SizedBox(height: 8),
                Text(
                  'No pending priority grievances',
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.onSurface,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'All reported issues are currently addressed',
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          )
        else
          ListView.builder(
            itemBuilder: (context, index) {
              final complaint = widget.complaints[index];
              return IssueCard(
                complaint: complaint is Map<String, dynamic>
                    ? complaint
                    : Map<String, dynamic>.from(complaint as Map),
                onTap: () {
                  widget.onComplaintTap(
                    complaint is Map<String, dynamic>
                        ? complaint
                        : Map<String, dynamic>.from(complaint as Map),
                  );
                },
              );
            },
            itemCount: widget.complaints.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
          ),
      ],
    );
  }
}


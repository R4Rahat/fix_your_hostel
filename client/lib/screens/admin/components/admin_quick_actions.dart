import 'package:client/screens/admin/widget/quick_button.dart';
import 'package:client/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminQuickActions extends StatelessWidget {
  const AdminQuickActions({
    super.key,
    required this.totalComplaints,
    required this.onViewAllComplaints,
    required this.onApproveRequests,
    this.onBroadcastNotice,
  });

  final int totalComplaints;
  final VoidCallback onViewAllComplaints;
  final VoidCallback onApproveRequests;
  final VoidCallback? onBroadcastNotice;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Quick Administrative Actions Header
        Text(
          'Quick Administrative Actions',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: AppColors.onSurface,
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(height: 10),

        // Action 1: View All Complaints
        QuickButton(
          title: 'View All Complaints',
          subtitle: '$totalComplaints active grievances filed',
          badgeText: 'Total $totalComplaints',
          icon: Icons.format_list_bulleted,
          accentColor: AppColors.primary,
          onTap: onViewAllComplaints,
        ),

        // Action 2: Student Approval Requests
        QuickButton(
          title: 'Student Approval Requests',
          subtitle: 'Night-out passes & room change',
          badgeText: 'Pending',
          icon: Icons.how_to_reg,
          accentColor: AppColors.secondary,
          onTap: onApproveRequests,
        ),

        // Action 3: Broadcast Maintenance Notice Button
        // Container(
        //   margin: const EdgeInsets.only(top: 2, bottom: 12),
        //   width: double.infinity,
        //   height: 48,
        //   child: ElevatedButton(
        //     onPressed: onBroadcastNotice ??
        //         () {
        //           ScaffoldMessenger.of(context).showSnackBar(
        //             SnackBar(
        //               backgroundColor: AppColors.surfaceContainerHigh,
        //               behavior: SnackBarBehavior.floating,
        //               shape: RoundedRectangleBorder(
        //                 borderRadius: BorderRadius.circular(10),
        //               ),
        //               content: Row(
        //                 children: [
        //                   const Icon(
        //                     Icons.campaign,
        //                     color: AppColors.primary,
        //                     size: 20,
        //                   ),
        //                   const SizedBox(width: 8),
        //                   Text(
        //                     'Notice console opened for broadcast',
        //                     style: GoogleFonts.plusJakartaSans(
        //                       color: AppColors.onSurface,
        //                       fontSize: 13,
        //                       fontWeight: FontWeight.w600,
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //             ),
        //           );
        //         },
        //     style: ElevatedButton.styleFrom(
        //       backgroundColor: AppColors.primaryAccent,
        //       foregroundColor: Colors.white,
        //       elevation: 2,
        //       shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(12),
        //       ),
        //       padding: const EdgeInsets.symmetric(horizontal: 16),
        //     ),
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         const Icon(
        //           Icons.campaign,
        //           size: 20,
        //           color: Colors.white,
        //         ),
        //         const SizedBox(width: 8),
        //         Text(
        //           'Broadcast Maintenance Notice',
        //           style: GoogleFonts.plusJakartaSans(
        //             fontSize: 14,
        //             fontWeight: FontWeight.w700,
        //             color: Colors.white,
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
      ],
    );
  }
}


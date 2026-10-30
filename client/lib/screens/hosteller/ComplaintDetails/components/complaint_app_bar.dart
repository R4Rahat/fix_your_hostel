import 'package:client/screens/hosteller/ComplaintDetails/delete_dialog.dart';
import 'package:client/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class ComplaintAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ComplaintAppBar({
    super.key,
    required this.ticketId,
    required this.userName,
    required this.canDelete,
    required this.onDelete,
    required this.onBack,
  });

  final String ticketId;
  final String userName;
  final bool canDelete;
  final VoidCallback onDelete;
  final VoidCallback onBack;

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    final avatarLetter = userName.isNotEmpty ? userName[0].toUpperCase() : 'U';

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.95),
        border: Border(
          bottom: BorderSide(
            color: AppColors.outlineVariant.withValues(alpha: 0.3),
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Row(
            children: [
              // Circular Back Button
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onBack,
                  borderRadius: BorderRadius.circular(9999),
                  child: Container(
                    width: 38,
                    height: 38,
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.arrow_back,
                      size: 22,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Title
              Expanded(
                child: Text(
                  'Ticket Details',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                    letterSpacing: -0.3,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // Overflow Menu
              PopupMenuButton<String>(
                icon: const Icon(
                  Icons.more_vert,
                  color: AppColors.onSurfaceVariant,
                  size: 22,
                ),
                color: AppColors.surfaceContainerHigh,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: AppColors.outlineVariant.withValues(alpha: 0.3),
                    width: 0.5,
                  ),
                ),
                onSelected: (value) async {
                  if (value == 'delete') {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => const DeleteDialog(
                        title: 'Delete Complaint',
                        message: 'Are you sure you want to permanently delete this complaint?',
                      ),
                    );
                    if (confirmed == true) {
                      onDelete();
                    }
                  } else if (value == 'copy_id') {
                    Clipboard.setData(ClipboardData(text: ticketId));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: AppColors.surfaceContainerHigh,
                        behavior: SnackBarBehavior.floating,
                        content: Text(
                          'Ticket ID copied to clipboard',
                          style: GoogleFonts.plusJakartaSans(color: AppColors.onSurface),
                        ),
                      ),
                    );
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'copy_id',
                    child: Row(
                      children: [
                        const Icon(Icons.copy, size: 18, color: AppColors.onSurfaceVariant),
                        const SizedBox(width: 10),
                        Text(
                          'Copy Ticket ID',
                          style: GoogleFonts.plusJakartaSans(
                            color: AppColors.onSurface,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (canDelete)
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          const Icon(Icons.delete_outline, size: 18, color: AppColors.error),
                          const SizedBox(width: 10),
                          Text(
                            'Delete Complaint',
                            style: GoogleFonts.plusJakartaSans(
                              color: AppColors.error,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 6),

              // Profile Avatar
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    avatarLetter,
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.onPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


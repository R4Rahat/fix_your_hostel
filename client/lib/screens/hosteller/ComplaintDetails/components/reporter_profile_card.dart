import 'package:client/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReporterProfileCard extends StatelessWidget {
  const ReporterProfileCard({
    super.key,
    required this.name,
    this.rollNo,
    this.block,
    this.room,
    this.onChatTap,
    this.onCallTap,
  });

  final String name;
  final String? rollNo;
  final String? block;
  final String? room;
  final VoidCallback? onChatTap;
  final VoidCallback? onCallTap;

  @override
  Widget build(BuildContext context) {
    final avatarInitial = name.isNotEmpty ? name[0].toUpperCase() : 'S';

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
      child: Row(
        children: [
          // Avatar
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primaryContainer,
                  AppColors.secondary,
                ],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Center(
              child: Text(
                avatarInitial,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Name and Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        name,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.onSurface,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.verified,
                      size: 15,
                      color: AppColors.secondary,
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  [
                    if (rollNo != null && rollNo!.isNotEmpty) rollNo!,
                    if (block != null && block!.isNotEmpty) 'Block $block',
                    if (room != null && room!.isNotEmpty) 'Room $room',
                  ].join(' • '),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.onSurfaceVariant,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Action shortcuts (Chat / Call)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                visualDensity: VisualDensity.compact,
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.surfaceContainerHigh,
                  padding: const EdgeInsets.all(8),
                ),
                icon: const Icon(
                  Icons.chat_bubble_outline,
                  size: 17,
                  color: AppColors.primary,
                ),
                onPressed: onChatTap ??
                    () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: AppColors.surfaceContainerHigh,
                          behavior: SnackBarBehavior.floating,
                          content: Text(
                            'Chat initiated with $name',
                            style: GoogleFonts.plusJakartaSans(color: AppColors.onSurface),
                          ),
                        ),
                      );
                    },
              ),
              const SizedBox(width: 6),
              IconButton(
                visualDensity: VisualDensity.compact,
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.surfaceContainerHigh,
                  padding: const EdgeInsets.all(8),
                ),
                icon: const Icon(
                  Icons.call_outlined,
                  size: 17,
                  color: AppColors.primary,
                ),
                onPressed: onCallTap ??
                    () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: AppColors.surfaceContainerHigh,
                          behavior: SnackBarBehavior.floating,
                          content: Text(
                            'Dialing resident $name',
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
    );
  }
}


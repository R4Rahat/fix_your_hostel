import 'package:client/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CardBox extends StatelessWidget {
  const CardBox({
    super.key,
    required this.title,
    required this.count,
    this.icon,
    this.subtitle,
    this.accentColor,
    this.isLive = false,
    this.tag = '',
    this.onTap,
  });

  final String title;
  final int count;
  final IconData? icon;
  final String? subtitle;
  final Color? accentColor;
  final bool isLive;
  final String? tag;
  final VoidCallback? onTap;

  Color _resolveAccentColor() {
    if (accentColor != null) return accentColor!;
    final lower = title.toLowerCase();
    if (lower.contains('pending')) {
      return AppColors.tertiary; // #FFB95F
    } else if (lower.contains('progress')) {
      return AppColors.primary; // #C0C1FF
    } else if (lower.contains('resolved')) {
      return AppColors.secondary; // #4EDEA3
    } else {
      return AppColors.primary; // #C0C1FF
    }
  }

  IconData _resolveIcon() {
    if (icon != null) return icon!;
    final lower = title.toLowerCase();
    if (lower.contains('pending')) {
      return Icons.pending_actions_outlined;
    } else if (lower.contains('progress')) {
      return Icons.autorenew;
    } else if (lower.contains('resolved')) {
      return Icons.task_alt;
    } else {
      return Icons.folder_open_outlined;
    }
  }

  String _resolveSubtitle() {
    if (subtitle != null) return subtitle!;
    final lower = title.toLowerCase();
    if (lower.contains('pending')) {
      return 'Action needed';
    } else if (lower.contains('progress')) {
      return 'Active resolution';
    } else if (lower.contains('resolved')) {
      return 'Closed on-time';
    } else {
      return 'Campus wide';
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _resolveAccentColor();
    final cardIcon = _resolveIcon();
    final cardSubtitle = _resolveSubtitle();
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          // Card body
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
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Title
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurfaceVariant,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),

                // Metric + Tag / Pulse line
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      count.toString(),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: color,
                        letterSpacing: -0.5,
                      ),
                    ),

                    if (tag != '')
                      Row(
                        children: [
                          const SizedBox(width: 5),
                          Text(
                            tag!,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                              color: color,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(width: 6),
                    if (isLive || title.toLowerCase().contains('progress'))
                      Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.6),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                      )
                    else
                      const SizedBox.shrink(),
                  ],
                ),
                const SizedBox(height: 4),

                // Subtitle context
                Text(
                  cardSubtitle,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: AppColors.onSurfaceVariant.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),

          // Icon badge flush to top-right corner of the card
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.18),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(14),
                  bottomLeft: Radius.circular(12),
                ),
              ),
              child: Icon(cardIcon, size: 18, color: color),
            ),
          ),
        ],
      ),
    );
  }
}

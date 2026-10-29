import 'package:client/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IssueCard extends StatelessWidget {
  const IssueCard({super.key, required this.complaint, required this.onTap});

  final Map<String, dynamic>? complaint;
  final VoidCallback onTap;

  String toUpperCamelCase(String text) {
    return text
        .split(' ')
        .map(
          (word) => word.isNotEmpty
              ? word[0].toUpperCase() + word.substring(1).toLowerCase()
              : '',
        )
        .join(' ');
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'resolved':
        return AppColors.secondary;
      case 'in progress':
      case 'under review':
        return AppColors.primary;
      case 'pending':
      default:
        return AppColors.tertiary;
    }
  }

  String _formatStatusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pending';
      case 'in progress':
        return 'In Progress';
      case 'resolved':
        return 'Resolved';
      default:
        return toUpperCamelCase(status);
    }
  }

  // Category emoji prefix
  String _categoryLabel(String? category) {
    if (category == null || category.isEmpty) return '';
    final lower = category.toLowerCase();
    if (lower.contains('electric') || lower.contains('power')) {
      return '⚡ $category';
    } else if (lower.contains('food') || lower.contains('mess')) {
      return '🍲 $category';
    } else if (lower.contains('furniture') || lower.contains('carpentry')) {
      return '🔨 $category';
    } else if (lower.contains('water') || lower.contains('plumb')) {
      return '🚿 $category';
    } else if (lower.contains('clean') || lower.contains('hygiene')) {
      return '🧹 $category';
    } else if (lower.contains('wifi') || lower.contains('internet')) {
      return '📡 $category';
    }
    return '📋 $category';
  }

  // Relative timestamp
  String _timeAgo(dynamic createdAt) {
    if (createdAt == null) return '';
    try {
      final dt = DateTime.parse(createdAt.toString()).toLocal();
      final diff = DateTime.now().difference(dt);
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      if (diff.inDays == 1) return 'Yesterday';
      if (diff.inDays < 7) return '${diff.inDays}d ago';
      return '${dt.day}/${dt.month}';
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final status =
        (complaint?['status'] as String?)?.toLowerCase() ?? 'pending';
    final statusColor = _getStatusColor(status);
    final statusLabel = _formatStatusLabel(status);

    final title = complaint?['title'] ?? 'No Title';
    final description = complaint?['description'] ?? 'No Description';
    final creator = complaint?['createdBy'] as Map<String, dynamic>?;
    final reporterName = creator?['name'] ?? 'Unknown Student';
    final blockName = creator?['hostelBlock'] ?? 'B';
    final roomNo = complaint?['roomNo'] ?? creator?['roomNo'];
    final rollNo = creator?['rollNo'] ?? creator?['rollNumber'] ?? 'Hosteller';
    final upvotesList = complaint?['upvotes'] as List?;
    final upvotesCount = upvotesList?.length ?? 0;

    final category = complaint?['category'] as String?;
    final createdAt = complaint?['createdAt'];

    final categoryLabel = _categoryLabel(category);
    final timeAgo = _timeAgo(createdAt);

    // Avatar gradient — cycle through a few indigo/teal combos by first letter
    final avatarColors = [
      [const Color(0xFF6366F1), const Color(0xFF38BDF8)],
      [const Color(0xFF8B5CF6), const Color(0xFF6366F1)],
      [const Color(0xFF10B981), const Color(0xFF6366F1)],
      [const Color(0xFFF59E0B), const Color(0xFFEF4444)],
    ];
    final avatarPair =
        avatarColors[reporterName.isNotEmpty
            ? reporterName.codeUnitAt(0) % avatarColors.length
            : 0];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.35),
          width: 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          splashColor: statusColor.withValues(alpha: 0.08),
          highlightColor: statusColor.withValues(alpha: 0.04),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Row 1: Status badge + Location pill + Priority tag ──
                Row(
                  children: [
                    // Status pill (rounded-full)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: statusColor.withValues(alpha: 0.35),
                          width: 0.8,
                        ),
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
                            statusLabel,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: statusColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 7),

                    // Location pill
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: AppColors.outlineVariant.withValues(
                              alpha: 0.25,
                            ),
                            width: 0.6,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              size: 12,
                              color: AppColors.onSurfaceVariant,
                            ),
                            const SizedBox(width: 3),
                            Flexible(
                              child: Text(
                                roomNo != null
                                    ? 'Block ${toUpperCamelCase(blockName.toString())} • Room $roomNo'
                                    : 'Block ${toUpperCamelCase(blockName.toString())}',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.onSurfaceVariant,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Priority tag (only if present)
                  ],
                ),
                const SizedBox(height: 9),

                // ── Row 2: Urgency dot + Title + Chevron ──
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: statusColor.withValues(alpha: 0.55),
                            blurRadius: 5,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        title,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.onSurface,
                          letterSpacing: -0.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.chevron_right,
                      size: 18,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ],
                ),
                const SizedBox(height: 9),

                // ── Description ──
                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    height: 1.45,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),

                // ── Category + upvotes (public) ──
                if (categoryLabel.isNotEmpty || upvotesCount > 0) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (categoryLabel.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            categoryLabel,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ),
                      if (categoryLabel.isNotEmpty && upvotesCount > 0)
                        const SizedBox(width: 8),
                      if (upvotesCount > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.tertiary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: AppColors.tertiary.withValues(alpha: 0.25),
                              width: 0.6,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('👍', style: TextStyle(fontSize: 11)),
                              const SizedBox(width: 4),
                              Text(
                                '$upvotesCount Upvotes',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.tertiary,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
                const SizedBox(height: 11),

                // ── Divider ──
                Divider(
                  height: 1,
                  thickness: 0.5,
                  color: AppColors.outlineVariant.withValues(alpha: 0.3),
                ),
                const SizedBox(height: 10),

                // ── Footer: Avatar + Reporter + Timestamp ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Reporter slug
                    Expanded(
                      child: Row(
                        children: [
                          // Gradient avatar
                          Container(
                            width: 26,
                            height: 26,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: avatarPair,
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.15),
                                width: 0.8,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                reporterName.isNotEmpty
                                    ? reporterName[0].toUpperCase()
                                    : 'S',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  reporterName,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.onSurface,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  rollNo.toString(),
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.outline,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Timestamp
                    if (timeAgo.isNotEmpty)
                      Text(
                        timeAgo,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: AppColors.outline,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

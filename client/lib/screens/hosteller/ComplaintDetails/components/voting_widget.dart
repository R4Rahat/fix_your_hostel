import 'package:client/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VotingWidget extends StatelessWidget {
  const VotingWidget({
    super.key,
    required this.upvotesCount,
    required this.downvotesCount,
    required this.isUpvoted,
    required this.isDownvoted,
    required this.onUpVote,
    required this.onDownVote,
    this.isLoading = false,
  });

  final int upvotesCount;
  final int downvotesCount;
  final bool isUpvoted;
  final bool isDownvoted;
  final VoidCallback onUpVote;
  final VoidCallback onDownVote;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
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
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.groups_outlined,
                    size: 19,
                    color: AppColors.secondary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Community Endorsement',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurface,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.secondaryContainer.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: Text(
                  upvotesCount >= 5 ? 'High Impact' : 'Peer Backed',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.secondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Impact Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  size: 16,
                  color: AppColors.tertiary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: AppColors.onSurfaceVariant,
                      ),
                      children: [
                        TextSpan(
                          text: '$upvotesCount students ',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColors.onSurface,
                          ),
                        ),
                        const TextSpan(
                          text: 'endorsed this grievance for fast resolution.',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Voting Buttons
          Row(
            children: [
              // Upvote Button
              Expanded(
                child: ElevatedButton.styleFrom(
                  backgroundColor: isUpvoted
                      ? AppColors.primary.withValues(alpha: 0.18)
                      : AppColors.surfaceContainerLow,
                  foregroundColor: isUpvoted
                      ? AppColors.primary
                      : AppColors.onSurfaceVariant,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                      color: isUpvoted
                          ? AppColors.primary.withValues(alpha: 0.5)
                          : AppColors.outlineVariant.withValues(alpha: 0.2),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 11),
                ).build(
                  context,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.arrow_upward,
                        size: 17,
                        color: isUpvoted
                            ? AppColors.primary
                            : AppColors.onSurfaceVariant,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        isUpvoted ? 'Upvoted ($upvotesCount)' : 'Upvote ($upvotesCount)',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isUpvoted
                              ? AppColors.primary
                              : AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  onPressed: isLoading ? null : onUpVote,
                ),
              ),
              const SizedBox(width: 10),

              // Downvote Button
              Expanded(
                child: ElevatedButton.styleFrom(
                  backgroundColor: isDownvoted
                      ? AppColors.error.withValues(alpha: 0.18)
                      : AppColors.surfaceContainerLow,
                  foregroundColor: isDownvoted
                      ? AppColors.error
                      : AppColors.onSurfaceVariant,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                      color: isDownvoted
                          ? AppColors.error.withValues(alpha: 0.5)
                          : AppColors.outlineVariant.withValues(alpha: 0.2),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 11),
                ).build(
                  context,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.arrow_downward,
                        size: 17,
                        color: isDownvoted
                            ? AppColors.error
                            : AppColors.onSurfaceVariant,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        isDownvoted ? 'Downvoted ($downvotesCount)' : 'Downvote ($downvotesCount)',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isDownvoted
                              ? AppColors.error
                              : AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  onPressed: isLoading ? null : onDownVote,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

extension on ButtonStyle {
  Widget build(BuildContext context, {required Widget child, required VoidCallback? onPressed}) {
    return ElevatedButton(
      style: this,
      onPressed: onPressed,
      child: child,
    );
  }
}


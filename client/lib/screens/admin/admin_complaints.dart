import 'package:client/screens/admin/widget/issue_card.dart';
import 'package:client/screens/hosteller/ComplaintDetails/complaint_details.dart';

import 'package:client/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:client/services/api.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminComplaint extends StatefulWidget {
  const AdminComplaint({super.key, this.initialStatus = 'all'});

  /// Pre-selects a status chip when the page opens.
  /// Accepts: 'all' | 'pending' | 'in progress' | 'resolved'
  final String initialStatus;

  @override
  State<AdminComplaint> createState() => _AdminComplaintState();
}

class _AdminComplaintState extends State<AdminComplaint> {
  bool isComplaintsLoading = true;
  bool hasUpdated = false;
  List<dynamic> _complaints = [];

  List<String> selectedBlocks = [];
  String selectedVisibility = 'all';
  String selectedSort = 'recent';
  late String selectedStatus;

  final List<String> blocks = ['Block A', 'Block B', 'Block C', 'Block D'];

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.initialStatus;
    fetchComplaints();
  }

  void fetchComplaints() async {
    setState(() => isComplaintsLoading = true);
    Api api = Api();
    var data = await api.getComplaints(
      type: selectedVisibility == 'all' ? null : selectedVisibility,
      status: selectedStatus == 'all' ? null : selectedStatus,
    );
    setState(() {
      _complaints = data;
      isComplaintsLoading = false;
    });
  }

  void toComplaintDetails(Map<String, dynamic> complaint) async {
    final response = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => ComplaintDetails(complaint: complaint),
      ),
    );
    if (response == true) {
      setState(() => hasUpdated = true);
      fetchComplaints();
    }
  }

  // ── Quick filter chip tapped ──
  void _onChipStatusTap(String status) {
    setState(() => selectedStatus = status);
    fetchComplaints();
  }

  // ── Counts for chips ──
  int _countByStatus(String status) => status == 'all'
      ? _complaints.length
      : _complaints
            .where((c) => (c['status'] as String?)?.toLowerCase() == status)
            .length;

  int get _activeCount => _complaints.where((c) {
    final s = (c['status'] as String?)?.toLowerCase() ?? '';
    return s == 'pending' || s == 'in progress';
  }).length;

  // ── Filter bottom sheet ──
  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceContainerLow,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            Widget _sectionLabel(String label) => Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                letterSpacing: 0.4,
                color: AppColors.onSurfaceVariant,
              ),
            );

            Widget _chipRow<T>(
              List<T> items,
              T selected,
              String Function(T) label,
              void Function(T) onSelect,
            ) {
              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: items.map((item) {
                  final isSelected = item == selected;
                  return GestureDetector(
                    onTap: () => setModalState(() => onSelect(item)),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primaryAccent.withValues(alpha: 0.18)
                            : AppColors.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primaryAccent.withValues(alpha: 0.5)
                              : AppColors.outlineVariant.withValues(alpha: 0.3),
                          width: 0.9,
                        ),
                      ),
                      child: Text(
                        label(item),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            }

            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.75,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Handle + title
                    Center(
                      child: Container(
                        width: 36,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.outlineVariant,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Filter & Sort',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 20),

                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ── Hostel Block ──
                            _sectionLabel('HOSTEL BLOCK'),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: blocks.map((block) {
                                final isSelected = selectedBlocks.contains(
                                  block,
                                );
                                return GestureDetector(
                                  onTap: () => setModalState(() {
                                    if (isSelected) {
                                      selectedBlocks.remove(block);
                                    } else {
                                      selectedBlocks.add(block);
                                    }
                                  }),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 150),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 7,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppColors.primaryAccent.withValues(
                                              alpha: 0.18,
                                            )
                                          : AppColors.surfaceContainerHigh,
                                      borderRadius: BorderRadius.circular(999),
                                      border: Border.all(
                                        color: isSelected
                                            ? AppColors.primaryAccent
                                                  .withValues(alpha: 0.5)
                                            : AppColors.outlineVariant
                                                  .withValues(alpha: 0.3),
                                        width: 0.9,
                                      ),
                                    ),
                                    child: Text(
                                      block,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: isSelected
                                            ? AppColors.primary
                                            : AppColors.onSurfaceVariant,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 22),

                            // ── Visibility ──
                            _sectionLabel('VISIBILITY'),
                            const SizedBox(height: 10),
                            _chipRow(
                              ['all', 'public', 'private'],
                              selectedVisibility,
                              (v) => v == 'all'
                                  ? 'All'
                                  : v == 'public'
                                  ? 'Public'
                                  : 'Private',
                              (v) => selectedVisibility = v,
                            ),
                            const SizedBox(height: 22),

                            // ── Status ──
                            _sectionLabel('STATUS'),
                            const SizedBox(height: 10),
                            _chipRow(
                              ['all', 'pending', 'in progress', 'resolved'],
                              selectedStatus,
                              (v) => v == 'all'
                                  ? 'All'
                                  : v == 'in progress'
                                  ? 'In Progress'
                                  : v[0].toUpperCase() + v.substring(1),
                              (v) => selectedStatus = v,
                            ),
                            const SizedBox(height: 22),

                            // ── Sort ──
                            _sectionLabel('SORT BY'),
                            const SizedBox(height: 10),
                            _chipRow(
                              ['recent', 'priority', 'votes', 'oldest'],
                              selectedSort,
                              (v) => {
                                'recent': 'Most Recent',
                                'priority': 'Priority',
                                'votes': 'Highest Votes',
                                'oldest': 'Oldest First',
                              }[v]!,
                              (v) => selectedSort = v,
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryAccent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          fetchComplaints();
                        },
                        child: Text(
                          'Apply Filters',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Status chip definitions
    final chips = [
      ('all', 'All'),
      ('pending', 'Pending'),
      ('in progress', 'In Progress'),
      ('resolved', 'Resolved'),
    ];

    Color _chipColor(String status) {
      switch (status) {
        case 'pending':
          return AppColors.tertiary;
        case 'in progress':
          return AppColors.primary;
        case 'resolved':
          return AppColors.secondary;
        default:
          return AppColors.primaryAccent;
      }
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) Navigator.pop(context, hasUpdated);
      },
      child: Scaffold(
        backgroundColor: AppColors.surfaceContainerLowest,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 8, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Complaints',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: AppColors.onSurface,
                            letterSpacing: -0.4,
                          ),
                        ),
                        const SizedBox(width: 10),
                        if (!isComplaintsLoading && _activeCount > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 9,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryAccent.withValues(
                                alpha: 0.18,
                              ),
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(
                                color: AppColors.primaryAccent.withValues(
                                  alpha: 0.4,
                                ),
                                width: 0.8,
                              ),
                            ),
                            child: Text(
                              '$_activeCount Active',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                      ],
                    ),
                    Row(
                      children: [
                        // Filter button
                        _HeaderIconBtn(
                          icon: Icons.filter_list_rounded,
                          onTap: _openFilterSheet,
                        ),
                        const SizedBox(width: 6),
                        // More options button
                        _HeaderIconBtn(icon: Icons.more_vert, onTap: () {}),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // ── Quick-filter chips (horizontal scroll) ──
              SizedBox(
                height: 36,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: chips.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (_, i) {
                    final (status, label) = chips[i];
                    final isActive = selectedStatus == status;
                    final chipColor = _chipColor(status);
                    final count = _countByStatus(status);

                    return GestureDetector(
                      onTap: () => _onChipStatusTap(status),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 13,
                          vertical: 0,
                        ),
                        decoration: BoxDecoration(
                          color: isActive
                              ? (status == 'all'
                                    ? AppColors.primaryAccent
                                    : chipColor.withValues(alpha: 0.18))
                              : AppColors.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: isActive
                                ? (status == 'all'
                                      ? AppColors.primaryAccent
                                      : chipColor.withValues(alpha: 0.45))
                                : AppColors.outlineVariant.withValues(
                                    alpha: 0.3,
                                  ),
                            width: 0.9,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (status != 'all') ...[
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: isActive
                                      ? chipColor
                                      : chipColor.withValues(alpha: 0.5),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 5),
                            ],
                            Text(
                              isComplaintsLoading ? label : '$label ($count)',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isActive
                                    ? (status == 'all'
                                          ? Colors.white
                                          : chipColor)
                                    : AppColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),

              // ── List ──
              Expanded(
                child: isComplaintsLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      )
                    : _complaints.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.inbox_outlined,
                              size: 48,
                              color: AppColors.outline.withValues(alpha: 0.5),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'No Complaints Found',
                              style: GoogleFonts.plusJakartaSans(
                                color: AppColors.onSurfaceVariant,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 4,
                        ),
                        itemCount: _complaints.length,
                        itemBuilder: (_, i) => IssueCard(
                          complaint: _complaints[i],
                          onTap: () => toComplaintDetails(_complaints[i]),
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

/// Small icon button for the header
class _HeaderIconBtn extends StatelessWidget {
  const _HeaderIconBtn({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColors.outlineVariant.withValues(alpha: 0.3),
            width: 0.8,
          ),
        ),
        child: Icon(icon, size: 18, color: AppColors.onSurfaceVariant),
      ),
    );
  }
}

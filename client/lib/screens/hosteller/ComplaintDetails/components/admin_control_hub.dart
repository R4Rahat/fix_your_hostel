import 'package:client/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminControlHub extends StatefulWidget {
  const AdminControlHub({
    super.key,
    required this.currentStatus,
    required this.onStatusChanged,
    required this.remarksController,
    required this.onPostRemark,
    this.existingRemarks,
  });

  final String currentStatus;
  final ValueChanged<String> onStatusChanged;
  final TextEditingController remarksController;
  final VoidCallback onPostRemark;
  final String? existingRemarks;

  @override
  State<AdminControlHub> createState() => _AdminControlHubState();
}

class _AdminControlHubState extends State<AdminControlHub> {
  int _charCount = 0;

  @override
  void initState() {
    super.initState();
    _charCount = widget.remarksController.text.length;
    widget.remarksController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.remarksController.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    if (mounted) {
      setState(() {
        _charCount = widget.remarksController.text.length;
      });
    }
  }

  void _insertQuickTag(String text) {
    final current = widget.remarksController.text.trim();
    if (current.isEmpty) {
      widget.remarksController.text = text;
    } else {
      widget.remarksController.text = '$current. $text';
    }
    widget.remarksController.selection = TextSelection.fromPosition(
      TextPosition(offset: widget.remarksController.text.length),
    );
  }

  String _formatStatusLabel(String raw) {
    switch (raw.toLowerCase().trim()) {
      case 'in progress':
      case 'in-progress':
        return 'In Progress (Crew Dispatched)';
      case 'resolved':
        return 'Fully Resolved';
      case 'pending':
      default:
        return 'Pending Resolution';
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = widget.currentStatus.toLowerCase().trim();

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
                    Icons.admin_panel_settings_outlined,
                    size: 19,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Admin Operational Controls',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurface,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Warden Desk',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppColors.outline,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Status Transition Dropdown Container
          Text(
            'Update Status State',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColors.outlineVariant.withValues(alpha: 0.25),
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: status == 'resolved'
                    ? 'resolved'
                    : (status == 'in progress' || status == 'in-progress')
                        ? 'in progress'
                        : 'pending',
                dropdownColor: AppColors.surfaceContainerHigh,
                icon: const Icon(
                  Icons.expand_more,
                  color: AppColors.onSurfaceVariant,
                  size: 20,
                ),
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.onSurface,
                ),
                onChanged: (val) {
                  if (val != null) {
                    widget.onStatusChanged(val);
                  }
                },
                items: [
                  DropdownMenuItem(
                    value: 'pending',
                    child: Row(
                      children: [
                        const Icon(Icons.circle, size: 9, color: AppColors.tertiary),
                        const SizedBox(width: 8),
                        Text(_formatStatusLabel('pending')),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'in progress',
                    child: Row(
                      children: [
                        const Icon(Icons.autorenew, size: 14, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Text(_formatStatusLabel('in progress')),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'resolved',
                    child: Row(
                      children: [
                        const Icon(Icons.task_alt, size: 14, color: AppColors.secondary),
                        const SizedBox(width: 8),
                        Text(_formatStatusLabel('resolved')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Quick fill template tags
          Text(
            'Quick Fill Template',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _buildTag('+ Staff assigned', 'Facilities crew assigned and dispatched'),
              _buildTag('+ Parts ordered', 'Replacement parts ordered; work pending delivery'),
              _buildTag('+ Inspected', 'Hostel supervisor inspected site'),
              _buildTag('+ Fixed & tested', 'Maintenance completed and tested on site'),
            ],
          ),
          const SizedBox(height: 14),

          // Official Warden Remarks Input
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Official Warden Remarks',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              Text(
                '$_charCount/200',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: _charCount > 180 ? AppColors.error : AppColors.outline,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          TextField(
            controller: widget.remarksController,
            maxLength: 200,
            maxLines: 3,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: AppColors.onSurface,
            ),
            decoration: InputDecoration(
              counterText: '',
              hintText: 'State operational action taken or instructions for residents...',
              hintStyle: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: AppColors.outline,
              ),
              fillColor: AppColors.surfaceContainerLow,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: AppColors.outlineVariant.withValues(alpha: 0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: AppColors.primaryAccent,
                  width: 1.2,
                ),
              ),
              contentPadding: const EdgeInsets.all(12),
            ),
          ),
          const SizedBox(height: 10),

          // Post Official Remark Button
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              onPressed: widget.onPostRemark,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryAccent,
                foregroundColor: Colors.white,
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.send, size: 16, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    'Post Official Remark',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String label, String insertText) {
    return InkWell(
      onTap: () => _insertQuickTag(insertText),
      borderRadius: BorderRadius.circular(9999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(9999),
          border: Border.all(
            color: AppColors.outlineVariant.withValues(alpha: 0.25),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}


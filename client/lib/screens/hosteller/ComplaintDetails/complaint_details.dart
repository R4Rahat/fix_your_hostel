import 'dart:async';
import 'package:client/screens/hosteller/ComplaintDetails/components/complaint_app_bar.dart';
import 'package:client/screens/hosteller/ComplaintDetails/components/private_complaint_view.dart';
import 'package:client/screens/hosteller/ComplaintDetails/components/public_complaint_view.dart';
import 'package:client/services/api.dart';
import 'package:client/services/votes.dart';
import 'package:client/theme/app_colors.dart';
import 'package:client/util/user_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ComplaintDetails extends StatefulWidget {
  const ComplaintDetails({super.key, required this.complaint});
  final Map<String, dynamic> complaint;

  @override
  State<ComplaintDetails> createState() => _ComplaintDetailsState();
}

class _ComplaintDetailsState extends State<ComplaintDetails> {
  Map<String, dynamic>? user;
  bool isLoading = false;
  bool isAdminLoading = true;
  bool isCheckVotesLoading = true;

  bool isUpvoted = false;
  bool isDownvoted = false;

  bool hasUpdated = false;
  int upvoteCount = 0;
  int downvoteCount = 0;
  Map<String, dynamic>? votes;
  late TextEditingController _remarksController;

  @override
  void initState() {
    super.initState();
    _remarksController = TextEditingController();
    fetchUser();
  }

  @override
  void dispose() {
    _remarksController.dispose();
    super.dispose();
  }

  void fetchUser() async {
    final userData = await UserStorage.getUser();
    setState(() {
      user = userData;
      isAdminLoading = false;
    });
    checkVoteStatus();
  }

  void _deleteComplaint() async {
    Api api = Api();
    final response = await api.deleteComplaint(widget.complaint['_id']);
    if (!mounted) return;
    debugPrint(response.toString());
    if (response['success'] == "true" || response['success'] == true) {
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            response["message"] ?? 'Complaint deleted',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 14),
          ),
          backgroundColor: AppColors.surfaceContainerHigh,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            response['message'] ?? "Error occurred",
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 14),
          ),
          backgroundColor: AppColors.surfaceContainerHigh,
        ),
      );
    }
  }

  void _deleteUserComplaint() async {
    Api api = Api();
    final response = await api.deleteUserComplaint(widget.complaint['_id']);
    if (!mounted) return;
    debugPrint(response.toString());
    if (response['success'] == "true" || response['success'] == true) {
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            response["message"] ?? 'Complaint deleted',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 14),
          ),
          backgroundColor: AppColors.surfaceContainerHigh,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            response['message'] ?? "Error occurred",
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 14),
          ),
          backgroundColor: AppColors.surfaceContainerHigh,
        ),
      );
    }
  }

  void patchRemarks(String remarks, String id) async {
    if (remarks.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please enter remarks before submitting',
            style: GoogleFonts.plusJakartaSans(color: Colors.white),
          ),
          backgroundColor: AppColors.surfaceContainerHigh,
        ),
      );
      return;
    }

    Api api = Api();
    final response = await api.editRemarks(remarks, id);
    if (!mounted) return;
    if (response['success'] == true || response['success'] == "true") {
      setState(() {
        widget.complaint['adminRemarks'] = remarks;
        hasUpdated = true;
      });
      _remarksController.clear();
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            response['message'] ?? "Remark added successfully",
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 14),
          ),
          backgroundColor: AppColors.surfaceContainerHigh,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            response['message'] ?? "Error occurred while posting remark",
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 14),
          ),
          backgroundColor: AppColors.surfaceContainerHigh,
        ),
      );
    }
  }

  Future<void> _changeStatus(String status) async {
    Api api = Api();
    final response = await api.editStatus(status, widget.complaint['_id']);
    if (!mounted) return;
    if (response['success'] == "true" || response["success"] == true) {
      setState(() {
        widget.complaint['status'] = status;
        hasUpdated = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Status updated to: ${status.toUpperCase()}',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(color: Colors.white),
          ),
          backgroundColor: AppColors.surfaceContainerHigh,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            response['message'] ?? 'Error occurred updating status',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(color: Colors.white),
          ),
          backgroundColor: AppColors.surfaceContainerHigh,
        ),
      );
    }
    debugPrint(response.toString());
  }

  void checkVoteStatus() {
    final List<dynamic> upVotes = widget.complaint['upvotes'] as List<dynamic>? ?? [];
    final List<dynamic> downVotes = widget.complaint['downvotes'] as List<dynamic>? ?? [];
    final userId = user?['id'] ?? user?['_id'];
    setState(() {
      isUpvoted = upVotes.contains(userId);
      isDownvoted = downVotes.contains(userId);
      upvoteCount = upVotes.length;
      downvoteCount = downVotes.length;
      isCheckVotesLoading = false;
    });
  }

  Future<void> handleUpVote() async {
    Votes vote = Votes(complaintId: widget.complaint['_id']);
    setState(() {
      isLoading = true;
    });
    final response = await vote.upVote();
    setState(() {
      isLoading = false;
    });
    if (!mounted) return;
    if (response['message'] == "Vote updated") {
      setState(() {
        votes = response;
        isUpvoted = !isUpvoted;
        if (isUpvoted) {
          isDownvoted = false;
        }
        if (response['upvotes'] != null) {
          upvoteCount = response['upvotes'] is int
              ? response['upvotes']
              : int.tryParse(response['upvotes'].toString()) ?? upvoteCount;
        }
        if (response['downvotes'] != null) {
          downvoteCount = response['downvotes'] is int
              ? response['downvotes']
              : int.tryParse(response['downvotes'].toString()) ?? downvoteCount;
        }
        hasUpdated = true;
      });
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isUpvoted ? 'Upvote registered' : 'Upvote removed',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(color: Colors.white),
          ),
          backgroundColor: AppColors.surfaceContainerHigh,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            response['message'] ?? 'Error occurred voting',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(color: Colors.white),
          ),
          backgroundColor: AppColors.surfaceContainerHigh,
        ),
      );
    }
  }

  Future<void> handleDownVote() async {
    Votes vote = Votes(complaintId: widget.complaint['_id']);
    setState(() {
      isLoading = true;
    });
    final response = await vote.downVote();
    setState(() {
      isLoading = false;
    });
    if (!mounted) return;
    if (response['message'] == "Vote updated") {
      setState(() {
        votes = response;
        isDownvoted = !isDownvoted;
        if (isDownvoted) {
          isUpvoted = false;
        }
        if (response['upvotes'] != null) {
          upvoteCount = response['upvotes'] is int
              ? response['upvotes']
              : int.tryParse(response['upvotes'].toString()) ?? upvoteCount;
        }
        if (response['downvotes'] != null) {
          downvoteCount = response['downvotes'] is int
              ? response['downvotes']
              : int.tryParse(response['downvotes'].toString()) ?? downvoteCount;
        }
        hasUpdated = true;
      });
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isDownvoted ? 'Downvote registered' : 'Downvote removed',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(color: Colors.white),
          ),
          backgroundColor: AppColors.surfaceContainerHigh,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            response['message'] ?? 'Error occurred voting',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(color: Colors.white),
          ),
          backgroundColor: AppColors.surfaceContainerHigh,
        ),
      );
    }
  }

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

  @override
  Widget build(BuildContext context) {
    final isPrivate = widget.complaint['type']?.toString().toLowerCase() == 'private';
    final isAdmin = user?['role'] == 'admin';
    final isCreator = widget.complaint['createdBy']?['email'] == user?['email'];
    final canDelete = isAdmin || isCreator;
    final rawId = widget.complaint['_id']?.toString() ?? '000000';
    final ticketId = isPrivate
        ? (rawId.length >= 6 ? '#PRV-${rawId.substring(rawId.length - 6).toUpperCase()}' : '#PRV-$rawId')
        : (rawId.length >= 6 ? '#CMP-${rawId.substring(rawId.length - 6).toUpperCase()}' : '#CMP-$rawId');

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Navigator.pop(context, hasUpdated);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.surface,
        appBar: ComplaintAppBar(
          ticketId: ticketId,
          userName: user?['name']?.toString() ?? 'Admin',
          canDelete: canDelete,
          onDelete: () {
            if (isAdmin) {
              _deleteComplaint();
            } else {
              _deleteUserComplaint();
            }
          },
          onBack: () => Navigator.pop(context, hasUpdated),
        ),
        body: Stack(
          children: [
            (isAdminLoading || isCheckVotesLoading)
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  )
                : isPrivate
                    ? PrivateComplaintView(
                        complaint: widget.complaint,
                        user: user,
                        remarksController: _remarksController,
                        onStatusChanged: _changeStatus,
                        onPostRemark: () => patchRemarks(_remarksController.text, widget.complaint['_id']),
                      )
                    : PublicComplaintView(
                        complaint: widget.complaint,
                        user: user,
                        isUpvoted: isUpvoted,
                        isDownvoted: isDownvoted,
                        upvoteCount: upvoteCount,
                        downvoteCount: downvoteCount,
                        isVotingLoading: isLoading,
                        remarksController: _remarksController,
                        onUpVote: handleUpVote,
                        onDownVote: handleDownVote,
                        onStatusChanged: _changeStatus,
                        onPostRemark: () => patchRemarks(_remarksController.text, widget.complaint['_id']),
                      ),

            // In-flight operation loading indicator overlay
            if (isLoading)
              Container(
                color: Colors.black.withValues(alpha: 0.5),
                child: const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              ),
          ],
        ),

        // Sticky Bottom Administrative Dock for Private Tickets
        bottomNavigationBar: (isPrivate && isAdmin)
            ? Container(
                decoration: BoxDecoration(
                  color: AppColors.surface.withValues(alpha: 0.95),
                  border: Border(
                    top: BorderSide(
                      color: AppColors.outlineVariant.withValues(alpha: 0.3),
                      width: 0.5,
                    ),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.4),
                      blurRadius: 20,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: SafeArea(
                  top: false,
                  child: Row(
                    children: [
                      // Reopen Ticket Button
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: ElevatedButton.icon(
                            onPressed: () => _changeStatus('pending'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.surfaceContainerHigh,
                              foregroundColor: AppColors.error,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                  color: AppColors.error.withValues(alpha: 0.3),
                                ),
                              ),
                            ),
                            icon: const Icon(Icons.replay, size: 18, color: AppColors.error),
                            label: Text(
                              'Reopen Ticket',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.error,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Mark Resolved Button
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: ElevatedButton.icon(
                            onPressed: () => _changeStatus('resolved'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryAccent,
                              foregroundColor: Colors.white,
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: const Icon(Icons.task_alt, size: 18, color: Colors.white),
                            label: Text(
                              'Mark Resolved',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : null,
      ),
    );
  }
}

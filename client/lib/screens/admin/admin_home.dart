import 'package:client/screens/admin/admin_complaints.dart';
import 'package:client/screens/admin/approval.dart';
import 'package:client/screens/admin/components/home_components.dart';
import 'package:client/screens/hosteller/ComplaintDetails/complaint_details.dart';
import 'package:client/services/api.dart';
import 'package:client/theme/app_colors.dart';
import 'package:client/util/user_storage.dart';
import 'package:flutter/material.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  Map<String, dynamic>? admin;
  bool isAdminLoading = true;
  bool isComplaintsLoading = true;
  List<dynamic> _complaints = [];
  String _selectedBlock = 'Block B';

  int getCount(String status) {
    int count = 0;
    for (final complaint in _complaints) {
      if (complaint?['status'] == status) {
        count++;
      }
    }
    return count;
  }

  void toComplaintDetails(Map<String, dynamic> complaint) async {
    final response = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => ComplaintDetails(complaint: complaint),
      ),
    );
    if (response == true) {
      fetchComplaints();
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAdmin();
    fetchComplaints();
  }

  Future<void> fetchAdmin() async {
    final adminData = await UserStorage.getUser();
    setState(() {
      admin = adminData;
      isAdminLoading = false;
    });
  }

  void fetchComplaints() async {
    Api api = Api();
    var data = await api.getComplaints();
    setState(() {
      _complaints = data;
      isComplaintsLoading = false;
    });
  }

  void _cycleBlockFilter() {
    final blocks = ['Block B', 'Block A', 'All Blocks'];
    final currentIndex = blocks.indexOf(_selectedBlock);
    setState(() {
      _selectedBlock = blocks[(currentIndex + 1) % blocks.length];
    });
  }

  @override
  Widget build(BuildContext context) {
    final topComplaints =
        _complaints
            .where((c) => c['type'] == "public" && c['status'] == "pending")
            .toList()
          ..sort((a, b) {
            int votesA = (a['upvotes'] as List?)?.length ?? 0;
            int votesB = (b['upvotes'] as List?)?.length ?? 0;
            return votesB.compareTo(votesA);
          });

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AdminHomeAppBar(admin: admin),
      body: SafeArea(
        top: false,
        child: (isAdminLoading || isComplaintsLoading)
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              )
            : SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Operational Status Eyebrow, Welcome Hero & Block Filter
                    AdminHeroHeader(
                      adminName: admin?['name']?.toString() ?? 'Chief Warden',
                      selectedBlock: _selectedBlock,
                      onCycleBlock: _cycleBlockFilter,
                    ),
                    const SizedBox(height: 14),

                    // 2x2 Metric KPI Grid
                    AdminKpiGrid(
                      totalIssues: _complaints.length,
                      inProgressCount: getCount('in progress'),
                      resolvedCount: getCount('resolved'),
                      pendingCount: getCount('pending'),
                      onComplaintsUpdated: fetchComplaints,
                    ),
                    const SizedBox(height: 22),

                    // Priority Grievances Feed Section
                    PriorityGrievancesSection(
                      complaints: topComplaints,
                      onComplaintTap: toComplaintDetails,
                    ),
                    const SizedBox(height: 16),

                    // Quick Administrative Actions & Broadcast Button
                    AdminQuickActions(
                      totalComplaints: _complaints.length,
                      onViewAllComplaints: () async {
                        final response = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => AdminComplaint(),
                          ),
                        );
                        if (response == true) {
                          fetchComplaints();
                        }
                      },
                      onApproveRequests: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (ctx) => Approval()),
                        );
                      },
                    ),

                    // Emergency Duty Notice Card
                    // const EmergencyDutyCard(),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
      ),
    );
  }
}

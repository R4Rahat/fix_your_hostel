import 'package:client/screens/admin/approval_components/approval_components.dart';
import 'package:client/screens/dialog_box.dart';
import 'package:client/screens/hosteller/widgets/progress_indicator.dart';
import 'package:client/services/user.dart';
import 'package:client/theme/app_colors.dart';
import 'package:flutter/material.dart';

class Approval extends StatefulWidget {
  const Approval({super.key});

  @override
  State<Approval> createState() => _ApprovalState();
}

class _ApprovalState extends State<Approval> {
  bool isUserLoading = true;
  List<Map<String, dynamic>> users = [];

  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void fetchUsers() async {
    UserApi api = UserApi();
    final response = await api.getAllUsers();

    if (!mounted) return;

    if (response.isNotEmpty &&
        (response['success'] == true || response['success'] == "true")) {
      setState(() {
        users = List<Map<String, dynamic>>.from(
          response['data'],
        ).where((user) => user['isApproved'] == false).toList();
        isUserLoading = false;
      });
    } else {
      setState(() {
        isUserLoading = false;
      });
    }
  }

  void approveUser(String id) async {
    UserApi api = UserApi();
    final response = await api.approveUser(id);

    if (!mounted) return;

    if (response.isNotEmpty &&
        (response['success'] == true || response['success'] == "true")) {
      showDialog(
        context: context,
        builder: (context) {
          return DialogBox(
            message: "User has been approved successfully!!",
            onTap: () {
              Navigator.pop(context);
              isUserLoading = true;
              fetchUsers();
            },
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error occurred: ${response['message']}')),
      );
    }
  }

  void deleteUser(String id) async {
    UserApi api = UserApi();
    final response = await api.deleteUser(id);
    if (!mounted) return;
    if (response.isNotEmpty &&
        (response['success'] == true || response['success'] == "true")) {
      showDialog(
        context: context,
        builder: (context) {
          return DialogBox(
            message: "User has been deleted successfully!!",
            onTap: () {
              Navigator.pop(context);
              isUserLoading = true;
              fetchUsers();
            },
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error occurred: ${response['message']}')),
      );
    }
  }

  List<String> get _availableFilters {
    final blocks = <String>{};
    for (final u in users) {
      final block = u['hostelBlock']?.toString();
      if (block != null && block.trim().isNotEmpty) {
        blocks.add(block.trim());
      }
    }
    return ['All', ...blocks];
  }

  Map<String, int> get _filterCounts {
    final counts = <String, int>{'All': users.length};
    for (final u in users) {
      final block = u['hostelBlock']?.toString()?.trim();
      if (block != null && block.isNotEmpty) {
        counts[block] = (counts[block] ?? 0) + 1;
      }
    }
    return counts;
  }

  List<Map<String, dynamic>> get _filteredUsers {
    return users.where((student) {
      final query = _searchController.text.trim().toLowerCase();
      final name = student['name']?.toString().toLowerCase() ?? '';
      final email = student['email']?.toString().toLowerCase() ?? '';
      final roll = student['rollno']?.toString().toLowerCase() ?? '';
      final block = student['hostelBlock']?.toString().toLowerCase() ?? '';
      final room = student['roomNumber']?.toString().toLowerCase() ?? '';

      final matchesSearch = query.isEmpty ||
          name.contains(query) ||
          email.contains(query) ||
          roll.contains(query) ||
          block.contains(query) ||
          room.contains(query);

      if (!matchesSearch) return false;

      if (_selectedFilter == 'All') return true;
      final studentBlock = student['hostelBlock']?.toString()?.trim() ?? '';
      return studentBlock == _selectedFilter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: ApprovalAppBar(
        onRefresh: () {
          setState(() {
            isUserLoading = true;
          });
          fetchUsers();
        },
      ),
      body: isUserLoading
          ? const Center(child: ProgressIndicatoring())
          : RefreshIndicator(
              color: AppColors.primary,
              backgroundColor: AppColors.surfaceContainer,
              onRefresh: () async {
                fetchUsers();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Queue Operational Strip
                    ApprovalQueueBanner(
                      pendingCount: users.length,
                      subtitle: 'Hostel Block Intake & Verification',
                    ),
                    const SizedBox(height: 16),

                    // Search & Filter Controls
                    ApprovalSearchAndFilter(
                      searchController: _searchController,
                      onSearchChanged: (val) {
                        setState(() {});
                      },
                      selectedFilter: _selectedFilter,
                      availableFilters: _availableFilters,
                      filterCounts: _filterCounts,
                      onFilterSelected: (filter) {
                        setState(() {
                          _selectedFilter = filter;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // Student Cards Stack or Empty State
                    if (_filteredUsers.isEmpty)
                      ApprovalEmptyState(
                        isFiltered:
                            users.isNotEmpty && _filteredUsers.isEmpty,
                        onRefresh: () {
                          setState(() {
                            isUserLoading = true;
                          });
                          fetchUsers();
                        },
                      )
                    else
                      ListView.builder(
                        itemCount: _filteredUsers.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final student = _filteredUsers[index];
                          return StudentApprovalCard(
                            key: ValueKey(
                              student['_id'] ?? index.toString(),
                            ),
                            student: student,
                            onApprove: () {
                              approveUser(student['_id']);
                            },
                            onReject: () {
                              deleteUser(student['_id']);
                            },
                          );
                        },
                      ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
    );
  }
}

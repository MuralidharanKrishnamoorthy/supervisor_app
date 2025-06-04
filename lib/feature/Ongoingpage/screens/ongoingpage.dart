import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supervisor_app/core/provider/ongoingprovider.dart';
import 'package:supervisor_app/core/service/networkservice.dart';
import 'package:supervisor_app/feature/Ongoingpage/screens/ongoingworkdetail.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Ongoingpage extends StatefulWidget {
  const Ongoingpage({super.key});

  @override
  State<Ongoingpage> createState() => _OngoingpageState();
}

class _OngoingpageState extends State<Ongoingpage>
    with SingleTickerProviderStateMixin {
  bool _cardLoading = false;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {}); // Rebuild to update tab colors
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OngoingProvider()..fetchOngoingProjects(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text(
            "Ongoing Projects",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          elevation: 0,
        ),
        body: Consumer<OngoingProvider>(
          builder: (context, provider, _) {
            return Stack(
              children: [
                Column(
                  children: [
                    // Custom TabBar
                    Container(
                      color: Colors.blue,
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _tabController.animateTo(0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color:
                                      _tabController.index == 0
                                          ? Colors.white
                                          : Colors.blue,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(0),
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  "Processing",
                                  style: TextStyle(
                                    color:
                                        _tabController.index == 0
                                            ? Colors.blue
                                            : Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _tabController.animateTo(1),
                              child: Container(
                                decoration: BoxDecoration(
                                  color:
                                      _tabController.index == 1
                                          ? Colors.white
                                          : Colors.blue,
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(0),
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  "Pending for Approval",
                                  style: TextStyle(
                                    color:
                                        _tabController.index == 1
                                            ? Colors.blue
                                            : Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Search bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        margin: const EdgeInsets.only(top: 16, bottom: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 1.2,
                          ),
                        ),
                        child: TextField(
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Search by postal code / street name',
                            prefixIcon: Icon(Icons.search),
                            contentPadding: EdgeInsets.symmetric(vertical: 16),
                          ),
                          style: const TextStyle(fontSize: 16),
                          onChanged: provider.searchProject,
                        ),
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          // Processing tab
                          _buildProjectList(
                            provider.projects
                                .where(
                                  (p) => p.status.toLowerCase() == 'processing',
                                )
                                .toList(),
                          ),
                          // Pending for Approval tab
                          _buildProjectList(
                            provider.projects
                                .where(
                                  (p) =>
                                      p.status.toLowerCase() ==
                                      'pending for approval',
                                )
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (provider.isLoading || _cardLoading)
                  Container(
                    color: Colors.white.withOpacity(0.7),
                    child: const Center(
                      child: SpinKitWave(color: Colors.blue, size: 40.0),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildProjectList(List projects) {
    // if (projects.isEmpty) {
    //   return const Center(child: Text('No projects found.'));
    // }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: projects.length,
      itemBuilder: (context, index) {
        final project = projects[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GestureDetector(
            onTap: () async {
              if (mounted) {
                setState(() {
                  _cardLoading = true;
                });
              }
              final details = await NetworkService().fetchProjectDetailsBySO(
                docNo: project.id,
                stallNo: project.stallNo,
                usageDate: '',
              );
              if (mounted) {
                setState(() {
                  _cardLoading = false;
                });
              }
              if (details != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => OngoingWorkDetailsPage(details: details),
                  ),
                );
              } else {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Failed to load project details'),
                    ),
                  );
                }
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF6F6F6),
                border: Border.all(color: Colors.blue.shade300, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top row: Project ID and Status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          project.id,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Container(
                        height: 28,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color:
                              project.status.toLowerCase() == "processing"
                                  ? Colors.orange.withOpacity(0.15)
                                  : Colors.blue.withOpacity(0.15),
                          border: Border.all(
                            color:
                                project.status.toLowerCase() == "processing"
                                    ? Colors.orange
                                    : Colors.blue,
                            width: 1.2,
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          project.status,
                          style: TextStyle(
                            color:
                                project.status.toLowerCase() == "processing"
                                    ? Colors.orange
                                    : Colors.blue.shade700,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Priority
                  Text(
                    'Priority: ${project.priority}',
                    style: TextStyle(
                      color: _getPriorityColor(project.priority),
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Schedule Start & End
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Sch Start Date',
                              style: TextStyle(
                                color: Colors.blue.shade700,
                                fontWeight: FontWeight.w600,
                                fontSize: 13.5,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              project.schStart,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Sch End Date',
                              style: TextStyle(
                                color: Colors.blue.shade700,
                                fontWeight: FontWeight.w600,
                                fontSize: 13.5,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              project.schEnd,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Customer Info and Number
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          project.customerInfo,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Colors.black,
                          ),
                          softWrap: true,
                          maxLines: null,
                        ),
                      ),
                      if (project.customerNo.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            project.customerNo,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                              color: Colors.black,
                            ),
                          ),
                        ),
                    ],
                  ),
                  // Address below
                  if (project.address.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0),
                      child: Text(
                        project.address,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black87,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  // Stall No as blue label and value (no pill)
                  if (project.stallNo.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Row(
                        children: [
                          Text(
                            'Stall No: ',
                            style: TextStyle(
                              color: Colors.blue.shade700,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              project.stallNo,
                              style: TextStyle(
                                color: Colors.blue.shade700,
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}

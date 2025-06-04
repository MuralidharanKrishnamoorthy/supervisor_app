import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:supervisor_app/feature/Assign/screens/assignwork.dart';
import 'package:supervisor_app/feature/NewProject/Screens/newproject.dart';
import 'package:supervisor_app/feature/Ongoingpage/screens/ongoingpage.dart';
import 'package:supervisor_app/feature/homepage/screens/projectstatuspage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final userBox = Hive.box('userBox');
  late final String? servicemanname;
  late final String? servicemancode;
  late String supervisorName;
  late String supervisorId;

  // Sample vehicle info and image (replace with API data later)
  final String vehicleInfo = "Vehicle - SG 12 AD 1283";
  final String profileImageUrl =
      ""; // Add a network or asset image path if available

  @override
  void initState() {
    super.initState();
    servicemanname = userBox.get('servicemanName');
    servicemancode = userBox.get('servicemanCode');
    supervisorName = servicemanname ?? " ";
    supervisorId = servicemancode ?? " ";
  }

  int? selectedIndex;

  void _refreshPage() {
    setState(() {});
  }

  void _navigateTo(Widget page, int index) async {
    // Set the card as selected (blue)
    setState(() {
      selectedIndex = index;
    });

    // Wait a bit to show the blue state
    await Future.delayed(const Duration(milliseconds: 150));

    // Navigate to the page
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));

    // Reset the selection when returning from navigation
    setState(() {
      selectedIndex = null;
    });
  }

  void _openDrawer() {
    Scaffold.of(context).openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: Drawer(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero, // Removes top and bottom curves
        ),
        child: Column(
          children: [
            Container(
              color: Colors.blue,
              width: double.infinity,
              padding: const EdgeInsets.only(top: 40, bottom: 16),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.white,
                    backgroundImage:
                        profileImageUrl.isNotEmpty
                            ? NetworkImage(profileImageUrl)
                            : null,
                    child:
                        profileImageUrl.isEmpty
                            ? const Icon(
                              Icons.person,
                              size: 40,
                              color: Colors.blue,
                            )
                            : null,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    supervisorName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    supervisorId,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  Text(
                    vehicleInfo,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            ListTile(
              leading: const Icon(Icons.pending_actions),
              title: const Text(
                "Project Status",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              onTap: () {
                Navigator.pop(context); // close drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Projectstatuspage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Builder(
          builder:
              (context) => Container(
                width: double.infinity,
                color: Colors.blue,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // Drawer menu icon
                        IconButton(
                          icon: const Icon(Icons.menu, color: Colors.white),
                          onPressed: () => Scaffold.of(context).openDrawer(),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  supervisorName,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  supervisorId,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: _refreshPage,
                          icon: const Icon(Icons.refresh, color: Colors.white),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            double aspectRatio;
            if (screenSize.width < 360) {
              aspectRatio = 0.85;
            } else if (constraints.maxWidth > 600) {
              aspectRatio = 1.5;
            } else {
              aspectRatio = 1.0;
            }

            return GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: aspectRatio,
              children: [
                _buildHomeCard(
                  title: "New Projects",
                  icon: Icons.precision_manufacturing_outlined,
                  index: 0,
                  isSelected: selectedIndex == 0,
                  onTap: () => _navigateTo(const Newproject(), 0),
                ),
                _buildHomeCard(
                  title: "Ongoing Projects",
                  icon: Icons.work_outline,
                  index: 1,
                  isSelected: selectedIndex == 1,
                  onTap: () => _navigateTo(const Ongoingpage(), 1),
                ),
                _buildHomeCard(
                  title: "Assign Work Order",
                  icon: Icons.assignment_ind_outlined,
                  index: 2,
                  isSelected: selectedIndex == 2,
                  onTap: () => _navigateTo(const AssignWorkPage(), 2),
                ),
                //! Add worker card is commented out for now.
                // _buildHomeCard(
                //   title: "Add Worker",
                //   icon: Icons.person_add_alt_1_outlined,
                //   index: 3,
                //   isSelected: selectedIndex == 3,
                //   onTap: () => _navigateTo(const Addworker(), 3),
                // ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHomeCard({
    required String title,
    required IconData icon,
    required int index,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.white,
          border: Border.all(color: Colors.blue),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 28,
                color: isSelected ? Colors.white : Colors.blue,
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: isSelected ? Colors.white : Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

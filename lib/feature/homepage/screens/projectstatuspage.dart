import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Projectstatuspage extends StatefulWidget {
  const Projectstatuspage({super.key});

  @override
  State<Projectstatuspage> createState() => _ProjectstatuspageState();
}

class _ProjectstatuspageState extends State<Projectstatuspage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
    return Scaffold(
      backgroundColor: Colors.white, // Scaffold bg white
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Project Status',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      body: Column(
        children: [
          // Custom TabBar
          Container(
            color: Colors.blue,
            child: Row(
              children: [
                _buildTab(0, "Assigned"),
                _buildTab(1, "Approved"),
                _buildTab(2, "Rejected"),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                Center(child: Text('Assigned Projects')),
                Center(child: Text('Approved Projects')),
                Center(child: Text('Rejected Projects')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(int index, String label) {
    final bool selected = _tabController.index == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => _tabController.animateTo(index),
        child: Container(
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.blue,
            borderRadius: BorderRadius.only(
              topLeft: index == 0 ? const Radius.circular(0) : Radius.zero,
              topRight: index == 2 ? const Radius.circular(0) : Radius.zero,
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.blue : Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

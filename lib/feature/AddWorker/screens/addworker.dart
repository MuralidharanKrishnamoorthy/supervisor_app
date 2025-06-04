import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supervisor_app/core/provider/addworkerprovider.dart';
import 'package:supervisor_app/feature/AddWorker/screens/addtoproject.dart';

class Addworker extends StatefulWidget {
  const Addworker({super.key});

  @override
  State<Addworker> createState() => _AddworkerState();
}

class _AddworkerState extends State<Addworker> {
  final TextEditingController _searchController = TextEditingController();

  Color getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case "high":
        return Colors.red;
      case "normal":
        return Colors.grey;
      case "medium":
        return Colors.orange;
      default:
        return Colors.black;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF009DFF),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Ongoing Projects",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search by postal code / street name",
                hintStyle: const TextStyle(fontWeight: FontWeight.bold),
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {
                Provider.of<ServiceOrderProvider>(
                  context,
                  listen: false,
                ).searchOrders(value);
              },
            ),
          ),

          // Project Cards
          Expanded(
            child: Consumer<ServiceOrderProvider>(
              builder: (context, provider, child) {
                final orders = provider.orders;

                if (orders.isEmpty) {
                  return const Center(
                    child: Text(
                      "No projects found.",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header with SVO number and add icon
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "# SVO ${order.svoNumber}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE3F2FD),
                                      border: Border.all(
                                        color: Colors.blue,
                                        width: 1.5,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.person_add_alt_1_outlined,
                                        color: Colors.blue,
                                      ),
                                      onPressed: () {
                                        showAddToProjectSheet(
                                          context,
                                          order.svoNumber,
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 6),

                              // Priority
                              Text(
                                "Priority: ${order.priority}",
                                style: TextStyle(
                                  color: getPriorityColor(order.priority),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),

                              const SizedBox(height: 8),

                              // Dates
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Act Start Date",
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "${order.startDate.day.toString().padLeft(2, '0')}/${order.startDate.month.toString().padLeft(2, '0')}/${order.startDate.year}",
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      const Text(
                                        "Sch End Date",
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "${order.endDate.day.toString().padLeft(2, '0')}/${order.endDate.month.toString().padLeft(2, '0')}/${order.endDate.year}",
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              const SizedBox(height: 10),

                              const Text(
                                "Customer Details",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                              const SizedBox(height: 4),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    order.customerName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    order.phone,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                order.address,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

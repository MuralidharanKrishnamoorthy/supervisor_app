import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FinalApprovalPage extends StatelessWidget {
  const FinalApprovalPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock grouped data for UI
    final groupedItems = [
      {
        "date": DateTime(2024, 12, 13),
        "items": [
          {
            "itemName": "Item Name",
            "itemCode": "Item Code",
            "serialNum": "####",
            "qty": "#",
          },
          {
            "itemName": "Item Name",
            "itemCode": "Item Code",
            "serialNum": "####",
            "qty": "#",
          },
        ],
      },
      {
        "date": DateTime(2024, 12, 12),
        "items": [
          {
            "itemName": "Item Name",
            "itemCode": "Item Code",
            "serialNum": "####",
            "qty": "#",
          },
          {
            "itemName": "Item Name",
            "itemCode": "Item Code",
            "serialNum": "####",
            "qty": "#",
          },
        ],
      },
      {
        "date": DateTime(2024, 12, 11),
        "items": [
          {
            "itemName": "Item Name",
            "itemCode": "Item Code",
            "serialNum": "####",
            "qty": "#",
          },
          {
            "itemName": "Item Name",
            "itemCode": "Item Code",
            "serialNum": "####",
            "qty": "#",
          },
        ],
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          "Final Approve List",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        toolbarHeight: 56,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Work Order List Row
              Row(
                children: [
                  const Text(
                    "Work Order List",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    "Stall ID(if any)",
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Grouped by date
              ...groupedItems.map((group) {
                final dateStr = DateFormat(
                  'dd/MM/yyyy',
                ).format(group["date"] as DateTime);
                final items = group["items"] as List;
                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dateStr,
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 6),
                      ...items.map<Widget>(
                        (item) => Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.green.shade200),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item["itemName"] ?? "",
                                      style: const TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      item["itemCode"] ?? "",
                                      style: const TextStyle(
                                        color: Colors.green,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      "Serial Num: < ${item["serialNum"]} >",
                                      style: const TextStyle(
                                        color: Colors.green,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.green.shade200,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  item["qty"].toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 24),
              // Approve/Reject Buttons
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green),
                      ),
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Approve",
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.red.shade100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red),
                      ),
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Reject",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

// ApprovePage.dart
import 'package:flutter/material.dart';
import 'package:supervisor_app/feature/Ongoingpage/screens/resubmitworklist.dart';

class ApprovePage extends StatefulWidget {
  const ApprovePage({super.key});

  @override
  State<ApprovePage> createState() => _ApprovePageState();
}

class _ApprovePageState extends State<ApprovePage> {
  final items = [
    {
      "itemName": "Item Name",
      "itemCode": "Item Code",
      "serialNums": ["####"],
      "qty": "#",
      "isHeader": false, // Mark as header for special styling
    },
    {
      "itemName": "ESVP Pulley Box",
      "itemCode": "ESVP",
      "serialNums": [],
      "qty": 1,
      "isHeader": false,
    },
    {
      "itemName": "Kansa Korea Meter",
      "itemCode": "KKM",
      "serialNums": ["10111", "10222", "10333"],
      "qty": 1,
      "isHeader": false,
    },
    {
      "itemName": "1 1/2 SCH 40 ELBOW",
      "itemCode": "1 1/2 SCH 40 ELBOW",
      "serialNums": [],
      "qty": 10,
      "isHeader": false,
    },
    {
      "itemName": "C400 Regulator",
      "itemCode": "C400",
      "serialNums": ["1122"],
      "qty": 1,
      "isHeader": false,
    },
  ];

  late List<bool> selected;

  @override
  void initState() {
    super.initState();
    selected = List.generate(items.length, (_) => false);
  }

  bool get allSelected => selected.isNotEmpty && selected.every((e) => e);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text(
          "Final Approval List",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        toolbarHeight: 56,
      ),
      body: Column(
        children: [
          // Top blue info section
          Container(
            width: double.infinity,
            color: Colors.blue,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                const Text(
                  "SVO 7670756",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: const [
                    Expanded(
                      child: Text(
                        "Cust Name .",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      "Ph: ########",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                const Text(
                  "#32-01 CapitaGreen, 138 Market Street,\nSingapore 048947",
                  style: TextStyle(color: Colors.white, fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Row(
                  children: const [
                    Expanded(
                      child: Text(
                        "Sup Code :",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                    Text(
                      "SVC0000#",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Search bar
          Container(
            margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.shade100),
            ),
            child: const TextField(
              enabled: false, // No functionality for now
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: "Item Code / Name",
                border: InputBorder.none,
              ),
            ),
          ),
          // List of item cards (including header)
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final isSelected = selected[index];
                final isHeader = item["isHeader"] == true;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selected[index] = !selected[index];
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? Colors.green.shade100
                              : isHeader
                              ? Colors.green.shade50
                              : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color:
                            isSelected
                                ? Colors.green
                                : isHeader
                                ? Colors.green.shade200
                                : Colors.blue.shade200,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'bc fetch',
                                style: TextStyle(
                                  color: isHeader ? Colors.green : Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'bc fetch',
                                style: TextStyle(
                                  color: isHeader ? Colors.green : Colors.grey,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "S/N: < ${(item["serialNums"] as List).isNotEmpty ? (item["serialNums"] as List).join(", ") : "####"} >",
                                style: TextStyle(
                                  color: isHeader ? Colors.green : Colors.grey,
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
                              color:
                                  isHeader
                                      ? Colors.green.shade200
                                      : Colors.blue.shade200,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            item["qty"].toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: isHeader ? Colors.green : Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red, width: 2),
                      foregroundColor: Colors.red,
                      backgroundColor: Colors.red.shade100,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Reject",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed:
                      allSelected
                          ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ResubmitWorkListPage(),
                              ),
                            );
                          }
                          : null,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.green.shade700, width: 2),
                    backgroundColor: Colors.green.shade100,
                    foregroundColor: Colors.green.shade700,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Approve",
                    style: TextStyle(fontWeight: FontWeight.bold),
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

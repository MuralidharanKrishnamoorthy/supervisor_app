import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supervisor_app/core/provider/ContractProvider.dart';
import 'package:supervisor_app/feature/Assign/screens/creatework.dart';

class Assignwork extends StatelessWidget {
  const Assignwork({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF009DFF),
        title: const Text("Select Contract"),
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      body: const ContractSelector(),
    );
  }
}

class ContractSelector extends StatelessWidget {
  const ContractSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ContractProvider>(context);

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'Search by postal code / address',
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: provider.search,
          ),
        ),
        Expanded(
          child:
              provider.contracts.isEmpty
                  ? const Center(
                    child: Text(
                      "No Results Found",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                  : ListView.builder(
                    itemCount: provider.contracts.length,
                    itemBuilder: (context, index) {
                      final contract = provider.contracts[index];
                      final isSelected = provider.selectedIndex == index;

                      return GestureDetector(
                        onTap: () {
                          provider.selectIndex(index);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CreateWorkOrderPage(),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color:
                                isSelected
                                    ? const Color(0xFFE6F4FF)
                                    : Colors.white,
                            border: Border.all(
                              color:
                                  isSelected
                                      ? const Color(0xFF009DFF)
                                      : Colors.grey.shade300,
                              width: isSelected ? 1.5 : 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color:
                                    isSelected
                                        ? const Color(0xFF009DFF)
                                        : Colors.grey,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  contract.address,
                                  style: TextStyle(
                                    color:
                                        isSelected
                                            ? const Color(0xFF009DFF)
                                            : Colors.black,
                                    fontWeight:
                                        isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
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
    );
  }
}

class AssignWorkPage extends StatefulWidget {
  const AssignWorkPage({super.key});

  @override
  State<AssignWorkPage> createState() => _AssignWorkPageState();
}

class _AssignWorkPageState extends State<AssignWorkPage> {
  int? selectedIndex; // <-- Make nullable, so nothing is selected initially

  final List<String> addresses = [
    "#05-02 Marina Bay Financial Centre, Singapore 018981",
    "3 Temasek Avenue, #21-00 Centennial Tower, Singapore 039190",
    "1 Raffles Place, #44-02 One Raffles Place Tower 1, Singapore 048616",
    "138 Market Street, #32-01 CapitaGreen, Singapore 048946",
    "6 Collyer Quay, #26-00 Income at Raffles, Singapore 049318",
    "9 Battery Road, #17-02 Straits Trading Building, Singapore 049910",
    "9 Battery Road, #17-02 Straits Trading Building, Singapore 049910",
    "120 Robinson Road, #08-01 Singapore 068913",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF009DFF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "Select Contract",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        toolbarHeight: 56,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          children: [
            // Search bar
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade100),
              ),
              child: const TextField(
                enabled: false, // No functionality for now
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: "Search by postal code / address",
                  border: InputBorder.none,
                ),
              ),
            ),
            // Address list
            Expanded(
              child: ListView.builder(
                itemCount: addresses.length,
                itemBuilder: (context, index) {
                  final isSelected = selectedIndex == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CreateWorkOrderPage(),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color:
                            isSelected ? const Color(0xFF009DFF) : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color:
                              isSelected
                                  ? const Color(0xFF009DFF)
                                  : Colors.blue.shade100,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: ListTile(
                        leading: Icon(
                          Icons.location_on,
                          color:
                              isSelected
                                  ? Colors.white
                                  : const Color(0xFF009DFF),
                        ),
                        title: Text(
                          addresses[index],
                          style: TextStyle(
                            color:
                                isSelected
                                    ? Colors.white
                                    : const Color(0xFF009DFF),
                            fontWeight:
                                isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

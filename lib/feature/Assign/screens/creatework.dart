import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CreateWorkOrderPage extends StatefulWidget {
  const CreateWorkOrderPage({super.key});

  @override
  State<CreateWorkOrderPage> createState() => _CreateWorkOrderPageState();
}

class _CreateWorkOrderPageState extends State<CreateWorkOrderPage> {
  DateTime? startDate = DateTime.now();
  DateTime? endDate = DateTime.now();
  final TextEditingController _taskController = TextEditingController();
  final List<String> tasks = [];
  bool isServiceOrder = false;
  bool isSmallPipingOrder = true;
  final List<String> workers = [
    "Piping Man 1",
    "Piping Man 2",
    "Piping Man 3",
    "Piping Man 4",
  ];
  final List<bool> selectedWorkers = [false, false, false, false];

  Future<void> _pickDate({required bool isStart}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          isStart ? (startDate ?? DateTime.now()) : (endDate ?? DateTime.now()),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder:
          (context, child) => Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: Colors.blue,
                onPrimary: Colors.white,
                onSurface: Colors.black,
              ),
            ),
            child: child!,
          ),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          startDate = picked;
          if (endDate != null && endDate!.isBefore(startDate!)) {
            endDate = startDate;
          }
        } else {
          endDate = picked;
          if (startDate != null && endDate!.isBefore(startDate!)) {
            startDate = endDate;
          }
        }
      });
    }
  }

  void _addTask() {
    final text = _taskController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        tasks.add(text);
        _taskController.clear();
      });
    }
  }

  void _removeTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  void _toggleWorker(int index) {
    setState(() {
      selectedWorkers[index] = !selectedWorkers[index];
    });
  }

  void _onOrderTypeChanged(bool serviceOrder) {
    setState(() {
      isServiceOrder = serviceOrder;
      isSmallPipingOrder = !serviceOrder;
    });
  }

  void _assignWork() {
    // Implement your assign logic here
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Work assigned!")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "Create Work Order",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        toolbarHeight: 56,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          children: [
            // Contract Info Card
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.blue.shade100),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "UL00001582",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "# 01-1197, Blk 206/Toa Payoh North, Singapore 310206",
                    style: TextStyle(color: Colors.black87, fontSize: 14),
                  ),
                ],
              ),
            ),
            // Dates
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _pickDate(isStart: true),
                    child: AbsorbPointer(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Start Date",
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                        controller: TextEditingController(
                          text:
                              startDate != null
                                  ? DateFormat('dd/MM/yyyy').format(startDate!)
                                  : "",
                        ),
                        readOnly: true,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _pickDate(isStart: false),
                    child: AbsorbPointer(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: "End Date",
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                        controller: TextEditingController(
                          text:
                              endDate != null
                                  ? DateFormat('dd/MM/yyyy').format(endDate!)
                                  : "",
                        ),
                        readOnly: true,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Add Task
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _taskController,
                    decoration: const InputDecoration(
                      labelText: "Add Task",
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.add_circle, color: Colors.blue),
                  onPressed: _addTask,
                ),
              ],
            ),
            // Show tasks as blue chips with remove icon
            Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 8,
                children: List.generate(tasks.length, (index) {
                  return Chip(
                    label: Text(
                      tasks[index],
                      style: const TextStyle(color: Colors.blue),
                    ),
                    backgroundColor: Colors.blue.shade50,
                    deleteIcon: const Icon(Icons.close, color: Colors.blue),
                    onDeleted: () => _removeTask(index),
                  );
                }),
              ),
            ),
            const SizedBox(height: 8),
            // Order Type
            Row(
              children: [
                Expanded(
                  child: RadioListTile<bool>(
                    value: true,
                    groupValue: isServiceOrder,
                    onChanged: (val) => _onOrderTypeChanged(true),
                    title: const Text(
                      "Service Order",
                      style: TextStyle(color: Colors.blue),
                    ),
                    activeColor: Colors.blue,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                Expanded(
                  child: RadioListTile<bool>(
                    value: true,
                    groupValue: isSmallPipingOrder,
                    onChanged: (val) => _onOrderTypeChanged(false),
                    title: const Text(
                      "Small Piping Order",
                      style: TextStyle(color: Colors.blue),
                    ),
                    activeColor: Colors.blue,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
            // Workers
            Expanded(
              child: ListView.builder(
                itemCount: workers.length,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    value: selectedWorkers[index],
                    onChanged: (val) => _toggleWorker(index),
                    title: Text(
                      workers[index],
                      style: const TextStyle(color: Colors.blue),
                    ),
                    activeColor: Colors.blue,
                    checkColor: Colors.white,
                    controlAffinity: ListTileControlAffinity.trailing,
                  );
                },
              ),
            ),
            // Assign Work Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _assignWork,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Assign Work",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

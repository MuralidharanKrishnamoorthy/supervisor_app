import 'package:flutter/material.dart';

void showAddToProjectSheet(BuildContext context, String orderId) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder:
        (context) => DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.65,
          minChildSize: 0.6,
          maxChildSize: 0.95,
          builder:
              (_, scrollController) => _AddToProjectContent(
                scrollController: scrollController,
                orderId: orderId,
              ),
        ),
  );
}

class _AddToProjectContent extends StatefulWidget {
  final ScrollController scrollController;
  final String orderId;

  const _AddToProjectContent({
    required this.scrollController,
    required this.orderId,
  });

  @override
  State<_AddToProjectContent> createState() => _AddToProjectContentState();
}

class _AddToProjectContentState extends State<_AddToProjectContent> {
  final List<int> _selectedDates = [];
  // Initialize directly instead of using late
  DateTime _currentMonth = DateTime.now();
  String _selectedResource = 'Team A';

  @override
  void initState() {
    super.initState();
    // No need to initialize here as we've done it above
  }

  String _getMonthYearText() {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[_currentMonth.month - 1]} ${_currentMonth.year}';
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
    });
  }

  void _toggleDateSelection(int date) {
    setState(() {
      if (_selectedDates.contains(date)) {
        _selectedDates.remove(date);
      } else {
        _selectedDates.add(date);
      }
    });
  }

  void _navigateToPreviewPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => _AssignmentPreviewPage(
              orderId: widget.orderId,
              selectedDates: _selectedDates,
              month: _currentMonth.month,
              year: _currentMonth.year,
              resource: _selectedResource,
            ),
      ),
    );
  }

  void _selectResource(String resource) {
    setState(() {
      _selectedResource = resource;
    });
  }

  int _getDaysInMonth() {
    return DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;
  }

  int _getFirstDayOfMonth() {
    return DateTime(_currentMonth.year, _currentMonth.month, 1).weekday % 7;
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final daysInMonth = _getDaysInMonth();
    final firstDayOfMonth = _getFirstDayOfMonth();

    return SingleChildScrollView(
      controller: widget.scrollController,
      padding: const EdgeInsets.all(16),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: screenHeight * 0.7),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Select Resource",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  "# SVO ${widget.orderId}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Resource Chips
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final label in [
                  'Team A',
                  'Team B',
                  'Team C',
                  'Team D',
                  'Worker 1',
                  'Worker 2',
                  'Worker 3',
                ])
                  GestureDetector(
                    onTap: () => _selectResource(label),
                    child: Chip(
                      label: Text(label),
                      backgroundColor:
                          _selectedResource == label
                              ? Colors.blue.shade100
                              : Colors.white,
                      shape: StadiumBorder(
                        side: BorderSide(
                          color:
                              _selectedResource == label
                                  ? Colors.blue
                                  : Colors.blue.shade300,
                          width: _selectedResource == label ? 2 : 1,
                        ),
                      ),
                      labelStyle: TextStyle(
                        color:
                            _selectedResource == label
                                ? Colors.blue.shade800
                                : Colors.blue,
                        fontWeight:
                            _selectedResource == label
                                ? FontWeight.bold
                                : FontWeight.normal,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),

            // Calendar Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, size: 14),
                  onPressed: _previousMonth,
                ),
                Text(
                  _getMonthYearText(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios, size: 14),
                  onPressed: _nextMonth,
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Calendar
            Table(
              border: TableBorder.all(color: Colors.transparent),
              children: [
                TableRow(
                  children: [
                    for (final day in ['S', 'M', 'T', 'W', 'T', 'F', 'S'])
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            day,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                ...List.generate((daysInMonth + firstDayOfMonth + 6) ~/ 7, (
                  week,
                ) {
                  return TableRow(
                    children: List.generate(7, (day) {
                      final date = week * 7 + day + 1 - firstDayOfMonth;
                      if (date < 1 || date > daysInMonth) {
                        return const SizedBox.shrink();
                      }

                      final isSelected = _selectedDates.contains(date);
                      // Simulating different states for demonstration
                      final isBlocked = (date % 11 == 0);
                      final isAvailable = (date % 7 == 0);
                      final isScheduled = (date % 5 == 0);

                      Color cellColor = Colors.grey.shade200; // Default
                      if (isSelected) {
                        cellColor = Colors.blue;
                      } else if (isBlocked)
                        cellColor = Colors.redAccent;
                      else if (isAvailable)
                        cellColor = Colors.greenAccent;
                      else if (isScheduled)
                        cellColor = Colors.blue.shade200;

                      return GestureDetector(
                        onTap: () => _toggleDateSelection(date),
                        child: Container(
                          margin: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: cellColor,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Center(
                            child: Text(
                              date.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color:
                                    isSelected || isBlocked || isScheduled
                                        ? Colors.white
                                        : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  );
                }),
              ],
            ),
            const SizedBox(height: 20),

            // Legend
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                _LegendDot(color: Colors.redAccent, label: 'Blocked'),
                _LegendDot(color: Colors.greenAccent, label: 'Available'),
                _LegendDot(color: Colors.blue, label: 'Scheduled'),
                _LegendDot(color: Colors.grey, label: 'Available'),
              ],
            ),
            const SizedBox(height: 20),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade200,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed:
                        _selectedDates.isNotEmpty
                            ? _navigateToPreviewPage
                            : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      disabledBackgroundColor: Colors.blue.shade200,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        "Assign Work to #SVO ${widget.orderId}",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AssignmentPreviewPage extends StatelessWidget {
  final String orderId;
  final List<int> selectedDates;
  final int month;
  final int year;
  final String resource;

  const _AssignmentPreviewPage({
    required this.orderId,
    required this.selectedDates,
    required this.month,
    required this.year,
    required this.resource,
  });

  String _getMonthName() {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Assignment Preview - SVO $orderId"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Assignment Details",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const Divider(),
                    const SizedBox(height: 10),
                    _DetailRow(label: "Service Order", value: "SVO $orderId"),
                    _DetailRow(label: "Resource Assigned", value: resource),
                    _DetailRow(
                      label: "Selected Dates",
                      value:
                          "${selectedDates.length} days in ${_getMonthName()} $year",
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Scheduled Dates",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child:
                      selectedDates.isEmpty
                          ? const Center(child: Text("No dates selected"))
                          : ListView.builder(
                            itemCount: selectedDates.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                leading: const Icon(
                                  Icons.calendar_today,
                                  color: Colors.blue,
                                ),
                                title: Text(
                                  "${_getMonthName()} ${selectedDates[index]}, $year",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text("Assigned to $resource"),
                                trailing: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade100,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Text(
                                    "Scheduled",
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.blue),
                      padding: const EdgeInsets.all(12),
                    ),
                    child: const Text("Edit Assignment"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Save the assignment and go back to the previous screens
                      Navigator.pop(context);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Work assigned to SVO $orderId"),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.all(12),
                    ),
                    child: const Text(
                      "Confirm Assignment",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              "$label:",
              style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label),
      ],
    );
  }
}

class SelectContractPage extends StatefulWidget {
  const SelectContractPage({super.key});

  @override
  State<SelectContractPage> createState() => _SelectContractPageState();
}

class _SelectContractPageState extends State<SelectContractPage> {
  int selectedIndex = 0;

  final List<String> addresses = [
    "#05-02 Marina Bay Financial Centre, Singapore 018981",
    "3 Temasek Avenue, #21-00 Centennial Tower, Singapore 039190",
    "1 Raffles Place, #44-02 One Raffles Place Tower 1, Singapore 048616",
    "138 Market Street, #32-01 CapitaGreen, Singapore 048947",
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
        backgroundColor: Colors.blue,
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
                      // Navigate to another page (replace with your page)
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => DummyNextPage(address: addresses[index]),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue.shade100 : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color:
                              isSelected ? Colors.blue : Colors.blue.shade100,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: ListTile(
                        leading: Icon(
                          Icons.location_on,
                          color: isSelected ? Colors.blue : Colors.grey,
                        ),
                        title: Text(
                          addresses[index],
                          style: TextStyle(
                            color: isSelected ? Colors.blue : Colors.black,
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

class DummyNextPage extends StatelessWidget {
  final String address;
  const DummyNextPage({super.key, required this.address});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Next Page"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Text(
          "Selected Address:\n$address",
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

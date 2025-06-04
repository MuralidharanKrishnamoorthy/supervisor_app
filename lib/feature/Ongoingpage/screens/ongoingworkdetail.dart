import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:supervisor_app/core/model/ongoingworkdetail.dart';
import 'package:supervisor_app/core/provider/approvalprovider.dart';
import 'package:supervisor_app/core/provider/ongoingworkdetailedprovider.dart';

import 'package:supervisor_app/feature/Ongoingpage/screens/approvepage.dart';
import 'package:supervisor_app/feature/Ongoingpage/screens/ongoingpage.dart';

class OngoingWorkDetailsPage extends StatefulWidget {
  final ProjectDetails details;
  const OngoingWorkDetailsPage({super.key, required this.details});

  @override
  State<OngoingWorkDetailsPage> createState() => _OngoingWorkDetailsPageState();
}

class _OngoingWorkDetailsPageState extends State<OngoingWorkDetailsPage> {
  late DateTime selectedDate;
  late DateTime today;
  late ProjectDetailsProvider _provider;

  @override
  void initState() {
    super.initState();
    today = DateTime.now();
    selectedDate = today;
    _provider = ProjectDetailsProvider();
    final authBox = Hive.box('authBox');
    final accessToken = authBox.get('authToken') ?? '';
    _provider.fetchProjectDetails(
      docNo: widget.details.docNo,
      stallNo: '',
      usageDate: '',
      accessToken: accessToken,
    );
  }

  void _goToPreviousDate() {
    setState(() {
      selectedDate = selectedDate.subtract(const Duration(days: 1));
    });
  }

  void _goToNextDate() {
    if (!_isToday(selectedDate)) {
      setState(() {
        selectedDate = selectedDate.add(const Duration(days: 1));
      });
    }
  }

  bool _isToday(DateTime date) {
    return date.year == today.year &&
        date.month == today.month &&
        date.day == today.day;
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(170),
      child: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => Ongoingpage()),
            );
          },
        ),
        flexibleSpace: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.only(left: 36),
                  child: Text(
                    widget.details.docNo,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.details.customerName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Customer No: ${widget.details.customerNo.isNotEmpty ? widget.details.customerNo : 'NOT AVAILABLE'}",
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  widget.details.customerAddress,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  "Project TeamLeader Code : ${widget.details.contractNo}",
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('dd/MM/yyyy').format(selectedDate);

    return ChangeNotifierProvider<ProjectDetailsProvider>.value(
      value: _provider,
      child: Consumer<ProjectDetailsProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Scaffold(
              backgroundColor: Colors.white,
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (provider.error != null) {
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: _buildAppBar(context),
              body: Center(child: Text('Error: ${provider.error}')),
            );
          }

          final details = provider.details;
          //  ! snackbar message showing
          // if (details == null || details.lines.isEmpty) {
          //   WidgetsBinding.instance.addPostFrameCallback((_) {
          //     ScaffoldMessenger.of(context).showSnackBar(
          //       const SnackBar(
          //         content: Text('No data found'),
          //         backgroundColor: Colors.red,
          //       ),
          //     );
          //   });
          // }

          // Calculate filtered lines (will be empty if no details)
          List<ProjectLine> filteredLines = [];
          Map<String, List<ProjectLine>> groupedLines = {};

          if (details != null && details.lines.isNotEmpty) {
            final selectedDateStr = DateFormat(
              'yyyy-MM-dd',
            ).format(selectedDate);
            filteredLines =
                details.lines
                    .where((line) => line.usageDate == selectedDateStr)
                    .toList();

            // Group filtered lines by jobDescription, itemDescription, itemNo
            for (final line in filteredLines) {
              final key =
                  '${line.jobDescription}${line.itemDescription}${line.itemNo}';
              groupedLines.putIfAbsent(key, () => []).add(line);
            }
          }

          return Scaffold(
            backgroundColor: const Color(0xFFF7F7F7),
            appBar: _buildAppBar(context),
            body: Column(
              children: [
                // Calendar row - Always shown
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_left, size: 28),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: _goToPreviousDate,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        dateStr,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 2),
                      if (!_isToday(selectedDate))
                        IconButton(
                          icon: const Icon(Icons.arrow_right, size: 28),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: _goToNextDate,
                        ),
                      if (_isToday(selectedDate)) const SizedBox(width: 40),
                      const SizedBox(width: 8),
                      const Spacer(),
                      GestureDetector(
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime(2000),
                            lastDate: today,
                          );
                          if (picked != null && picked != selectedDate) {
                            setState(() {
                              selectedDate = picked;
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.12),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.calendar_today,
                            size: 20,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Summary label - Always shown
                Container(
                  width: double.infinity,
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: const Text(
                    "Summary",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),

                // Content area - Show either data or "No Job assigned" message
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child:
                        filteredLines.isEmpty
                            ? Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 18,
                                  horizontal: 22,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.red.shade100.withOpacity(
                                        0.2,
                                      ),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.info_outline,
                                      color: Colors.red.shade400,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      "No Job assigned for this date",
                                      style: TextStyle(
                                        color: Colors.red.shade400,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            : ListView.builder(
                              padding: const EdgeInsets.all(0),
                              itemCount: groupedLines.length,
                              itemBuilder: (context, index) {
                                final group = groupedLines.values.elementAt(
                                  index,
                                );
                                final firstLine = group.first;
                                final totalQty = group.fold<double>(
                                  0,
                                  (sum, l) => sum + l.qty,
                                );

                                return Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: BorderSide(
                                      color: Colors.blue.shade100,
                                    ),
                                  ),
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 8,
                                    horizontal: 8,
                                  ),
                                  elevation: 0,
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 12,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Top Row: Job Description & Qty
                                        Row(
                                          children: [
                                            Expanded(
                                              child: RichText(
                                                text: TextSpan(
                                                  children: [
                                                    const TextSpan(
                                                      text: 'Job Description: ',
                                                      style: TextStyle(
                                                        color: Colors.blue,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text:
                                                          firstLine
                                                              .jobDescription,
                                                      style: const TextStyle(
                                                        color: Colors.blue,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 4,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.blue,
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              child: Text(
                                                '${totalQty.toInt()}',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        // Item Name
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              const TextSpan(
                                                text: 'Item Name: ',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              TextSpan(
                                                text: firstLine.itemDescription,
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Item Code
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              const TextSpan(
                                                text: 'Item Code: ',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              TextSpan(
                                                text: firstLine.itemNo,
                                                style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Serial Numbers (S/N) list
                                        if (group.any(
                                          (l) => l.serialNo.isNotEmpty,
                                        ))
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: 6,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children:
                                                  group
                                                      .where(
                                                        (l) =>
                                                            l
                                                                .serialNo
                                                                .isNotEmpty,
                                                      )
                                                      .map(
                                                        (l) => Row(
                                                          children: [
                                                            const Text(
                                                              'S/N: ',
                                                              style: TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic,
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Text(
                                                                l.serialNo,
                                                                style: const TextStyle(
                                                                  color:
                                                                      Colors
                                                                          .grey,
                                                                  fontSize: 13,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .italic,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                      .toList(),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                  ),
                ),
                // Preview button - Always shown
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => ChangeNotifierProvider(
                                  create:
                                      (_) =>
                                          ApprovalProvider()..fetchApprovalItems(
                                            docNo: widget.details.docNo,
                                            stallNo: widget.details.stallNo,
                                            usageDate:
                                                '', // or selectedDate if you want
                                          ),
                                  child: ApprovePage(),
                                ),
                          ),
                        );
                      },
                      child: const Text(
                        "Preview Consolidated List",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

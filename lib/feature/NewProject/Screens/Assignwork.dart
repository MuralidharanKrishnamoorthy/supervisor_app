import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supervisor_app/core/model/selectteam.dart';
import 'package:supervisor_app/core/provider/teamprovider.dart';
import 'package:supervisor_app/core/service/networkservice.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AssignWorkPopup extends StatefulWidget {
  final String projectId;

  const AssignWorkPopup({super.key, required this.projectId});

  @override
  State<AssignWorkPopup> createState() => _AssignWorkPopupState();
}

class _AssignWorkPopupState extends State<AssignWorkPopup> {
  List<DateTime> selectedDates = [];

  RangeSelectionMode _rangeSelectionMode =
      RangeSelectionMode.toggledOn; // Changed to toggledOn by default
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  void _onDaySelected(DateTime day, DateTime _) {
    setState(() {
      if (selectedDates.any((d) => _isSameDay(d, day))) {
        selectedDates.removeWhere((d) => _isSameDay(d, day));
      } else {
        selectedDates.add(day);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final supervisorId = Hive.box('authBox').get('loginCode') ?? '';
    print('[DEBUG] AssignWorkPopup supervisorId: $supervisorId');
    return ChangeNotifierProvider(
      create: (_) => TeamProvider(supervisorId),
      child: Builder(
        builder: (context) {
          return DraggableScrollableSheet(
            initialChildSize: 0.70,
            minChildSize: 0.5,
            maxChildSize: 0.9,
            builder:
                (_, controller) => Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          controller: controller,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Top bar
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Select Team',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    ' ${widget.projectId}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 32),

                              // Team member chips
                              Consumer<TeamProvider>(
                                builder: (context, provider, _) {
                                  print(
                                    '[DEBUG] Provider isLoading: ${provider.isLoading}',
                                  );
                                  print(
                                    '[DEBUG] Provider team length: ${provider.team.length}',
                                  );
                                  if (provider.isLoading) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  if (provider.team.isEmpty) {
                                    print(
                                      '[DEBUG] No team members found in provider.',
                                    );
                                    return const Text('No team members found.');
                                  }
                                  print(
                                    '[DEBUG] Showing team members: ${provider.team.map((m) => m.driverName).toList()}',
                                  );
                                  return Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: List.generate(
                                      provider.team.length,
                                      (index) {
                                        final member = provider.team[index];
                                        return FilterChip(
                                          label: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(member.driverName),
                                              Text(
                                                member.servicemanRole,
                                                style: const TextStyle(
                                                  fontSize: 11,
                                                ),
                                              ),
                                            ],
                                          ),
                                          selected: member.isSelected,
                                          onSelected:
                                              (_) => provider.toggleSelection(
                                                index,
                                              ),
                                          selectedColor: Colors.blue,
                                          backgroundColor: Colors.grey.shade200,
                                          checkmarkColor: Colors.white,
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 20),

                              // Calendar view - FIXED RANGE SELECTION
                              TableCalendar(
                                focusedDay: DateTime.now(),
                                firstDay: DateTime(2020),
                                lastDay: DateTime(2030),
                                calendarFormat: CalendarFormat.month,
                                rangeSelectionMode: _rangeSelectionMode,
                                rangeStartDay: _rangeStart,
                                rangeEndDay: _rangeEnd,
                                onDaySelected: (selectedDay, focusedDay) {
                                  // Removed this callback to prevent conflicts
                                },
                                onRangeSelected: (start, end, focusedDay) {
                                  setState(() {
                                    _rangeStart = start;
                                    _rangeEnd = end;
                                    // Keep range selection mode active
                                    _rangeSelectionMode =
                                        RangeSelectionMode.toggledOn;
                                  });
                                },
                                calendarStyle: const CalendarStyle(
                                  // Perfect blue circles for start and end dates
                                  rangeStartDecoration: BoxDecoration(
                                    color: Colors.blue,
                                    shape: BoxShape.circle,
                                  ),
                                  rangeEndDecoration: BoxDecoration(
                                    color: Colors.blue,
                                    shape: BoxShape.circle,
                                  ),
                                  // Light blue shade for dates in between (no box shape)
                                  withinRangeDecoration: BoxDecoration(
                                    color:
                                        Colors
                                            .transparent, // Keep transparent to avoid box
                                  ),
                                  rangeHighlightColor: Color(
                                    0xFFE3F2FD,
                                  ), // Light blue shade for range
                                  selectedDecoration: BoxDecoration(
                                    color: Colors.blue,
                                    shape: BoxShape.circle,
                                  ),
                                  // Remove today's decoration - no grey circle
                                  todayDecoration: BoxDecoration(
                                    color: Colors.transparent,
                                  ),
                                  // Text styles
                                  selectedTextStyle: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  rangeStartTextStyle: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  rangeEndTextStyle: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  withinRangeTextStyle: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  todayTextStyle: TextStyle(
                                    color:
                                        Colors
                                            .black, // Normal black text for today
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                headerStyle: const HeaderStyle(
                                  formatButtonVisible: false,
                                  titleCentered: true,
                                ),
                              ),
                              const SizedBox(height: 10),

                              // Legend
                              const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  _LegendItem(
                                    color: Colors.red,
                                    label: "Blocked",
                                  ),
                                  _LegendItem(
                                    color: Colors.green,
                                    label: "Available",
                                  ),
                                  _LegendItem(
                                    color: Colors.blue,
                                    label: "Schedule",
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),

                              // Display selected range info
                              if (_rangeStart != null)
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Colors.blue.shade200,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      const Text(
                                        'Selected Date Range:',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _rangeEnd != null
                                            ? '${_rangeStart!.day}/${_rangeStart!.month}/${_rangeStart!.year} - ${_rangeEnd!.day}/${_rangeEnd!.month}/${_rangeEnd!.year}'
                                            : '${_rangeStart!.day}/${_rangeStart!.month}/${_rangeStart!.year} (Select end date)',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),

                      // Assign button at bottom
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: ElevatedButton(
                          onPressed: () async {
                            // Get selected team member
                            final provider = Provider.of<TeamProvider>(
                              context,
                              listen: false,
                            );
                            TeamMember? selectedMember =
                                provider.team
                                        .where((m) => m.isSelected)
                                        .isNotEmpty
                                    ? provider.team.firstWhere(
                                      (m) => m.isSelected,
                                    )
                                    : null;

                            if (selectedMember == null ||
                                _rangeStart == null ||
                                _rangeEnd == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Please select team member and date range',
                                  ),
                                ),
                              );
                              return;
                            }

                            // Call your service API
                            final networkService = NetworkService();
                            final success = await networkService.assignWorkToBC(
                              docNo: widget.projectId,
                              teamLeadNo: selectedMember.driverCode,
                              startDate: _rangeStart!,
                              endDate: _rangeEnd!,
                            );

                            if (success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Work assigned successfully!'),
                                ),
                              );
                              Navigator.pop(context);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Failed to assign work!'),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            minimumSize: const Size.fromHeight(45),
                          ),
                          child: const Text(
                            'Assign work',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
          );
        },
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(radius: 6, backgroundColor: color),
        const SizedBox(width: 6),
        Text(label),
      ],
    );
  }
}

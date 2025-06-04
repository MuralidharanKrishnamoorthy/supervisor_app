class OngoingProject {
  final String id;
  final String type;
  final String priority;
  final String customerNo;
  final String customerInfo;
  final String stallNo;
  final String address;
  final String status;
  final String schStart;
  final String schEnd;
  final String supervisor;
  final String team;

  OngoingProject({
    required this.id,
    required this.type,
    required this.priority,
    required this.customerNo,
    required this.customerInfo,
    required this.stallNo,
    required this.address,
    required this.status,
    required this.schStart,
    required this.schEnd,
    required this.supervisor,
    required this.team,
  });

  factory OngoingProject.fromJson(Map<String, dynamic> json) {
    return OngoingProject(
      id: json['doc_no'] ?? '',
      type: json['type'] ?? '',
      priority: json['priority_level'] ?? '',
      customerNo: json['customer_no'] ?? '',
      customerInfo: json['customer_name'] ?? '',
      stallNo: json['stall_no'] ?? '',
      address: json['customer_address'] ?? '',
      status: json['project_status'] ?? '',
      schStart: json['schedule_start_date'] ?? '',
      schEnd: json['schedule_end_date'] ?? '',
      supervisor: json['supervisor'] ?? '',
      team: json['team'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'doc_no': id,
      'type': type,
      'priority_level': priority,
      'customer_no': customerNo,
      'customer_name': customerInfo,
      'stall_no': stallNo,
      'customer_address': address,
      'project_status': status,
      'schedule_start_date': schStart,
      'schedule_end_date': schEnd,
      'supervisor': supervisor,
      'team': team,
    };
  }
}

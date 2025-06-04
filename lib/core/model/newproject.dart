class Project {
  final String id;
  final String priority;
  final String startDate;
  final String endDate;
  final String customerName;
  final String phone;
  final String address;
  final String projectStatus;
  final String customernumber;

  Project({
    required this.id,
    required this.priority,
    required this.startDate,
    required this.endDate,
    required this.customerName,
    required this.phone,
    required this.address,
    required this.projectStatus,
    required this.customernumber,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['doc_no'] ?? '',
      priority: json['priority_level'] ?? '',
      startDate: json['schedule_start_date'] ?? '',
      endDate: json['schedule_end_date'] ?? '',
      customerName: json['customer_name'] ?? '',
      phone: 'N/A',
      address: json['customer_address'] ?? '',
      projectStatus: json['project_status'] ?? '',
      customernumber: json['customer_no'] ?? '',
    );
  }
}

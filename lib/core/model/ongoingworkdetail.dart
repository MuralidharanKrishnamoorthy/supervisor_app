//! OngoingItemModel.dart
import '../provider/ongoingwork.dart' show WorkItem;

class OngoingItemModel {
  final String itemCode;
  final String serialNum;

  OngoingItemModel({required this.itemCode, required this.serialNum});

  factory OngoingItemModel.fromWorkItem(WorkItem item) {
    return OngoingItemModel(itemCode: item.itemCode, serialNum: item.serialNum);
  }
}

class ProjectDetails {
  final String docNo;
  final String contractNo;
  final String priorityLevel;
  final String customerNo;
  final String customerName;
  final String stallNo;
  final String customerAddress;
  final String projectStatus;
  final String serviceStartDate;
  final String serviceEndDate;
  final String scheduleStartDate;
  final String scheduleEndDate;
  final String serviceOrderRemark;
  final bool changeMeter;
  final bool newMeter;
  final List<ProjectLine> lines;

  ProjectDetails({
    required this.docNo,
    required this.contractNo,
    required this.priorityLevel,
    required this.customerNo,
    required this.customerName,
    required this.stallNo,
    required this.customerAddress,
    required this.projectStatus,
    required this.serviceStartDate,
    required this.serviceEndDate,
    required this.scheduleStartDate,
    required this.scheduleEndDate,
    required this.serviceOrderRemark,
    required this.changeMeter,
    required this.newMeter,
    required this.lines,
  });

  factory ProjectDetails.fromJson(Map<String, dynamic> json) {
    return ProjectDetails(
      docNo: json['doc_no'] ?? '',
      contractNo: json['contract_no'] ?? '',
      priorityLevel: json['priority_level'] ?? '',
      customerNo: json['customer_no'] ?? '',
      customerName: json['customer_name'] ?? '',
      stallNo: json['stall_no'] ?? '',
      customerAddress: json['customer_address'] ?? '',
      projectStatus: json['project_status'] ?? '',
      serviceStartDate: json['service_start_date'] ?? '',
      serviceEndDate: json['service_end_date'] ?? '',
      scheduleStartDate: json['schedule_start_date'] ?? '',
      scheduleEndDate: json['schedule_end_date'] ?? '',
      serviceOrderRemark: json['service_order_remark'] ?? '',
      changeMeter: json['change_meter'] ?? false,
      newMeter: json['new_meter'] ?? false,
      lines:
          (json['lines'] as List<dynamic>? ?? [])
              .map((e) => ProjectLine.fromJson(e))
              .toList(),
    );
  }
}

class ProjectLine {
  final String jobDescription;
  final String itemNo;
  final String itemDescription;
  final double qty;
  final String serialNo;
  final String usageDate; //

  ProjectLine({
    required this.jobDescription,
    required this.itemNo,
    required this.itemDescription,
    required this.qty,
    required this.serialNo,
    required this.usageDate, //
  });

  factory ProjectLine.fromJson(Map<String, dynamic> json) {
    return ProjectLine(
      jobDescription: json['job_description'] ?? '',
      itemNo: json['item_no'] ?? '',
      itemDescription: json['item_description'] ?? '',
      qty: (json['qty'] ?? 0).toDouble(),
      serialNo: json['serial_no'] ?? '',
      usageDate: json['usage_date'] ?? '',
    );
  }
}

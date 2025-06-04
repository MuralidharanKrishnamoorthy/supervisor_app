class ServiceOrderModel {
  final String svoNumber;
  final String priority;
  final DateTime startDate;
  final DateTime endDate;
  final String customerName;
  final String phone;
  final String address;

  ServiceOrderModel({
    required this.svoNumber,
    required this.priority,
    required this.startDate,
    required this.endDate,
    required this.customerName,
    required this.phone,
    required this.address,
  });
}

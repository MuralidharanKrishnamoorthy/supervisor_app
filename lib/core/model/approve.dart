class ApprovalItem {
  final String itemName;
  final String itemCode;
  final String serialNum;
  final int qty;

  ApprovalItem({
    required this.itemName,
    required this.itemCode,
    required this.serialNum,
    required this.qty,
  });

  factory ApprovalItem.fromJson(Map<String, dynamic> json) {
    return ApprovalItem(
      itemName: json['item_name'] ?? '',
      itemCode: json['item_code'] ?? '',
      serialNum: json['serial_num'] ?? '',
      qty: json['qty'] ?? 0,
    );
  }
}

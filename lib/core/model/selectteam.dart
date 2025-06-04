class TeamMember {
  final String driverCode;
  final String driverName;
  final String servicemanRole;
  final String team;
  bool isSelected;

  TeamMember({
    required this.driverCode,
    required this.driverName,
    required this.servicemanRole,
    required this.team,
    this.isSelected = false,
  });

  factory TeamMember.fromJson(Map<String, dynamic> json) {
    return TeamMember(
      driverCode: json['driver_code'] ?? '',
      driverName: json['driver_name'] ?? '',
      servicemanRole: json['serviceman_role'] ?? '',
      team: json['team'] ?? '',
    );
  }
}

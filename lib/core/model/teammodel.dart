class TeamMember {
  final String name;
  final bool isSelected;

  TeamMember({required this.name, this.isSelected = false});

  TeamMember copyWith({String? name, bool? isSelected}) {
    return TeamMember(
      name: name ?? this.name,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
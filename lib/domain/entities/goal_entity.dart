enum GoalType {
  goal,
  emergencyFund,
}

extension GoalTypeExtension on GoalType {
  String get value => this == GoalType.emergencyFund ? 'emergency_fund' : 'goal';

  static GoalType fromString(String val) =>
      val == 'emergency_fund' ? GoalType.emergencyFund : GoalType.goal;
}

enum GoalStatus {
  active,
  achieved,
  paused,
}

extension GoalStatusExtension on GoalStatus {
  String get value {
    switch (this) {
      case GoalStatus.active:
        return 'active';
      case GoalStatus.achieved:
        return 'achieved';
      case GoalStatus.paused:
        return 'paused';
    }
  }

  static GoalStatus fromString(String val) {
    switch (val) {
      case 'achieved':
        return GoalStatus.achieved;
      case 'paused':
        return GoalStatus.paused;
      case 'active':
      default:
        return GoalStatus.active;
    }
  }
}

/// Entitas Target Tabungan dan Dana Darurat (Dart Murni)
class GoalEntity {
  final String id;
  final String name;
  final GoalType type;
  final int targetAmount;
  final String? deadline;
  final GoalStatus status;
  final DateTime createdAt;

  const GoalEntity({
    required this.id,
    required this.name,
    required this.type,
    required this.targetAmount,
    this.deadline,
    this.status = GoalStatus.active,
    required this.createdAt,
  });

  bool get isEmergencyFund => type == GoalType.emergencyFund;
}

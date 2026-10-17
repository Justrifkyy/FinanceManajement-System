/// Kategori amplop anggaran
enum EnvelopeCategory {
  unassigned,
  buffer,
  needs,
  wants,
  payYourselfFirst,
}

extension EnvelopeCategoryExtension on EnvelopeCategory {
  String get value {
    switch (this) {
      case EnvelopeCategory.unassigned:
        return 'unassigned';
      case EnvelopeCategory.buffer:
        return 'buffer';
      case EnvelopeCategory.needs:
        return 'needs';
      case EnvelopeCategory.wants:
        return 'wants';
      case EnvelopeCategory.payYourselfFirst:
        return 'pay_yourself_first';
    }
  }

  static EnvelopeCategory fromString(String val) {
    switch (val) {
      case 'unassigned':
        return EnvelopeCategory.unassigned;
      case 'buffer':
        return EnvelopeCategory.buffer;
      case 'needs':
        return EnvelopeCategory.needs;
      case 'wants':
        return EnvelopeCategory.wants;
      case 'pay_yourself_first':
        return EnvelopeCategory.payYourselfFirst;
      default:
        return EnvelopeCategory.needs;
    }
  }
}

/// Entitas amplop anggaran (Dart Murni)
class EnvelopeEntity {
  final String id;
  final String name;
  final EnvelopeCategory category;
  final String? icon;
  final bool isSystem;
  final bool isArchived;
  final bool isPaused;
  final int sortOrder;
  final DateTime createdAt;

  const EnvelopeEntity({
    required this.id,
    required this.name,
    required this.category,
    this.icon,
    this.isSystem = false,
    this.isArchived = false,
    this.isPaused = false,
    this.sortOrder = 0,
    required this.createdAt,
  });

  bool get isLiquid =>
      !isArchived &&
      (category == EnvelopeCategory.unassigned ||
          category == EnvelopeCategory.needs ||
          category == EnvelopeCategory.wants);
}

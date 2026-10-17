enum BufferStatus {
  held,
  released,
}

extension BufferStatusExtension on BufferStatus {
  String get value => this == BufferStatus.held ? 'held' : 'released';

  static BufferStatus fromString(String val) =>
      val == 'released' ? BufferStatus.released : BufferStatus.held;
}

/// Entitas Bantalan Bulan Depan (Dart Murni)
class BufferEntryEntity {
  final String id;
  final int amount;
  final String releaseMonth;
  final BufferStatus status;
  final String holdTransactionId;
  final String? releaseTransactionId;
  final DateTime createdAt;

  const BufferEntryEntity({
    required this.id,
    required this.amount,
    required this.releaseMonth,
    this.status = BufferStatus.held,
    required this.holdTransactionId,
    this.releaseTransactionId,
    required this.createdAt,
  });

  bool get isHeld => status == BufferStatus.held;
}

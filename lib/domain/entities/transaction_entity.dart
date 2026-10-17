/// Jenis-jenis transaksi buku besar
enum TransactionType {
  income,
  expense,
  allocation,
  transfer,
  bufferHold,
  bufferRelease,
  goalDeposit,
  goalWithdraw,
  assetDeposit,
  assetWithdraw,
}

extension TransactionTypeExtension on TransactionType {
  String get value {
    switch (this) {
      case TransactionType.income:
        return 'income';
      case TransactionType.expense:
        return 'expense';
      case TransactionType.allocation:
        return 'allocation';
      case TransactionType.transfer:
        return 'transfer';
      case TransactionType.bufferHold:
        return 'buffer_hold';
      case TransactionType.bufferRelease:
        return 'buffer_release';
      case TransactionType.goalDeposit:
        return 'goal_deposit';
      case TransactionType.goalWithdraw:
        return 'goal_withdraw';
      case TransactionType.assetDeposit:
        return 'asset_deposit';
      case TransactionType.assetWithdraw:
        return 'asset_withdraw';
    }
  }

  static TransactionType fromString(String val) {
    switch (val) {
      case 'income':
        return TransactionType.income;
      case 'expense':
        return TransactionType.expense;
      case 'allocation':
        return TransactionType.allocation;
      case 'transfer':
        return TransactionType.transfer;
      case 'buffer_hold':
        return TransactionType.bufferHold;
      case 'buffer_release':
        return TransactionType.bufferRelease;
      case 'goal_deposit':
        return TransactionType.goalDeposit;
      case 'goal_withdraw':
        return TransactionType.goalWithdraw;
      case 'asset_deposit':
        return TransactionType.assetDeposit;
      case 'asset_withdraw':
        return TransactionType.assetWithdraw;
      default:
        return TransactionType.expense;
    }
  }
}

/// Entitas Transaksi Buku Besar (Dart Murni)
class TransactionEntity {
  final String id;
  final TransactionType type;
  final int amount;
  final DateTime occurredAt;
  final String localDate;
  final String? fromEnvelopeId;
  final String? toEnvelopeId;
  final String? goalId;
  final String? assetId;
  final bool countsAsSpending;
  final String? note;
  final String? source;
  final String? pendingIncomeId;
  final String? bufferEntryId;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const TransactionEntity({
    required this.id,
    required this.type,
    required this.amount,
    required this.occurredAt,
    required this.localDate,
    this.fromEnvelopeId,
    this.toEnvelopeId,
    this.goalId,
    this.assetId,
    this.countsAsSpending = false,
    this.note,
    this.source,
    this.pendingIncomeId,
    this.bufferEntryId,
    this.deletedAt,
    required this.createdAt,
    this.updatedAt,
  });

  bool get isDeleted => deletedAt != null;
}

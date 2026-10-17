import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/envelopes_table.dart';
import '../tables/transactions_table.dart';

part 'envelope_dao.g.dart';

@DriftAccessor(tables: [EnvelopesTable, TransactionsTable])
class EnvelopeDao extends DatabaseAccessor<AppDatabase> with _$EnvelopeDaoMixin {
  EnvelopeDao(super.db);

  /// Mengambil semua amplop aktif (tidak diarsipkan)
  Future<List<EnvelopesTableData>> getActiveEnvelopes() {
    return (select(envelopesTable)
          ..where((t) => t.isArchived.equals(false))
          ..orderBy([(t) => OrderingTerm(expression: t.sortOrder)]))
        .get();
  }

  /// Watch stream semua amplop aktif
  Stream<List<EnvelopesTableData>> watchActiveEnvelopes() {
    return (select(envelopesTable)
          ..where((t) => t.isArchived.equals(false))
          ..orderBy([(t) => OrderingTerm(expression: t.sortOrder)]))
        .watch();
  }

  /// Menghitung saldo amplop dari riwayat buku besar (transactions)
  /// Saldo = (Total uang masuk ke amplop) - (Total uang keluar dari amplop)
  Future<int> getEnvelopeBalance(String envelopeId) async {
    final incomingQuery = selectOnly(transactionsTable)
      ..addColumns([transactionsTable.amount.sum()])
      ..where(transactionsTable.toEnvelopeId.equals(envelopeId) &
          transactionsTable.deletedAt.isNull());
    final incomingRow = await incomingQuery.getSingle();
    final incoming = incomingRow.read(transactionsTable.amount.sum()) ?? 0;

    final outgoingQuery = selectOnly(transactionsTable)
      ..addColumns([transactionsTable.amount.sum()])
      ..where(transactionsTable.fromEnvelopeId.equals(envelopeId) &
          transactionsTable.deletedAt.isNull());
    final outgoingRow = await outgoingQuery.getSingle();
    final outgoing = outgoingRow.read(transactionsTable.amount.sum()) ?? 0;

    return incoming - outgoing;
  }

  /// Watch stream saldo untuk amplop tertentu
  Stream<int> watchEnvelopeBalance(String envelopeId) {
    final query = select(transactionsTable)
      ..where((t) =>
          (t.toEnvelopeId.equals(envelopeId) | t.fromEnvelopeId.equals(envelopeId)) &
          t.deletedAt.isNull());

    return query.watch().map((txs) {
      int balance = 0;
      for (final tx in txs) {
        if (tx.toEnvelopeId == envelopeId) {
          balance += tx.amount;
        }
        if (tx.fromEnvelopeId == envelopeId) {
          balance -= tx.amount;
        }
      }
      return balance;
    });
  }

  /// Menghitung total Liquid Cash: Saldo Unassigned + Needs + Wants
  Future<int> getLiquidCash() async {
    final activeEnvelopes = await (select(envelopesTable)
          ..where((t) =>
              t.isArchived.equals(false) &
              t.category.isIn(['unassigned', 'needs', 'wants'])))
        .get();

    int totalLiquid = 0;
    for (final env in activeEnvelopes) {
      totalLiquid += await getEnvelopeBalance(env.id);
    }
    return totalLiquid;
  }

  /// Watch total Liquid Cash
  Stream<int> watchLiquidCash() {
    return select(transactionsTable)
        .watch()
        .asyncMap((_) => getLiquidCash());
  }

  /// Tambah amplop baru
  Future<int> insertEnvelope(EnvelopesTableCompanion companion) {
    return into(envelopesTable).insert(companion);
  }

  /// Update amplop
  Future<bool> updateEnvelope(EnvelopesTableCompanion companion) {
    return update(envelopesTable).replace(companion);
  }

  /// Hapus (arsip) amplop - sistem amplop tidak boleh dihapus
  Future<int> archiveEnvelope(String id) {
    return (update(envelopesTable)
          ..where((t) => t.id.equals(id) & t.isSystem.equals(false)))
        .write(
      const EnvelopesTableCompanion(isArchived: Value(true)),
    );
  }

  /// Update data amplop (nama, kategori, ikon)
  Future<int> updateEnvelopeDetails({
    required String id,
    required String name,
    required String category,
    String? icon,
  }) {
    return (update(envelopesTable)
          ..where((t) => t.id.equals(id) & t.isSystem.equals(false)))
        .write(
      EnvelopesTableCompanion(
        name: Value(name),
        category: Value(category),
        icon: Value(icon),
      ),
    );
  }
}

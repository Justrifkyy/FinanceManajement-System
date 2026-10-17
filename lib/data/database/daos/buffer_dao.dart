import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/buffer_entries_table.dart';
import '../tables/transactions_table.dart';

part 'buffer_dao.g.dart';

@DriftAccessor(tables: [BufferEntriesTable, TransactionsTable])
class BufferDao extends DatabaseAccessor<AppDatabase> with _$BufferDaoMixin {
  BufferDao(super.db);

  /// Mengambil semua entri Bantalan yang berstatus 'held' dan sudah jatuh tempo (<= currentMonth 'YYYY-MM')
  /// Diurutkan dari yang paling lama (tertua).
  Future<List<BufferEntriesTableData>> getHeldEntriesDue(String currentMonth) {
    return (select(bufferEntriesTable)
          ..where((t) => t.status.equals('held') & t.releaseMonth.isSmallerOrEqualValue(currentMonth))
          ..orderBy([(t) => OrderingTerm.asc(t.releaseMonth)]))
        .get();
  }

  /// Menghitung total nominal Bantalan yang saat ini masih tertahan ('held')
  Future<int> getTotalHeld() async {
    final query = selectOnly(bufferEntriesTable)
      ..addColumns([bufferEntriesTable.amount.sum()])
      ..where(bufferEntriesTable.status.equals('held'));
    final row = await query.getSingle();
    return row.read(bufferEntriesTable.amount.sum()) ?? 0;
  }

  /// Watch total nominal Bantalan yang masih tertahan ('held')
  Stream<int> watchTotalHeld() {
    final query = select(bufferEntriesTable)
      ..where((t) => t.status.equals('held'));
    return query.watch().map((rows) {
      int sum = 0;
      for (final r in rows) {
        sum += r.amount;
      }
      return sum;
    });
  }

  /// Update status entri Bantalan menjadi 'released' secara idempoten.
  /// Mengembalikan jumlah baris yang terpengaruh (1 jika berhasil, 0 jika sudah pernah dicairkan).
  Future<int> markAsReleased({
    required String id,
    required String releaseTransactionId,
  }) {
    return (update(bufferEntriesTable)
          ..where((t) => t.id.equals(id) & t.status.equals('held')))
        .write(
      BufferEntriesTableCompanion(
        status: const Value('released'),
        releaseTransactionId: Value(releaseTransactionId),
      ),
    );
  }

  /// Simpan entri Bantalan baru
  Future<int> insertBufferEntry(BufferEntriesTableCompanion companion) {
    return into(bufferEntriesTable).insert(companion);
  }
}

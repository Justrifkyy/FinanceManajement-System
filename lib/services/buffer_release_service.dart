import 'package:drift/drift.dart';
import '../core/utils/date_helper.dart';
import '../core/utils/id_generator.dart';
import '../data/database/app_database.dart';

/// Layanan Pencairan Bantalan Bulan Depan (Income Buffer Release Service).
/// Wajib idempoten (BR-09): dipanggil berulang kali tidak mencairkan uang ganda.
/// Dijalankan setiap kali aplikasi dibuka (cold start) dan saat resume.
class BufferReleaseService {
  final AppDatabase _db;

  BufferReleaseService(this._db);

  /// Menjalankan pengecekan dan pencairan entri Bantalan yang sudah jatuh tempo.
  /// Mengembalikan total nominal Rupiah yang berhasil dicairkan pada sesi ini.
  Future<int> checkAndReleaseDueBuffers({DateTime? now}) async {
    final currentTime = now ?? DateTime.now();
    final currentMonth = DateHelper.toReleaseMonthString(currentTime);
    final todayLocalDate = DateHelper.toLocalDateString(currentTime);

    // Ambil entri tertahan yang jatuh tempo (<= currentMonth)
    final dueEntries = await _db.bufferDao.getHeldEntriesDue(currentMonth);
    if (dueEntries.isEmpty) {
      return 0;
    }

    int totalReleasedAmount = 0;

    for (final entry in dueEntries) {
      // Setiap pencairan wajib dibungkus dalam SATU db.transaction()
      final released = await _db.transaction<bool>(() async {
        final releaseTxId = IdGenerator.nextId();
        final utcNow = DateTime.now().toUtc();

        // 1. Update status 'held' -> 'released' dengan syarat masih 'held'
        final affectedRows = await _db.bufferDao.markAsReleased(
          id: entry.id,
          releaseTransactionId: releaseTxId,
        );

        // Jika 0 baris terpengaruh, berarti entri sudah dicairkan di proses lain (idempoten)
        if (affectedRows == 0) {
          return false;
        }

        // 2. Buat transaksi buku besar: type 'buffer_release' dari 'buffer' ke 'unassigned'
        await _db.transactionDao.insertTransaction(
          TransactionsTableCompanion.insert(
            id: releaseTxId,
            type: 'buffer_release',
            amount: entry.amount,
            occurredAt: utcNow,
            localDate: todayLocalDate,
            fromEnvelopeId: const Value('buffer'),
            toEnvelopeId: const Value('unassigned'),
            bufferEntryId: Value(entry.id),
            note: const Value('Pencairan otomatis Bantalan Bulan Depan'),
            createdAt: utcNow,
          ),
        );

        return true;
      });

      if (released) {
        totalReleasedAmount += entry.amount;
      }
    }

    return totalReleasedAmount;
  }
}

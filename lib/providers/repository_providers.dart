import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/envelope_repository.dart';
import '../data/repositories/transaction_repository.dart';
import '../services/buffer_release_service.dart';
import 'database_provider.dart';

final envelopeDaoProvider = Provider((ref) {
  final db = ref.watch(databaseProvider);
  return db.envelopeDao;
});

final transactionDaoProvider = Provider((ref) {
  final db = ref.watch(databaseProvider);
  return db.transactionDao;
});

final bufferDaoProvider = Provider((ref) {
  final db = ref.watch(databaseProvider);
  return db.bufferDao;
});

final subscriptionDaoProvider = Provider((ref) {
  final db = ref.watch(databaseProvider);
  return db.subscriptionDao;
});

final goalDaoProvider = Provider((ref) {
  final db = ref.watch(databaseProvider);
  return db.goalDao;
});

final settingsDaoProvider = Provider((ref) {
  final db = ref.watch(databaseProvider);
  return db.settingsDao;
});

final bufferReleaseServiceProvider = Provider((ref) {
  final db = ref.watch(databaseProvider);
  return BufferReleaseService(db);
});

final envelopeRepositoryProvider = Provider((ref) {
  final dao = ref.watch(envelopeDaoProvider);
  return EnvelopeRepository(dao);
});

final transactionRepositoryProvider = Provider((ref) {
  final dao = ref.watch(transactionDaoProvider);
  return TransactionRepository(dao);
});

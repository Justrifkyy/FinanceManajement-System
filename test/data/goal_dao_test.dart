import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:runway_finance/data/database/app_database.dart';
import 'package:runway_finance/data/database/daos/goal_dao.dart';
import 'package:runway_finance/data/database/daos/transaction_dao.dart';

void main() {
  late AppDatabase db;
  late GoalDao goalDao;
  late TransactionDao transactionDao;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    goalDao = db.goalDao;
    transactionDao = db.transactionDao;
  });

  tearDown(() async {
    await db.close();
  });

  group('GoalDao & Multiple Goals Tests', () {
    test('bisa menambah beberapa target dan menghitung saldo masing-masing secara independen', () async {
      final now = DateTime.now().toUtc();

      // Buat 2 target berbeda
      await goalDao.insertGoal(
        GoalsTableCompanion.insert(
          id: 'goal-1',
          name: 'Laptop Gaming',
          type: 'goal',
          targetAmount: 20000000,
          deadline: const Value('2026-12-31'),
          status: 'active',
          createdAt: now,
        ),
      );

      await goalDao.insertGoal(
        GoalsTableCompanion.insert(
          id: 'goal-2',
          name: 'Liburan Jepang',
          type: 'goal',
          targetAmount: 30000000,
          deadline: const Value('2027-06-30'),
          status: 'active',
          createdAt: now,
        ),
      );

      final activeGoals = await goalDao.getActiveGoals();
      expect(activeGoals.length, 2);

      // Setor dana ke goal-1: Rp 5.000.000
      await transactionDao.insertTransaction(
        TransactionsTableCompanion.insert(
          id: 'tx-g1',
          type: 'goal_deposit',
          amount: 5000000,
          occurredAt: now,
          localDate: '2026-10-17',
          fromEnvelopeId: const Value('unassigned'),
          goalId: const Value('goal-1'),
          createdAt: now,
        ),
      );

      // Setor dana ke goal-2: Rp 3.000.000
      await transactionDao.insertTransaction(
        TransactionsTableCompanion.insert(
          id: 'tx-g2',
          type: 'goal_deposit',
          amount: 3000000,
          occurredAt: now,
          localDate: '2026-10-17',
          fromEnvelopeId: const Value('unassigned'),
          goalId: const Value('goal-2'),
          createdAt: now,
        ),
      );

      // Cek saldo masing-masing
      final bal1 = await goalDao.getGoalBalance('goal-1');
      final bal2 = await goalDao.getGoalBalance('goal-2');
      expect(bal1, 5000000);
      expect(bal2, 3000000);

      // Tarik dana dari goal-1: Rp 1.000.000
      await transactionDao.insertTransaction(
        TransactionsTableCompanion.insert(
          id: 'tx-w1',
          type: 'goal_withdraw',
          amount: 1000000,
          occurredAt: now,
          localDate: '2026-10-17',
          goalId: const Value('goal-1'),
          toEnvelopeId: const Value('unassigned'),
          createdAt: now,
        ),
      );

      expect(await goalDao.getGoalBalance('goal-1'), 4000000);
      expect(await goalDao.getGoalBalance('goal-2'), 3000000);
    });

    test('bisa mengedit nama, nominal, dan deadline target', () async {
      final now = DateTime.now().toUtc();
      await goalDao.insertGoal(
        GoalsTableCompanion.insert(
          id: 'goal-edit',
          name: 'Target Awal',
          type: 'goal',
          targetAmount: 10000000,
          deadline: const Value('2026-11-01'),
          status: 'active',
          createdAt: now,
        ),
      );

      await goalDao.updateGoalDetails(
        id: 'goal-edit',
        name: 'Target Diubah',
        targetAmount: 15000000,
        deadline: '2026-12-01',
      );

      final goals = await goalDao.getActiveGoals();
      final updated = goals.firstWhere((g) => g.id == 'goal-edit');
      expect(updated.name, 'Target Diubah');
      expect(updated.targetAmount, 15000000);
      expect(updated.deadline, '2026-12-01');
    });

    test('archiveOrDeleteGoal mengarsipkan jika ada transaksi agar tidak melanggar foreign key', () async {
      final now = DateTime.now().toUtc();
      await goalDao.insertGoal(
        GoalsTableCompanion.insert(
          id: 'goal-tx',
          name: 'Target Ada Tx',
          type: 'goal',
          targetAmount: 5000000,
          status: 'active',
          createdAt: now,
        ),
      );

      // Tambah transaksi
      await transactionDao.insertTransaction(
        TransactionsTableCompanion.insert(
          id: 'tx-goal-ref',
          type: 'goal_deposit',
          amount: 1000000,
          occurredAt: now,
          localDate: '2026-10-17',
          goalId: const Value('goal-tx'),
          createdAt: now,
        ),
      );

      // Panggil archiveOrDeleteGoal
      await goalDao.archiveOrDeleteGoal('goal-tx');

      // Pastikan sudah tidak muncul di active goals
      final activeGoals = await goalDao.getActiveGoals();
      expect(activeGoals.any((g) => g.id == 'goal-tx'), isFalse);
    });
  });
}

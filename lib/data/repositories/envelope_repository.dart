import 'package:drift/drift.dart';
import '../../domain/entities/envelope_entity.dart';
import '../database/app_database.dart';
import '../database/daos/envelope_dao.dart';

class EnvelopeRepository {
  final EnvelopeDao _envelopeDao;

  EnvelopeRepository(this._envelopeDao);

  Future<List<EnvelopeEntity>> getActiveEnvelopes() async {
    final rows = await _envelopeDao.getActiveEnvelopes();
    return rows.map(_mapToEntity).toList();
  }

  Stream<List<EnvelopeEntity>> watchActiveEnvelopes() {
    return _envelopeDao.watchActiveEnvelopes().map(
          (rows) => rows.map(_mapToEntity).toList(),
        );
  }

  Future<int> getEnvelopeBalance(String envelopeId) {
    return _envelopeDao.getEnvelopeBalance(envelopeId);
  }

  Stream<int> watchEnvelopeBalance(String envelopeId) {
    return _envelopeDao.watchEnvelopeBalance(envelopeId);
  }

  Future<int> getLiquidCash() {
    return _envelopeDao.getLiquidCash();
  }

  Stream<int> watchLiquidCash() {
    return _envelopeDao.watchLiquidCash();
  }

  Future<int> createEnvelope({
    required String id,
    required String name,
    required EnvelopeCategory category,
    String? icon,
    int sortOrder = 0,
  }) {
    return _envelopeDao.insertEnvelope(
      EnvelopesTableCompanion.insert(
        id: id,
        name: name,
        category: category.value,
        icon: Value(icon),
        sortOrder: Value(sortOrder),
        createdAt: DateTime.now().toUtc(),
      ),
    );
  }

  Future<int> updateEnvelope({
    required String id,
    required String name,
    required EnvelopeCategory category,
    String? icon,
  }) {
    return _envelopeDao.updateEnvelopeDetails(
      id: id,
      name: name,
      category: category.value,
      icon: icon,
    );
  }

  Future<int> deleteEnvelope(String id) {
    return _envelopeDao.archiveEnvelope(id);
  }

  static EnvelopeEntity _mapToEntity(EnvelopesTableData row) {
    return EnvelopeEntity(
      id: row.id,
      name: row.name,
      category: EnvelopeCategoryExtension.fromString(row.category),
      icon: row.icon,
      isSystem: row.isSystem,
      isArchived: row.isArchived,
      isPaused: row.isPaused,
      sortOrder: row.sortOrder,
      createdAt: row.createdAt,
    );
  }
}

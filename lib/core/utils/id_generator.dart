import 'package:uuid/uuid.dart';

/// Generator ID acak uuid v4 untuk primary key semua tabel.
class IdGenerator {
  IdGenerator._();

  static const _uuid = Uuid();

  /// Menghasilkan string UUID v4 baru
  static String nextId() {
    return _uuid.v4();
  }
}

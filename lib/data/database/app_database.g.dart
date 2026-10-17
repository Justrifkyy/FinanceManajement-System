// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $EnvelopesTableTable extends EnvelopesTable
    with TableInfo<$EnvelopesTableTable, EnvelopesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EnvelopesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isSystemMeta = const VerificationMeta(
    'isSystem',
  );
  @override
  late final GeneratedColumn<bool> isSystem = GeneratedColumn<bool>(
    'is_system',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_system" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isPausedMeta = const VerificationMeta(
    'isPaused',
  );
  @override
  late final GeneratedColumn<bool> isPaused = GeneratedColumn<bool>(
    'is_paused',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_paused" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    category,
    icon,
    isSystem,
    isArchived,
    isPaused,
    sortOrder,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'envelopes';
  @override
  VerificationContext validateIntegrity(
    Insertable<EnvelopesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    }
    if (data.containsKey('is_system')) {
      context.handle(
        _isSystemMeta,
        isSystem.isAcceptableOrUnknown(data['is_system']!, _isSystemMeta),
      );
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
      );
    }
    if (data.containsKey('is_paused')) {
      context.handle(
        _isPausedMeta,
        isPaused.isAcceptableOrUnknown(data['is_paused']!, _isPausedMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EnvelopesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EnvelopesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      ),
      isSystem: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_system'],
      )!,
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
      isPaused: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_paused'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $EnvelopesTableTable createAlias(String alias) {
    return $EnvelopesTableTable(attachedDatabase, alias);
  }
}

class EnvelopesTableData extends DataClass
    implements Insertable<EnvelopesTableData> {
  final String id;
  final String name;
  final String category;
  final String? icon;
  final bool isSystem;
  final bool isArchived;
  final bool isPaused;
  final int sortOrder;
  final DateTime createdAt;
  const EnvelopesTableData({
    required this.id,
    required this.name,
    required this.category,
    this.icon,
    required this.isSystem,
    required this.isArchived,
    required this.isPaused,
    required this.sortOrder,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['category'] = Variable<String>(category);
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<String>(icon);
    }
    map['is_system'] = Variable<bool>(isSystem);
    map['is_archived'] = Variable<bool>(isArchived);
    map['is_paused'] = Variable<bool>(isPaused);
    map['sort_order'] = Variable<int>(sortOrder);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  EnvelopesTableCompanion toCompanion(bool nullToAbsent) {
    return EnvelopesTableCompanion(
      id: Value(id),
      name: Value(name),
      category: Value(category),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
      isSystem: Value(isSystem),
      isArchived: Value(isArchived),
      isPaused: Value(isPaused),
      sortOrder: Value(sortOrder),
      createdAt: Value(createdAt),
    );
  }

  factory EnvelopesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EnvelopesTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      category: serializer.fromJson<String>(json['category']),
      icon: serializer.fromJson<String?>(json['icon']),
      isSystem: serializer.fromJson<bool>(json['isSystem']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      isPaused: serializer.fromJson<bool>(json['isPaused']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'category': serializer.toJson<String>(category),
      'icon': serializer.toJson<String?>(icon),
      'isSystem': serializer.toJson<bool>(isSystem),
      'isArchived': serializer.toJson<bool>(isArchived),
      'isPaused': serializer.toJson<bool>(isPaused),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  EnvelopesTableData copyWith({
    String? id,
    String? name,
    String? category,
    Value<String?> icon = const Value.absent(),
    bool? isSystem,
    bool? isArchived,
    bool? isPaused,
    int? sortOrder,
    DateTime? createdAt,
  }) => EnvelopesTableData(
    id: id ?? this.id,
    name: name ?? this.name,
    category: category ?? this.category,
    icon: icon.present ? icon.value : this.icon,
    isSystem: isSystem ?? this.isSystem,
    isArchived: isArchived ?? this.isArchived,
    isPaused: isPaused ?? this.isPaused,
    sortOrder: sortOrder ?? this.sortOrder,
    createdAt: createdAt ?? this.createdAt,
  );
  EnvelopesTableData copyWithCompanion(EnvelopesTableCompanion data) {
    return EnvelopesTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      category: data.category.present ? data.category.value : this.category,
      icon: data.icon.present ? data.icon.value : this.icon,
      isSystem: data.isSystem.present ? data.isSystem.value : this.isSystem,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
      isPaused: data.isPaused.present ? data.isPaused.value : this.isPaused,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EnvelopesTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('icon: $icon, ')
          ..write('isSystem: $isSystem, ')
          ..write('isArchived: $isArchived, ')
          ..write('isPaused: $isPaused, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    category,
    icon,
    isSystem,
    isArchived,
    isPaused,
    sortOrder,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EnvelopesTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.category == this.category &&
          other.icon == this.icon &&
          other.isSystem == this.isSystem &&
          other.isArchived == this.isArchived &&
          other.isPaused == this.isPaused &&
          other.sortOrder == this.sortOrder &&
          other.createdAt == this.createdAt);
}

class EnvelopesTableCompanion extends UpdateCompanion<EnvelopesTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> category;
  final Value<String?> icon;
  final Value<bool> isSystem;
  final Value<bool> isArchived;
  final Value<bool> isPaused;
  final Value<int> sortOrder;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const EnvelopesTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.category = const Value.absent(),
    this.icon = const Value.absent(),
    this.isSystem = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.isPaused = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EnvelopesTableCompanion.insert({
    required String id,
    required String name,
    required String category,
    this.icon = const Value.absent(),
    this.isSystem = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.isPaused = const Value.absent(),
    this.sortOrder = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       category = Value(category),
       createdAt = Value(createdAt);
  static Insertable<EnvelopesTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? category,
    Expression<String>? icon,
    Expression<bool>? isSystem,
    Expression<bool>? isArchived,
    Expression<bool>? isPaused,
    Expression<int>? sortOrder,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (category != null) 'category': category,
      if (icon != null) 'icon': icon,
      if (isSystem != null) 'is_system': isSystem,
      if (isArchived != null) 'is_archived': isArchived,
      if (isPaused != null) 'is_paused': isPaused,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EnvelopesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? category,
    Value<String?>? icon,
    Value<bool>? isSystem,
    Value<bool>? isArchived,
    Value<bool>? isPaused,
    Value<int>? sortOrder,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return EnvelopesTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      icon: icon ?? this.icon,
      isSystem: isSystem ?? this.isSystem,
      isArchived: isArchived ?? this.isArchived,
      isPaused: isPaused ?? this.isPaused,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (isSystem.present) {
      map['is_system'] = Variable<bool>(isSystem.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (isPaused.present) {
      map['is_paused'] = Variable<bool>(isPaused.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EnvelopesTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('icon: $icon, ')
          ..write('isSystem: $isSystem, ')
          ..write('isArchived: $isArchived, ')
          ..write('isPaused: $isPaused, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GoalsTableTable extends GoalsTable
    with TableInfo<$GoalsTableTable, GoalsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GoalsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetAmountMeta = const VerificationMeta(
    'targetAmount',
  );
  @override
  late final GeneratedColumn<int> targetAmount = GeneratedColumn<int>(
    'target_amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deadlineMeta = const VerificationMeta(
    'deadline',
  );
  @override
  late final GeneratedColumn<String> deadline = GeneratedColumn<String>(
    'deadline',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    type,
    targetAmount,
    deadline,
    status,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'goals';
  @override
  VerificationContext validateIntegrity(
    Insertable<GoalsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('target_amount')) {
      context.handle(
        _targetAmountMeta,
        targetAmount.isAcceptableOrUnknown(
          data['target_amount']!,
          _targetAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetAmountMeta);
    }
    if (data.containsKey('deadline')) {
      context.handle(
        _deadlineMeta,
        deadline.isAcceptableOrUnknown(data['deadline']!, _deadlineMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GoalsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GoalsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      targetAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_amount'],
      )!,
      deadline: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}deadline'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $GoalsTableTable createAlias(String alias) {
    return $GoalsTableTable(attachedDatabase, alias);
  }
}

class GoalsTableData extends DataClass implements Insertable<GoalsTableData> {
  final String id;
  final String name;
  final String type;
  final int targetAmount;
  final String? deadline;
  final String status;
  final DateTime createdAt;
  const GoalsTableData({
    required this.id,
    required this.name,
    required this.type,
    required this.targetAmount,
    this.deadline,
    required this.status,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    map['target_amount'] = Variable<int>(targetAmount);
    if (!nullToAbsent || deadline != null) {
      map['deadline'] = Variable<String>(deadline);
    }
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  GoalsTableCompanion toCompanion(bool nullToAbsent) {
    return GoalsTableCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      targetAmount: Value(targetAmount),
      deadline: deadline == null && nullToAbsent
          ? const Value.absent()
          : Value(deadline),
      status: Value(status),
      createdAt: Value(createdAt),
    );
  }

  factory GoalsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GoalsTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      targetAmount: serializer.fromJson<int>(json['targetAmount']),
      deadline: serializer.fromJson<String?>(json['deadline']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'targetAmount': serializer.toJson<int>(targetAmount),
      'deadline': serializer.toJson<String?>(deadline),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  GoalsTableData copyWith({
    String? id,
    String? name,
    String? type,
    int? targetAmount,
    Value<String?> deadline = const Value.absent(),
    String? status,
    DateTime? createdAt,
  }) => GoalsTableData(
    id: id ?? this.id,
    name: name ?? this.name,
    type: type ?? this.type,
    targetAmount: targetAmount ?? this.targetAmount,
    deadline: deadline.present ? deadline.value : this.deadline,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
  );
  GoalsTableData copyWithCompanion(GoalsTableCompanion data) {
    return GoalsTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      targetAmount: data.targetAmount.present
          ? data.targetAmount.value
          : this.targetAmount,
      deadline: data.deadline.present ? data.deadline.value : this.deadline,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GoalsTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('targetAmount: $targetAmount, ')
          ..write('deadline: $deadline, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, type, targetAmount, deadline, status, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GoalsTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.targetAmount == this.targetAmount &&
          other.deadline == this.deadline &&
          other.status == this.status &&
          other.createdAt == this.createdAt);
}

class GoalsTableCompanion extends UpdateCompanion<GoalsTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> type;
  final Value<int> targetAmount;
  final Value<String?> deadline;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const GoalsTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.targetAmount = const Value.absent(),
    this.deadline = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GoalsTableCompanion.insert({
    required String id,
    required String name,
    required String type,
    required int targetAmount,
    this.deadline = const Value.absent(),
    required String status,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       type = Value(type),
       targetAmount = Value(targetAmount),
       status = Value(status),
       createdAt = Value(createdAt);
  static Insertable<GoalsTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? type,
    Expression<int>? targetAmount,
    Expression<String>? deadline,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (targetAmount != null) 'target_amount': targetAmount,
      if (deadline != null) 'deadline': deadline,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GoalsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? type,
    Value<int>? targetAmount,
    Value<String?>? deadline,
    Value<String>? status,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return GoalsTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      targetAmount: targetAmount ?? this.targetAmount,
      deadline: deadline ?? this.deadline,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (targetAmount.present) {
      map['target_amount'] = Variable<int>(targetAmount.value);
    }
    if (deadline.present) {
      map['deadline'] = Variable<String>(deadline.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GoalsTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('targetAmount: $targetAmount, ')
          ..write('deadline: $deadline, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PendingIncomesTableTable extends PendingIncomesTable
    with TableInfo<$PendingIncomesTableTable, PendingIncomesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PendingIncomesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _clientMeta = const VerificationMeta('client');
  @override
  late final GeneratedColumn<String> client = GeneratedColumn<String>(
    'client',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _expectedDateMeta = const VerificationMeta(
    'expectedDate',
  );
  @override
  late final GeneratedColumn<String> expectedDate = GeneratedColumn<String>(
    'expected_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _receivedTransactionIdMeta =
      const VerificationMeta('receivedTransactionId');
  @override
  late final GeneratedColumn<String> receivedTransactionId =
      GeneratedColumn<String>(
        'received_transaction_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    amount,
    client,
    expectedDate,
    status,
    receivedTransactionId,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pending_incomes';
  @override
  VerificationContext validateIntegrity(
    Insertable<PendingIncomesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('client')) {
      context.handle(
        _clientMeta,
        client.isAcceptableOrUnknown(data['client']!, _clientMeta),
      );
    }
    if (data.containsKey('expected_date')) {
      context.handle(
        _expectedDateMeta,
        expectedDate.isAcceptableOrUnknown(
          data['expected_date']!,
          _expectedDateMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('received_transaction_id')) {
      context.handle(
        _receivedTransactionIdMeta,
        receivedTransactionId.isAcceptableOrUnknown(
          data['received_transaction_id']!,
          _receivedTransactionIdMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PendingIncomesTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PendingIncomesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      client: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client'],
      ),
      expectedDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}expected_date'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      receivedTransactionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}received_transaction_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $PendingIncomesTableTable createAlias(String alias) {
    return $PendingIncomesTableTable(attachedDatabase, alias);
  }
}

class PendingIncomesTableData extends DataClass
    implements Insertable<PendingIncomesTableData> {
  final String id;
  final int amount;
  final String? client;
  final String? expectedDate;
  final String status;
  final String? receivedTransactionId;
  final DateTime createdAt;
  const PendingIncomesTableData({
    required this.id,
    required this.amount,
    this.client,
    this.expectedDate,
    required this.status,
    this.receivedTransactionId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['amount'] = Variable<int>(amount);
    if (!nullToAbsent || client != null) {
      map['client'] = Variable<String>(client);
    }
    if (!nullToAbsent || expectedDate != null) {
      map['expected_date'] = Variable<String>(expectedDate);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || receivedTransactionId != null) {
      map['received_transaction_id'] = Variable<String>(receivedTransactionId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PendingIncomesTableCompanion toCompanion(bool nullToAbsent) {
    return PendingIncomesTableCompanion(
      id: Value(id),
      amount: Value(amount),
      client: client == null && nullToAbsent
          ? const Value.absent()
          : Value(client),
      expectedDate: expectedDate == null && nullToAbsent
          ? const Value.absent()
          : Value(expectedDate),
      status: Value(status),
      receivedTransactionId: receivedTransactionId == null && nullToAbsent
          ? const Value.absent()
          : Value(receivedTransactionId),
      createdAt: Value(createdAt),
    );
  }

  factory PendingIncomesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PendingIncomesTableData(
      id: serializer.fromJson<String>(json['id']),
      amount: serializer.fromJson<int>(json['amount']),
      client: serializer.fromJson<String?>(json['client']),
      expectedDate: serializer.fromJson<String?>(json['expectedDate']),
      status: serializer.fromJson<String>(json['status']),
      receivedTransactionId: serializer.fromJson<String?>(
        json['receivedTransactionId'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'amount': serializer.toJson<int>(amount),
      'client': serializer.toJson<String?>(client),
      'expectedDate': serializer.toJson<String?>(expectedDate),
      'status': serializer.toJson<String>(status),
      'receivedTransactionId': serializer.toJson<String?>(
        receivedTransactionId,
      ),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PendingIncomesTableData copyWith({
    String? id,
    int? amount,
    Value<String?> client = const Value.absent(),
    Value<String?> expectedDate = const Value.absent(),
    String? status,
    Value<String?> receivedTransactionId = const Value.absent(),
    DateTime? createdAt,
  }) => PendingIncomesTableData(
    id: id ?? this.id,
    amount: amount ?? this.amount,
    client: client.present ? client.value : this.client,
    expectedDate: expectedDate.present ? expectedDate.value : this.expectedDate,
    status: status ?? this.status,
    receivedTransactionId: receivedTransactionId.present
        ? receivedTransactionId.value
        : this.receivedTransactionId,
    createdAt: createdAt ?? this.createdAt,
  );
  PendingIncomesTableData copyWithCompanion(PendingIncomesTableCompanion data) {
    return PendingIncomesTableData(
      id: data.id.present ? data.id.value : this.id,
      amount: data.amount.present ? data.amount.value : this.amount,
      client: data.client.present ? data.client.value : this.client,
      expectedDate: data.expectedDate.present
          ? data.expectedDate.value
          : this.expectedDate,
      status: data.status.present ? data.status.value : this.status,
      receivedTransactionId: data.receivedTransactionId.present
          ? data.receivedTransactionId.value
          : this.receivedTransactionId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PendingIncomesTableData(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('client: $client, ')
          ..write('expectedDate: $expectedDate, ')
          ..write('status: $status, ')
          ..write('receivedTransactionId: $receivedTransactionId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    amount,
    client,
    expectedDate,
    status,
    receivedTransactionId,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PendingIncomesTableData &&
          other.id == this.id &&
          other.amount == this.amount &&
          other.client == this.client &&
          other.expectedDate == this.expectedDate &&
          other.status == this.status &&
          other.receivedTransactionId == this.receivedTransactionId &&
          other.createdAt == this.createdAt);
}

class PendingIncomesTableCompanion
    extends UpdateCompanion<PendingIncomesTableData> {
  final Value<String> id;
  final Value<int> amount;
  final Value<String?> client;
  final Value<String?> expectedDate;
  final Value<String> status;
  final Value<String?> receivedTransactionId;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const PendingIncomesTableCompanion({
    this.id = const Value.absent(),
    this.amount = const Value.absent(),
    this.client = const Value.absent(),
    this.expectedDate = const Value.absent(),
    this.status = const Value.absent(),
    this.receivedTransactionId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PendingIncomesTableCompanion.insert({
    required String id,
    required int amount,
    this.client = const Value.absent(),
    this.expectedDate = const Value.absent(),
    required String status,
    this.receivedTransactionId = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       amount = Value(amount),
       status = Value(status),
       createdAt = Value(createdAt);
  static Insertable<PendingIncomesTableData> custom({
    Expression<String>? id,
    Expression<int>? amount,
    Expression<String>? client,
    Expression<String>? expectedDate,
    Expression<String>? status,
    Expression<String>? receivedTransactionId,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (amount != null) 'amount': amount,
      if (client != null) 'client': client,
      if (expectedDate != null) 'expected_date': expectedDate,
      if (status != null) 'status': status,
      if (receivedTransactionId != null)
        'received_transaction_id': receivedTransactionId,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PendingIncomesTableCompanion copyWith({
    Value<String>? id,
    Value<int>? amount,
    Value<String?>? client,
    Value<String?>? expectedDate,
    Value<String>? status,
    Value<String?>? receivedTransactionId,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return PendingIncomesTableCompanion(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      client: client ?? this.client,
      expectedDate: expectedDate ?? this.expectedDate,
      status: status ?? this.status,
      receivedTransactionId:
          receivedTransactionId ?? this.receivedTransactionId,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (client.present) {
      map['client'] = Variable<String>(client.value);
    }
    if (expectedDate.present) {
      map['expected_date'] = Variable<String>(expectedDate.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (receivedTransactionId.present) {
      map['received_transaction_id'] = Variable<String>(
        receivedTransactionId.value,
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PendingIncomesTableCompanion(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('client: $client, ')
          ..write('expectedDate: $expectedDate, ')
          ..write('status: $status, ')
          ..write('receivedTransactionId: $receivedTransactionId, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BufferEntriesTableTable extends BufferEntriesTable
    with TableInfo<$BufferEntriesTableTable, BufferEntriesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BufferEntriesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _releaseMonthMeta = const VerificationMeta(
    'releaseMonth',
  );
  @override
  late final GeneratedColumn<String> releaseMonth = GeneratedColumn<String>(
    'release_month',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('held'),
  );
  static const VerificationMeta _holdTransactionIdMeta = const VerificationMeta(
    'holdTransactionId',
  );
  @override
  late final GeneratedColumn<String> holdTransactionId =
      GeneratedColumn<String>(
        'hold_transaction_id',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _releaseTransactionIdMeta =
      const VerificationMeta('releaseTransactionId');
  @override
  late final GeneratedColumn<String> releaseTransactionId =
      GeneratedColumn<String>(
        'release_transaction_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    amount,
    releaseMonth,
    status,
    holdTransactionId,
    releaseTransactionId,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'buffer_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<BufferEntriesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('release_month')) {
      context.handle(
        _releaseMonthMeta,
        releaseMonth.isAcceptableOrUnknown(
          data['release_month']!,
          _releaseMonthMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_releaseMonthMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('hold_transaction_id')) {
      context.handle(
        _holdTransactionIdMeta,
        holdTransactionId.isAcceptableOrUnknown(
          data['hold_transaction_id']!,
          _holdTransactionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_holdTransactionIdMeta);
    }
    if (data.containsKey('release_transaction_id')) {
      context.handle(
        _releaseTransactionIdMeta,
        releaseTransactionId.isAcceptableOrUnknown(
          data['release_transaction_id']!,
          _releaseTransactionIdMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BufferEntriesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BufferEntriesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      releaseMonth: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}release_month'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      holdTransactionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hold_transaction_id'],
      )!,
      releaseTransactionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}release_transaction_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $BufferEntriesTableTable createAlias(String alias) {
    return $BufferEntriesTableTable(attachedDatabase, alias);
  }
}

class BufferEntriesTableData extends DataClass
    implements Insertable<BufferEntriesTableData> {
  final String id;
  final int amount;
  final String releaseMonth;
  final String status;
  final String holdTransactionId;
  final String? releaseTransactionId;
  final DateTime createdAt;
  const BufferEntriesTableData({
    required this.id,
    required this.amount,
    required this.releaseMonth,
    required this.status,
    required this.holdTransactionId,
    this.releaseTransactionId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['amount'] = Variable<int>(amount);
    map['release_month'] = Variable<String>(releaseMonth);
    map['status'] = Variable<String>(status);
    map['hold_transaction_id'] = Variable<String>(holdTransactionId);
    if (!nullToAbsent || releaseTransactionId != null) {
      map['release_transaction_id'] = Variable<String>(releaseTransactionId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  BufferEntriesTableCompanion toCompanion(bool nullToAbsent) {
    return BufferEntriesTableCompanion(
      id: Value(id),
      amount: Value(amount),
      releaseMonth: Value(releaseMonth),
      status: Value(status),
      holdTransactionId: Value(holdTransactionId),
      releaseTransactionId: releaseTransactionId == null && nullToAbsent
          ? const Value.absent()
          : Value(releaseTransactionId),
      createdAt: Value(createdAt),
    );
  }

  factory BufferEntriesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BufferEntriesTableData(
      id: serializer.fromJson<String>(json['id']),
      amount: serializer.fromJson<int>(json['amount']),
      releaseMonth: serializer.fromJson<String>(json['releaseMonth']),
      status: serializer.fromJson<String>(json['status']),
      holdTransactionId: serializer.fromJson<String>(json['holdTransactionId']),
      releaseTransactionId: serializer.fromJson<String?>(
        json['releaseTransactionId'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'amount': serializer.toJson<int>(amount),
      'releaseMonth': serializer.toJson<String>(releaseMonth),
      'status': serializer.toJson<String>(status),
      'holdTransactionId': serializer.toJson<String>(holdTransactionId),
      'releaseTransactionId': serializer.toJson<String?>(releaseTransactionId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  BufferEntriesTableData copyWith({
    String? id,
    int? amount,
    String? releaseMonth,
    String? status,
    String? holdTransactionId,
    Value<String?> releaseTransactionId = const Value.absent(),
    DateTime? createdAt,
  }) => BufferEntriesTableData(
    id: id ?? this.id,
    amount: amount ?? this.amount,
    releaseMonth: releaseMonth ?? this.releaseMonth,
    status: status ?? this.status,
    holdTransactionId: holdTransactionId ?? this.holdTransactionId,
    releaseTransactionId: releaseTransactionId.present
        ? releaseTransactionId.value
        : this.releaseTransactionId,
    createdAt: createdAt ?? this.createdAt,
  );
  BufferEntriesTableData copyWithCompanion(BufferEntriesTableCompanion data) {
    return BufferEntriesTableData(
      id: data.id.present ? data.id.value : this.id,
      amount: data.amount.present ? data.amount.value : this.amount,
      releaseMonth: data.releaseMonth.present
          ? data.releaseMonth.value
          : this.releaseMonth,
      status: data.status.present ? data.status.value : this.status,
      holdTransactionId: data.holdTransactionId.present
          ? data.holdTransactionId.value
          : this.holdTransactionId,
      releaseTransactionId: data.releaseTransactionId.present
          ? data.releaseTransactionId.value
          : this.releaseTransactionId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BufferEntriesTableData(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('releaseMonth: $releaseMonth, ')
          ..write('status: $status, ')
          ..write('holdTransactionId: $holdTransactionId, ')
          ..write('releaseTransactionId: $releaseTransactionId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    amount,
    releaseMonth,
    status,
    holdTransactionId,
    releaseTransactionId,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BufferEntriesTableData &&
          other.id == this.id &&
          other.amount == this.amount &&
          other.releaseMonth == this.releaseMonth &&
          other.status == this.status &&
          other.holdTransactionId == this.holdTransactionId &&
          other.releaseTransactionId == this.releaseTransactionId &&
          other.createdAt == this.createdAt);
}

class BufferEntriesTableCompanion
    extends UpdateCompanion<BufferEntriesTableData> {
  final Value<String> id;
  final Value<int> amount;
  final Value<String> releaseMonth;
  final Value<String> status;
  final Value<String> holdTransactionId;
  final Value<String?> releaseTransactionId;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const BufferEntriesTableCompanion({
    this.id = const Value.absent(),
    this.amount = const Value.absent(),
    this.releaseMonth = const Value.absent(),
    this.status = const Value.absent(),
    this.holdTransactionId = const Value.absent(),
    this.releaseTransactionId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BufferEntriesTableCompanion.insert({
    required String id,
    required int amount,
    required String releaseMonth,
    this.status = const Value.absent(),
    required String holdTransactionId,
    this.releaseTransactionId = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       amount = Value(amount),
       releaseMonth = Value(releaseMonth),
       holdTransactionId = Value(holdTransactionId),
       createdAt = Value(createdAt);
  static Insertable<BufferEntriesTableData> custom({
    Expression<String>? id,
    Expression<int>? amount,
    Expression<String>? releaseMonth,
    Expression<String>? status,
    Expression<String>? holdTransactionId,
    Expression<String>? releaseTransactionId,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (amount != null) 'amount': amount,
      if (releaseMonth != null) 'release_month': releaseMonth,
      if (status != null) 'status': status,
      if (holdTransactionId != null) 'hold_transaction_id': holdTransactionId,
      if (releaseTransactionId != null)
        'release_transaction_id': releaseTransactionId,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BufferEntriesTableCompanion copyWith({
    Value<String>? id,
    Value<int>? amount,
    Value<String>? releaseMonth,
    Value<String>? status,
    Value<String>? holdTransactionId,
    Value<String?>? releaseTransactionId,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return BufferEntriesTableCompanion(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      releaseMonth: releaseMonth ?? this.releaseMonth,
      status: status ?? this.status,
      holdTransactionId: holdTransactionId ?? this.holdTransactionId,
      releaseTransactionId: releaseTransactionId ?? this.releaseTransactionId,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (releaseMonth.present) {
      map['release_month'] = Variable<String>(releaseMonth.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (holdTransactionId.present) {
      map['hold_transaction_id'] = Variable<String>(holdTransactionId.value);
    }
    if (releaseTransactionId.present) {
      map['release_transaction_id'] = Variable<String>(
        releaseTransactionId.value,
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BufferEntriesTableCompanion(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('releaseMonth: $releaseMonth, ')
          ..write('status: $status, ')
          ..write('holdTransactionId: $holdTransactionId, ')
          ..write('releaseTransactionId: $releaseTransactionId, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TransactionsTableTable extends TransactionsTable
    with TableInfo<$TransactionsTableTable, TransactionsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (amount > 0)',
  );
  static const VerificationMeta _occurredAtMeta = const VerificationMeta(
    'occurredAt',
  );
  @override
  late final GeneratedColumn<DateTime> occurredAt = GeneratedColumn<DateTime>(
    'occurred_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localDateMeta = const VerificationMeta(
    'localDate',
  );
  @override
  late final GeneratedColumn<String> localDate = GeneratedColumn<String>(
    'local_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fromEnvelopeIdMeta = const VerificationMeta(
    'fromEnvelopeId',
  );
  @override
  late final GeneratedColumn<String> fromEnvelopeId = GeneratedColumn<String>(
    'from_envelope_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES envelopes (id)',
    ),
  );
  static const VerificationMeta _toEnvelopeIdMeta = const VerificationMeta(
    'toEnvelopeId',
  );
  @override
  late final GeneratedColumn<String> toEnvelopeId = GeneratedColumn<String>(
    'to_envelope_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES envelopes (id)',
    ),
  );
  static const VerificationMeta _goalIdMeta = const VerificationMeta('goalId');
  @override
  late final GeneratedColumn<String> goalId = GeneratedColumn<String>(
    'goal_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES goals (id)',
    ),
  );
  static const VerificationMeta _assetIdMeta = const VerificationMeta(
    'assetId',
  );
  @override
  late final GeneratedColumn<String> assetId = GeneratedColumn<String>(
    'asset_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _countsAsSpendingMeta = const VerificationMeta(
    'countsAsSpending',
  );
  @override
  late final GeneratedColumn<bool> countsAsSpending = GeneratedColumn<bool>(
    'counts_as_spending',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("counts_as_spending" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pendingIncomeIdMeta = const VerificationMeta(
    'pendingIncomeId',
  );
  @override
  late final GeneratedColumn<String> pendingIncomeId = GeneratedColumn<String>(
    'pending_income_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES pending_incomes (id)',
    ),
  );
  static const VerificationMeta _bufferEntryIdMeta = const VerificationMeta(
    'bufferEntryId',
  );
  @override
  late final GeneratedColumn<String> bufferEntryId = GeneratedColumn<String>(
    'buffer_entry_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES buffer_entries (id)',
    ),
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    type,
    amount,
    occurredAt,
    localDate,
    fromEnvelopeId,
    toEnvelopeId,
    goalId,
    assetId,
    countsAsSpending,
    note,
    source,
    pendingIncomeId,
    bufferEntryId,
    deletedAt,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<TransactionsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('occurred_at')) {
      context.handle(
        _occurredAtMeta,
        occurredAt.isAcceptableOrUnknown(data['occurred_at']!, _occurredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_occurredAtMeta);
    }
    if (data.containsKey('local_date')) {
      context.handle(
        _localDateMeta,
        localDate.isAcceptableOrUnknown(data['local_date']!, _localDateMeta),
      );
    } else if (isInserting) {
      context.missing(_localDateMeta);
    }
    if (data.containsKey('from_envelope_id')) {
      context.handle(
        _fromEnvelopeIdMeta,
        fromEnvelopeId.isAcceptableOrUnknown(
          data['from_envelope_id']!,
          _fromEnvelopeIdMeta,
        ),
      );
    }
    if (data.containsKey('to_envelope_id')) {
      context.handle(
        _toEnvelopeIdMeta,
        toEnvelopeId.isAcceptableOrUnknown(
          data['to_envelope_id']!,
          _toEnvelopeIdMeta,
        ),
      );
    }
    if (data.containsKey('goal_id')) {
      context.handle(
        _goalIdMeta,
        goalId.isAcceptableOrUnknown(data['goal_id']!, _goalIdMeta),
      );
    }
    if (data.containsKey('asset_id')) {
      context.handle(
        _assetIdMeta,
        assetId.isAcceptableOrUnknown(data['asset_id']!, _assetIdMeta),
      );
    }
    if (data.containsKey('counts_as_spending')) {
      context.handle(
        _countsAsSpendingMeta,
        countsAsSpending.isAcceptableOrUnknown(
          data['counts_as_spending']!,
          _countsAsSpendingMeta,
        ),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('pending_income_id')) {
      context.handle(
        _pendingIncomeIdMeta,
        pendingIncomeId.isAcceptableOrUnknown(
          data['pending_income_id']!,
          _pendingIncomeIdMeta,
        ),
      );
    }
    if (data.containsKey('buffer_entry_id')) {
      context.handle(
        _bufferEntryIdMeta,
        bufferEntryId.isAcceptableOrUnknown(
          data['buffer_entry_id']!,
          _bufferEntryIdMeta,
        ),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TransactionsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransactionsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      occurredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}occurred_at'],
      )!,
      localDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_date'],
      )!,
      fromEnvelopeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}from_envelope_id'],
      ),
      toEnvelopeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}to_envelope_id'],
      ),
      goalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}goal_id'],
      ),
      assetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}asset_id'],
      ),
      countsAsSpending: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}counts_as_spending'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      ),
      pendingIncomeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pending_income_id'],
      ),
      bufferEntryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}buffer_entry_id'],
      ),
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $TransactionsTableTable createAlias(String alias) {
    return $TransactionsTableTable(attachedDatabase, alias);
  }
}

class TransactionsTableData extends DataClass
    implements Insertable<TransactionsTableData> {
  final String id;
  final String type;
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
  const TransactionsTableData({
    required this.id,
    required this.type,
    required this.amount,
    required this.occurredAt,
    required this.localDate,
    this.fromEnvelopeId,
    this.toEnvelopeId,
    this.goalId,
    this.assetId,
    required this.countsAsSpending,
    this.note,
    this.source,
    this.pendingIncomeId,
    this.bufferEntryId,
    this.deletedAt,
    required this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['type'] = Variable<String>(type);
    map['amount'] = Variable<int>(amount);
    map['occurred_at'] = Variable<DateTime>(occurredAt);
    map['local_date'] = Variable<String>(localDate);
    if (!nullToAbsent || fromEnvelopeId != null) {
      map['from_envelope_id'] = Variable<String>(fromEnvelopeId);
    }
    if (!nullToAbsent || toEnvelopeId != null) {
      map['to_envelope_id'] = Variable<String>(toEnvelopeId);
    }
    if (!nullToAbsent || goalId != null) {
      map['goal_id'] = Variable<String>(goalId);
    }
    if (!nullToAbsent || assetId != null) {
      map['asset_id'] = Variable<String>(assetId);
    }
    map['counts_as_spending'] = Variable<bool>(countsAsSpending);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || source != null) {
      map['source'] = Variable<String>(source);
    }
    if (!nullToAbsent || pendingIncomeId != null) {
      map['pending_income_id'] = Variable<String>(pendingIncomeId);
    }
    if (!nullToAbsent || bufferEntryId != null) {
      map['buffer_entry_id'] = Variable<String>(bufferEntryId);
    }
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  TransactionsTableCompanion toCompanion(bool nullToAbsent) {
    return TransactionsTableCompanion(
      id: Value(id),
      type: Value(type),
      amount: Value(amount),
      occurredAt: Value(occurredAt),
      localDate: Value(localDate),
      fromEnvelopeId: fromEnvelopeId == null && nullToAbsent
          ? const Value.absent()
          : Value(fromEnvelopeId),
      toEnvelopeId: toEnvelopeId == null && nullToAbsent
          ? const Value.absent()
          : Value(toEnvelopeId),
      goalId: goalId == null && nullToAbsent
          ? const Value.absent()
          : Value(goalId),
      assetId: assetId == null && nullToAbsent
          ? const Value.absent()
          : Value(assetId),
      countsAsSpending: Value(countsAsSpending),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      source: source == null && nullToAbsent
          ? const Value.absent()
          : Value(source),
      pendingIncomeId: pendingIncomeId == null && nullToAbsent
          ? const Value.absent()
          : Value(pendingIncomeId),
      bufferEntryId: bufferEntryId == null && nullToAbsent
          ? const Value.absent()
          : Value(bufferEntryId),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory TransactionsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransactionsTableData(
      id: serializer.fromJson<String>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      amount: serializer.fromJson<int>(json['amount']),
      occurredAt: serializer.fromJson<DateTime>(json['occurredAt']),
      localDate: serializer.fromJson<String>(json['localDate']),
      fromEnvelopeId: serializer.fromJson<String?>(json['fromEnvelopeId']),
      toEnvelopeId: serializer.fromJson<String?>(json['toEnvelopeId']),
      goalId: serializer.fromJson<String?>(json['goalId']),
      assetId: serializer.fromJson<String?>(json['assetId']),
      countsAsSpending: serializer.fromJson<bool>(json['countsAsSpending']),
      note: serializer.fromJson<String?>(json['note']),
      source: serializer.fromJson<String?>(json['source']),
      pendingIncomeId: serializer.fromJson<String?>(json['pendingIncomeId']),
      bufferEntryId: serializer.fromJson<String?>(json['bufferEntryId']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'type': serializer.toJson<String>(type),
      'amount': serializer.toJson<int>(amount),
      'occurredAt': serializer.toJson<DateTime>(occurredAt),
      'localDate': serializer.toJson<String>(localDate),
      'fromEnvelopeId': serializer.toJson<String?>(fromEnvelopeId),
      'toEnvelopeId': serializer.toJson<String?>(toEnvelopeId),
      'goalId': serializer.toJson<String?>(goalId),
      'assetId': serializer.toJson<String?>(assetId),
      'countsAsSpending': serializer.toJson<bool>(countsAsSpending),
      'note': serializer.toJson<String?>(note),
      'source': serializer.toJson<String?>(source),
      'pendingIncomeId': serializer.toJson<String?>(pendingIncomeId),
      'bufferEntryId': serializer.toJson<String?>(bufferEntryId),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  TransactionsTableData copyWith({
    String? id,
    String? type,
    int? amount,
    DateTime? occurredAt,
    String? localDate,
    Value<String?> fromEnvelopeId = const Value.absent(),
    Value<String?> toEnvelopeId = const Value.absent(),
    Value<String?> goalId = const Value.absent(),
    Value<String?> assetId = const Value.absent(),
    bool? countsAsSpending,
    Value<String?> note = const Value.absent(),
    Value<String?> source = const Value.absent(),
    Value<String?> pendingIncomeId = const Value.absent(),
    Value<String?> bufferEntryId = const Value.absent(),
    Value<DateTime?> deletedAt = const Value.absent(),
    DateTime? createdAt,
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => TransactionsTableData(
    id: id ?? this.id,
    type: type ?? this.type,
    amount: amount ?? this.amount,
    occurredAt: occurredAt ?? this.occurredAt,
    localDate: localDate ?? this.localDate,
    fromEnvelopeId: fromEnvelopeId.present
        ? fromEnvelopeId.value
        : this.fromEnvelopeId,
    toEnvelopeId: toEnvelopeId.present ? toEnvelopeId.value : this.toEnvelopeId,
    goalId: goalId.present ? goalId.value : this.goalId,
    assetId: assetId.present ? assetId.value : this.assetId,
    countsAsSpending: countsAsSpending ?? this.countsAsSpending,
    note: note.present ? note.value : this.note,
    source: source.present ? source.value : this.source,
    pendingIncomeId: pendingIncomeId.present
        ? pendingIncomeId.value
        : this.pendingIncomeId,
    bufferEntryId: bufferEntryId.present
        ? bufferEntryId.value
        : this.bufferEntryId,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  TransactionsTableData copyWithCompanion(TransactionsTableCompanion data) {
    return TransactionsTableData(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      amount: data.amount.present ? data.amount.value : this.amount,
      occurredAt: data.occurredAt.present
          ? data.occurredAt.value
          : this.occurredAt,
      localDate: data.localDate.present ? data.localDate.value : this.localDate,
      fromEnvelopeId: data.fromEnvelopeId.present
          ? data.fromEnvelopeId.value
          : this.fromEnvelopeId,
      toEnvelopeId: data.toEnvelopeId.present
          ? data.toEnvelopeId.value
          : this.toEnvelopeId,
      goalId: data.goalId.present ? data.goalId.value : this.goalId,
      assetId: data.assetId.present ? data.assetId.value : this.assetId,
      countsAsSpending: data.countsAsSpending.present
          ? data.countsAsSpending.value
          : this.countsAsSpending,
      note: data.note.present ? data.note.value : this.note,
      source: data.source.present ? data.source.value : this.source,
      pendingIncomeId: data.pendingIncomeId.present
          ? data.pendingIncomeId.value
          : this.pendingIncomeId,
      bufferEntryId: data.bufferEntryId.present
          ? data.bufferEntryId.value
          : this.bufferEntryId,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsTableData(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('amount: $amount, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('localDate: $localDate, ')
          ..write('fromEnvelopeId: $fromEnvelopeId, ')
          ..write('toEnvelopeId: $toEnvelopeId, ')
          ..write('goalId: $goalId, ')
          ..write('assetId: $assetId, ')
          ..write('countsAsSpending: $countsAsSpending, ')
          ..write('note: $note, ')
          ..write('source: $source, ')
          ..write('pendingIncomeId: $pendingIncomeId, ')
          ..write('bufferEntryId: $bufferEntryId, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    type,
    amount,
    occurredAt,
    localDate,
    fromEnvelopeId,
    toEnvelopeId,
    goalId,
    assetId,
    countsAsSpending,
    note,
    source,
    pendingIncomeId,
    bufferEntryId,
    deletedAt,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransactionsTableData &&
          other.id == this.id &&
          other.type == this.type &&
          other.amount == this.amount &&
          other.occurredAt == this.occurredAt &&
          other.localDate == this.localDate &&
          other.fromEnvelopeId == this.fromEnvelopeId &&
          other.toEnvelopeId == this.toEnvelopeId &&
          other.goalId == this.goalId &&
          other.assetId == this.assetId &&
          other.countsAsSpending == this.countsAsSpending &&
          other.note == this.note &&
          other.source == this.source &&
          other.pendingIncomeId == this.pendingIncomeId &&
          other.bufferEntryId == this.bufferEntryId &&
          other.deletedAt == this.deletedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TransactionsTableCompanion
    extends UpdateCompanion<TransactionsTableData> {
  final Value<String> id;
  final Value<String> type;
  final Value<int> amount;
  final Value<DateTime> occurredAt;
  final Value<String> localDate;
  final Value<String?> fromEnvelopeId;
  final Value<String?> toEnvelopeId;
  final Value<String?> goalId;
  final Value<String?> assetId;
  final Value<bool> countsAsSpending;
  final Value<String?> note;
  final Value<String?> source;
  final Value<String?> pendingIncomeId;
  final Value<String?> bufferEntryId;
  final Value<DateTime?> deletedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const TransactionsTableCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.amount = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.localDate = const Value.absent(),
    this.fromEnvelopeId = const Value.absent(),
    this.toEnvelopeId = const Value.absent(),
    this.goalId = const Value.absent(),
    this.assetId = const Value.absent(),
    this.countsAsSpending = const Value.absent(),
    this.note = const Value.absent(),
    this.source = const Value.absent(),
    this.pendingIncomeId = const Value.absent(),
    this.bufferEntryId = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TransactionsTableCompanion.insert({
    required String id,
    required String type,
    required int amount,
    required DateTime occurredAt,
    required String localDate,
    this.fromEnvelopeId = const Value.absent(),
    this.toEnvelopeId = const Value.absent(),
    this.goalId = const Value.absent(),
    this.assetId = const Value.absent(),
    this.countsAsSpending = const Value.absent(),
    this.note = const Value.absent(),
    this.source = const Value.absent(),
    this.pendingIncomeId = const Value.absent(),
    this.bufferEntryId = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required DateTime createdAt,
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       type = Value(type),
       amount = Value(amount),
       occurredAt = Value(occurredAt),
       localDate = Value(localDate),
       createdAt = Value(createdAt);
  static Insertable<TransactionsTableData> custom({
    Expression<String>? id,
    Expression<String>? type,
    Expression<int>? amount,
    Expression<DateTime>? occurredAt,
    Expression<String>? localDate,
    Expression<String>? fromEnvelopeId,
    Expression<String>? toEnvelopeId,
    Expression<String>? goalId,
    Expression<String>? assetId,
    Expression<bool>? countsAsSpending,
    Expression<String>? note,
    Expression<String>? source,
    Expression<String>? pendingIncomeId,
    Expression<String>? bufferEntryId,
    Expression<DateTime>? deletedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (amount != null) 'amount': amount,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (localDate != null) 'local_date': localDate,
      if (fromEnvelopeId != null) 'from_envelope_id': fromEnvelopeId,
      if (toEnvelopeId != null) 'to_envelope_id': toEnvelopeId,
      if (goalId != null) 'goal_id': goalId,
      if (assetId != null) 'asset_id': assetId,
      if (countsAsSpending != null) 'counts_as_spending': countsAsSpending,
      if (note != null) 'note': note,
      if (source != null) 'source': source,
      if (pendingIncomeId != null) 'pending_income_id': pendingIncomeId,
      if (bufferEntryId != null) 'buffer_entry_id': bufferEntryId,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TransactionsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? type,
    Value<int>? amount,
    Value<DateTime>? occurredAt,
    Value<String>? localDate,
    Value<String?>? fromEnvelopeId,
    Value<String?>? toEnvelopeId,
    Value<String?>? goalId,
    Value<String?>? assetId,
    Value<bool>? countsAsSpending,
    Value<String?>? note,
    Value<String?>? source,
    Value<String?>? pendingIncomeId,
    Value<String?>? bufferEntryId,
    Value<DateTime?>? deletedAt,
    Value<DateTime>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<int>? rowid,
  }) {
    return TransactionsTableCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      occurredAt: occurredAt ?? this.occurredAt,
      localDate: localDate ?? this.localDate,
      fromEnvelopeId: fromEnvelopeId ?? this.fromEnvelopeId,
      toEnvelopeId: toEnvelopeId ?? this.toEnvelopeId,
      goalId: goalId ?? this.goalId,
      assetId: assetId ?? this.assetId,
      countsAsSpending: countsAsSpending ?? this.countsAsSpending,
      note: note ?? this.note,
      source: source ?? this.source,
      pendingIncomeId: pendingIncomeId ?? this.pendingIncomeId,
      bufferEntryId: bufferEntryId ?? this.bufferEntryId,
      deletedAt: deletedAt ?? this.deletedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<DateTime>(occurredAt.value);
    }
    if (localDate.present) {
      map['local_date'] = Variable<String>(localDate.value);
    }
    if (fromEnvelopeId.present) {
      map['from_envelope_id'] = Variable<String>(fromEnvelopeId.value);
    }
    if (toEnvelopeId.present) {
      map['to_envelope_id'] = Variable<String>(toEnvelopeId.value);
    }
    if (goalId.present) {
      map['goal_id'] = Variable<String>(goalId.value);
    }
    if (assetId.present) {
      map['asset_id'] = Variable<String>(assetId.value);
    }
    if (countsAsSpending.present) {
      map['counts_as_spending'] = Variable<bool>(countsAsSpending.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (pendingIncomeId.present) {
      map['pending_income_id'] = Variable<String>(pendingIncomeId.value);
    }
    if (bufferEntryId.present) {
      map['buffer_entry_id'] = Variable<String>(bufferEntryId.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsTableCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('amount: $amount, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('localDate: $localDate, ')
          ..write('fromEnvelopeId: $fromEnvelopeId, ')
          ..write('toEnvelopeId: $toEnvelopeId, ')
          ..write('goalId: $goalId, ')
          ..write('assetId: $assetId, ')
          ..write('countsAsSpending: $countsAsSpending, ')
          ..write('note: $note, ')
          ..write('source: $source, ')
          ..write('pendingIncomeId: $pendingIncomeId, ')
          ..write('bufferEntryId: $bufferEntryId, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SubscriptionsTableTable extends SubscriptionsTable
    with TableInfo<$SubscriptionsTableTable, SubscriptionsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubscriptionsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cycleMeta = const VerificationMeta('cycle');
  @override
  late final GeneratedColumn<String> cycle = GeneratedColumn<String>(
    'cycle',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nextDueDateMeta = const VerificationMeta(
    'nextDueDate',
  );
  @override
  late final GeneratedColumn<String> nextDueDate = GeneratedColumn<String>(
    'next_due_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _envelopeIdMeta = const VerificationMeta(
    'envelopeId',
  );
  @override
  late final GeneratedColumn<String> envelopeId = GeneratedColumn<String>(
    'envelope_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES envelopes (id)',
    ),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _notificationSeqMeta = const VerificationMeta(
    'notificationSeq',
  );
  @override
  late final GeneratedColumn<int> notificationSeq = GeneratedColumn<int>(
    'notification_seq',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    amount,
    cycle,
    nextDueDate,
    envelopeId,
    isActive,
    notificationSeq,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'subscriptions';
  @override
  VerificationContext validateIntegrity(
    Insertable<SubscriptionsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('cycle')) {
      context.handle(
        _cycleMeta,
        cycle.isAcceptableOrUnknown(data['cycle']!, _cycleMeta),
      );
    } else if (isInserting) {
      context.missing(_cycleMeta);
    }
    if (data.containsKey('next_due_date')) {
      context.handle(
        _nextDueDateMeta,
        nextDueDate.isAcceptableOrUnknown(
          data['next_due_date']!,
          _nextDueDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nextDueDateMeta);
    }
    if (data.containsKey('envelope_id')) {
      context.handle(
        _envelopeIdMeta,
        envelopeId.isAcceptableOrUnknown(data['envelope_id']!, _envelopeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_envelopeIdMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('notification_seq')) {
      context.handle(
        _notificationSeqMeta,
        notificationSeq.isAcceptableOrUnknown(
          data['notification_seq']!,
          _notificationSeqMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_notificationSeqMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SubscriptionsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SubscriptionsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      cycle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cycle'],
      )!,
      nextDueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}next_due_date'],
      )!,
      envelopeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}envelope_id'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      notificationSeq: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}notification_seq'],
      )!,
    );
  }

  @override
  $SubscriptionsTableTable createAlias(String alias) {
    return $SubscriptionsTableTable(attachedDatabase, alias);
  }
}

class SubscriptionsTableData extends DataClass
    implements Insertable<SubscriptionsTableData> {
  final String id;
  final String name;
  final int amount;
  final String cycle;
  final String nextDueDate;
  final String envelopeId;
  final bool isActive;
  final int notificationSeq;
  const SubscriptionsTableData({
    required this.id,
    required this.name,
    required this.amount,
    required this.cycle,
    required this.nextDueDate,
    required this.envelopeId,
    required this.isActive,
    required this.notificationSeq,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['amount'] = Variable<int>(amount);
    map['cycle'] = Variable<String>(cycle);
    map['next_due_date'] = Variable<String>(nextDueDate);
    map['envelope_id'] = Variable<String>(envelopeId);
    map['is_active'] = Variable<bool>(isActive);
    map['notification_seq'] = Variable<int>(notificationSeq);
    return map;
  }

  SubscriptionsTableCompanion toCompanion(bool nullToAbsent) {
    return SubscriptionsTableCompanion(
      id: Value(id),
      name: Value(name),
      amount: Value(amount),
      cycle: Value(cycle),
      nextDueDate: Value(nextDueDate),
      envelopeId: Value(envelopeId),
      isActive: Value(isActive),
      notificationSeq: Value(notificationSeq),
    );
  }

  factory SubscriptionsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SubscriptionsTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      amount: serializer.fromJson<int>(json['amount']),
      cycle: serializer.fromJson<String>(json['cycle']),
      nextDueDate: serializer.fromJson<String>(json['nextDueDate']),
      envelopeId: serializer.fromJson<String>(json['envelopeId']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      notificationSeq: serializer.fromJson<int>(json['notificationSeq']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'amount': serializer.toJson<int>(amount),
      'cycle': serializer.toJson<String>(cycle),
      'nextDueDate': serializer.toJson<String>(nextDueDate),
      'envelopeId': serializer.toJson<String>(envelopeId),
      'isActive': serializer.toJson<bool>(isActive),
      'notificationSeq': serializer.toJson<int>(notificationSeq),
    };
  }

  SubscriptionsTableData copyWith({
    String? id,
    String? name,
    int? amount,
    String? cycle,
    String? nextDueDate,
    String? envelopeId,
    bool? isActive,
    int? notificationSeq,
  }) => SubscriptionsTableData(
    id: id ?? this.id,
    name: name ?? this.name,
    amount: amount ?? this.amount,
    cycle: cycle ?? this.cycle,
    nextDueDate: nextDueDate ?? this.nextDueDate,
    envelopeId: envelopeId ?? this.envelopeId,
    isActive: isActive ?? this.isActive,
    notificationSeq: notificationSeq ?? this.notificationSeq,
  );
  SubscriptionsTableData copyWithCompanion(SubscriptionsTableCompanion data) {
    return SubscriptionsTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      amount: data.amount.present ? data.amount.value : this.amount,
      cycle: data.cycle.present ? data.cycle.value : this.cycle,
      nextDueDate: data.nextDueDate.present
          ? data.nextDueDate.value
          : this.nextDueDate,
      envelopeId: data.envelopeId.present
          ? data.envelopeId.value
          : this.envelopeId,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      notificationSeq: data.notificationSeq.present
          ? data.notificationSeq.value
          : this.notificationSeq,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SubscriptionsTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('amount: $amount, ')
          ..write('cycle: $cycle, ')
          ..write('nextDueDate: $nextDueDate, ')
          ..write('envelopeId: $envelopeId, ')
          ..write('isActive: $isActive, ')
          ..write('notificationSeq: $notificationSeq')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    amount,
    cycle,
    nextDueDate,
    envelopeId,
    isActive,
    notificationSeq,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SubscriptionsTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.amount == this.amount &&
          other.cycle == this.cycle &&
          other.nextDueDate == this.nextDueDate &&
          other.envelopeId == this.envelopeId &&
          other.isActive == this.isActive &&
          other.notificationSeq == this.notificationSeq);
}

class SubscriptionsTableCompanion
    extends UpdateCompanion<SubscriptionsTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> amount;
  final Value<String> cycle;
  final Value<String> nextDueDate;
  final Value<String> envelopeId;
  final Value<bool> isActive;
  final Value<int> notificationSeq;
  final Value<int> rowid;
  const SubscriptionsTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.amount = const Value.absent(),
    this.cycle = const Value.absent(),
    this.nextDueDate = const Value.absent(),
    this.envelopeId = const Value.absent(),
    this.isActive = const Value.absent(),
    this.notificationSeq = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SubscriptionsTableCompanion.insert({
    required String id,
    required String name,
    required int amount,
    required String cycle,
    required String nextDueDate,
    required String envelopeId,
    this.isActive = const Value.absent(),
    required int notificationSeq,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       amount = Value(amount),
       cycle = Value(cycle),
       nextDueDate = Value(nextDueDate),
       envelopeId = Value(envelopeId),
       notificationSeq = Value(notificationSeq);
  static Insertable<SubscriptionsTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? amount,
    Expression<String>? cycle,
    Expression<String>? nextDueDate,
    Expression<String>? envelopeId,
    Expression<bool>? isActive,
    Expression<int>? notificationSeq,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (amount != null) 'amount': amount,
      if (cycle != null) 'cycle': cycle,
      if (nextDueDate != null) 'next_due_date': nextDueDate,
      if (envelopeId != null) 'envelope_id': envelopeId,
      if (isActive != null) 'is_active': isActive,
      if (notificationSeq != null) 'notification_seq': notificationSeq,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SubscriptionsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<int>? amount,
    Value<String>? cycle,
    Value<String>? nextDueDate,
    Value<String>? envelopeId,
    Value<bool>? isActive,
    Value<int>? notificationSeq,
    Value<int>? rowid,
  }) {
    return SubscriptionsTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      cycle: cycle ?? this.cycle,
      nextDueDate: nextDueDate ?? this.nextDueDate,
      envelopeId: envelopeId ?? this.envelopeId,
      isActive: isActive ?? this.isActive,
      notificationSeq: notificationSeq ?? this.notificationSeq,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (cycle.present) {
      map['cycle'] = Variable<String>(cycle.value);
    }
    if (nextDueDate.present) {
      map['next_due_date'] = Variable<String>(nextDueDate.value);
    }
    if (envelopeId.present) {
      map['envelope_id'] = Variable<String>(envelopeId.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (notificationSeq.present) {
      map['notification_seq'] = Variable<int>(notificationSeq.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubscriptionsTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('amount: $amount, ')
          ..write('cycle: $cycle, ')
          ..write('nextDueDate: $nextDueDate, ')
          ..write('envelopeId: $envelopeId, ')
          ..write('isActive: $isActive, ')
          ..write('notificationSeq: $notificationSeq, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ResistedEventsTableTable extends ResistedEventsTable
    with TableInfo<$ResistedEventsTableTable, ResistedEventsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ResistedEventsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _occurredAtMeta = const VerificationMeta(
    'occurredAt',
  );
  @override
  late final GeneratedColumn<DateTime> occurredAt = GeneratedColumn<DateTime>(
    'occurred_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localDateMeta = const VerificationMeta(
    'localDate',
  );
  @override
  late final GeneratedColumn<String> localDate = GeneratedColumn<String>(
    'local_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, amount, occurredAt, localDate];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'resisted_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<ResistedEventsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('occurred_at')) {
      context.handle(
        _occurredAtMeta,
        occurredAt.isAcceptableOrUnknown(data['occurred_at']!, _occurredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_occurredAtMeta);
    }
    if (data.containsKey('local_date')) {
      context.handle(
        _localDateMeta,
        localDate.isAcceptableOrUnknown(data['local_date']!, _localDateMeta),
      );
    } else if (isInserting) {
      context.missing(_localDateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ResistedEventsTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ResistedEventsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      occurredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}occurred_at'],
      )!,
      localDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_date'],
      )!,
    );
  }

  @override
  $ResistedEventsTableTable createAlias(String alias) {
    return $ResistedEventsTableTable(attachedDatabase, alias);
  }
}

class ResistedEventsTableData extends DataClass
    implements Insertable<ResistedEventsTableData> {
  final String id;
  final int amount;
  final DateTime occurredAt;
  final String localDate;
  const ResistedEventsTableData({
    required this.id,
    required this.amount,
    required this.occurredAt,
    required this.localDate,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['amount'] = Variable<int>(amount);
    map['occurred_at'] = Variable<DateTime>(occurredAt);
    map['local_date'] = Variable<String>(localDate);
    return map;
  }

  ResistedEventsTableCompanion toCompanion(bool nullToAbsent) {
    return ResistedEventsTableCompanion(
      id: Value(id),
      amount: Value(amount),
      occurredAt: Value(occurredAt),
      localDate: Value(localDate),
    );
  }

  factory ResistedEventsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ResistedEventsTableData(
      id: serializer.fromJson<String>(json['id']),
      amount: serializer.fromJson<int>(json['amount']),
      occurredAt: serializer.fromJson<DateTime>(json['occurredAt']),
      localDate: serializer.fromJson<String>(json['localDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'amount': serializer.toJson<int>(amount),
      'occurredAt': serializer.toJson<DateTime>(occurredAt),
      'localDate': serializer.toJson<String>(localDate),
    };
  }

  ResistedEventsTableData copyWith({
    String? id,
    int? amount,
    DateTime? occurredAt,
    String? localDate,
  }) => ResistedEventsTableData(
    id: id ?? this.id,
    amount: amount ?? this.amount,
    occurredAt: occurredAt ?? this.occurredAt,
    localDate: localDate ?? this.localDate,
  );
  ResistedEventsTableData copyWithCompanion(ResistedEventsTableCompanion data) {
    return ResistedEventsTableData(
      id: data.id.present ? data.id.value : this.id,
      amount: data.amount.present ? data.amount.value : this.amount,
      occurredAt: data.occurredAt.present
          ? data.occurredAt.value
          : this.occurredAt,
      localDate: data.localDate.present ? data.localDate.value : this.localDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ResistedEventsTableData(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('localDate: $localDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, amount, occurredAt, localDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ResistedEventsTableData &&
          other.id == this.id &&
          other.amount == this.amount &&
          other.occurredAt == this.occurredAt &&
          other.localDate == this.localDate);
}

class ResistedEventsTableCompanion
    extends UpdateCompanion<ResistedEventsTableData> {
  final Value<String> id;
  final Value<int> amount;
  final Value<DateTime> occurredAt;
  final Value<String> localDate;
  final Value<int> rowid;
  const ResistedEventsTableCompanion({
    this.id = const Value.absent(),
    this.amount = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.localDate = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ResistedEventsTableCompanion.insert({
    required String id,
    required int amount,
    required DateTime occurredAt,
    required String localDate,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       amount = Value(amount),
       occurredAt = Value(occurredAt),
       localDate = Value(localDate);
  static Insertable<ResistedEventsTableData> custom({
    Expression<String>? id,
    Expression<int>? amount,
    Expression<DateTime>? occurredAt,
    Expression<String>? localDate,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (amount != null) 'amount': amount,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (localDate != null) 'local_date': localDate,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ResistedEventsTableCompanion copyWith({
    Value<String>? id,
    Value<int>? amount,
    Value<DateTime>? occurredAt,
    Value<String>? localDate,
    Value<int>? rowid,
  }) {
    return ResistedEventsTableCompanion(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      occurredAt: occurredAt ?? this.occurredAt,
      localDate: localDate ?? this.localDate,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<DateTime>(occurredAt.value);
    }
    if (localDate.present) {
      map['local_date'] = Variable<String>(localDate.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ResistedEventsTableCompanion(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('localDate: $localDate, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTableTable extends AppSettingsTable
    with TableInfo<$AppSettingsTableTable, AppSettingsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSettingsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppSettingsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSettingsTableData(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $AppSettingsTableTable createAlias(String alias) {
    return $AppSettingsTableTable(attachedDatabase, alias);
  }
}

class AppSettingsTableData extends DataClass
    implements Insertable<AppSettingsTableData> {
  final String key;
  final String value;
  const AppSettingsTableData({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  AppSettingsTableCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsTableCompanion(key: Value(key), value: Value(value));
  }

  factory AppSettingsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSettingsTableData(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  AppSettingsTableData copyWith({String? key, String? value}) =>
      AppSettingsTableData(key: key ?? this.key, value: value ?? this.value);
  AppSettingsTableData copyWithCompanion(AppSettingsTableCompanion data) {
    return AppSettingsTableData(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsTableData(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSettingsTableData &&
          other.key == this.key &&
          other.value == this.value);
}

class AppSettingsTableCompanion extends UpdateCompanion<AppSettingsTableData> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const AppSettingsTableCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsTableCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<AppSettingsTableData> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsTableCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return AppSettingsTableCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsTableCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $EnvelopesTableTable envelopesTable = $EnvelopesTableTable(this);
  late final $GoalsTableTable goalsTable = $GoalsTableTable(this);
  late final $PendingIncomesTableTable pendingIncomesTable =
      $PendingIncomesTableTable(this);
  late final $BufferEntriesTableTable bufferEntriesTable =
      $BufferEntriesTableTable(this);
  late final $TransactionsTableTable transactionsTable =
      $TransactionsTableTable(this);
  late final $SubscriptionsTableTable subscriptionsTable =
      $SubscriptionsTableTable(this);
  late final $ResistedEventsTableTable resistedEventsTable =
      $ResistedEventsTableTable(this);
  late final $AppSettingsTableTable appSettingsTable = $AppSettingsTableTable(
    this,
  );
  late final EnvelopeDao envelopeDao = EnvelopeDao(this as AppDatabase);
  late final TransactionDao transactionDao = TransactionDao(
    this as AppDatabase,
  );
  late final BufferDao bufferDao = BufferDao(this as AppDatabase);
  late final SubscriptionDao subscriptionDao = SubscriptionDao(
    this as AppDatabase,
  );
  late final GoalDao goalDao = GoalDao(this as AppDatabase);
  late final SettingsDao settingsDao = SettingsDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    envelopesTable,
    goalsTable,
    pendingIncomesTable,
    bufferEntriesTable,
    transactionsTable,
    subscriptionsTable,
    resistedEventsTable,
    appSettingsTable,
  ];
}

typedef $$EnvelopesTableTableCreateCompanionBuilder =
    EnvelopesTableCompanion Function({
      required String id,
      required String name,
      required String category,
      Value<String?> icon,
      Value<bool> isSystem,
      Value<bool> isArchived,
      Value<bool> isPaused,
      Value<int> sortOrder,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$EnvelopesTableTableUpdateCompanionBuilder =
    EnvelopesTableCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> category,
      Value<String?> icon,
      Value<bool> isSystem,
      Value<bool> isArchived,
      Value<bool> isPaused,
      Value<int> sortOrder,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$EnvelopesTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $EnvelopesTableTable,
          EnvelopesTableData
        > {
  $$EnvelopesTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $TransactionsTableTable,
    List<TransactionsTableData>
  >
  _fromTransactionsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.transactionsTable,
    aliasName: 'envelopes__id__transactions__from_envelope_id',
  );

  $$TransactionsTableTableProcessedTableManager get fromTransactions {
    final manager = $$TransactionsTableTableTableManager(
      $_db,
      $_db.transactionsTable,
    ).filter((f) => f.fromEnvelopeId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_fromTransactionsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $TransactionsTableTable,
    List<TransactionsTableData>
  >
  _toTransactionsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.transactionsTable,
    aliasName: 'envelopes__id__transactions__to_envelope_id',
  );

  $$TransactionsTableTableProcessedTableManager get toTransactions {
    final manager = $$TransactionsTableTableTableManager(
      $_db,
      $_db.transactionsTable,
    ).filter((f) => f.toEnvelopeId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_toTransactionsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $SubscriptionsTableTable,
    List<SubscriptionsTableData>
  >
  _subscriptionsTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.subscriptionsTable,
        aliasName: 'envelopes__id__subscriptions__envelope_id',
      );

  $$SubscriptionsTableTableProcessedTableManager get subscriptionsTableRefs {
    final manager = $$SubscriptionsTableTableTableManager(
      $_db,
      $_db.subscriptionsTable,
    ).filter((f) => f.envelopeId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _subscriptionsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$EnvelopesTableTableFilterComposer
    extends Composer<_$AppDatabase, $EnvelopesTableTable> {
  $$EnvelopesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSystem => $composableBuilder(
    column: $table.isSystem,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPaused => $composableBuilder(
    column: $table.isPaused,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> fromTransactions(
    Expression<bool> Function($$TransactionsTableTableFilterComposer f) f,
  ) {
    final $$TransactionsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactionsTable,
      getReferencedColumn: (t) => t.fromEnvelopeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableTableFilterComposer(
            $db: $db,
            $table: $db.transactionsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> toTransactions(
    Expression<bool> Function($$TransactionsTableTableFilterComposer f) f,
  ) {
    final $$TransactionsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactionsTable,
      getReferencedColumn: (t) => t.toEnvelopeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableTableFilterComposer(
            $db: $db,
            $table: $db.transactionsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> subscriptionsTableRefs(
    Expression<bool> Function($$SubscriptionsTableTableFilterComposer f) f,
  ) {
    final $$SubscriptionsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.subscriptionsTable,
      getReferencedColumn: (t) => t.envelopeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubscriptionsTableTableFilterComposer(
            $db: $db,
            $table: $db.subscriptionsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EnvelopesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $EnvelopesTableTable> {
  $$EnvelopesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSystem => $composableBuilder(
    column: $table.isSystem,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPaused => $composableBuilder(
    column: $table.isPaused,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EnvelopesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $EnvelopesTableTable> {
  $$EnvelopesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<bool> get isSystem =>
      $composableBuilder(column: $table.isSystem, builder: (column) => column);

  GeneratedColumn<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isPaused =>
      $composableBuilder(column: $table.isPaused, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> fromTransactions<T extends Object>(
    Expression<T> Function($$TransactionsTableTableAnnotationComposer a) f,
  ) {
    final $$TransactionsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.transactionsTable,
          getReferencedColumn: (t) => t.fromEnvelopeId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TransactionsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.transactionsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> toTransactions<T extends Object>(
    Expression<T> Function($$TransactionsTableTableAnnotationComposer a) f,
  ) {
    final $$TransactionsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.transactionsTable,
          getReferencedColumn: (t) => t.toEnvelopeId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TransactionsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.transactionsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> subscriptionsTableRefs<T extends Object>(
    Expression<T> Function($$SubscriptionsTableTableAnnotationComposer a) f,
  ) {
    final $$SubscriptionsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.subscriptionsTable,
          getReferencedColumn: (t) => t.envelopeId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$SubscriptionsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.subscriptionsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$EnvelopesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EnvelopesTableTable,
          EnvelopesTableData,
          $$EnvelopesTableTableFilterComposer,
          $$EnvelopesTableTableOrderingComposer,
          $$EnvelopesTableTableAnnotationComposer,
          $$EnvelopesTableTableCreateCompanionBuilder,
          $$EnvelopesTableTableUpdateCompanionBuilder,
          (EnvelopesTableData, $$EnvelopesTableTableReferences),
          EnvelopesTableData,
          PrefetchHooks Function({
            bool fromTransactions,
            bool toTransactions,
            bool subscriptionsTableRefs,
          })
        > {
  $$EnvelopesTableTableTableManager(
    _$AppDatabase db,
    $EnvelopesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EnvelopesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EnvelopesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EnvelopesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String?> icon = const Value.absent(),
                Value<bool> isSystem = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<bool> isPaused = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EnvelopesTableCompanion(
                id: id,
                name: name,
                category: category,
                icon: icon,
                isSystem: isSystem,
                isArchived: isArchived,
                isPaused: isPaused,
                sortOrder: sortOrder,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String category,
                Value<String?> icon = const Value.absent(),
                Value<bool> isSystem = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<bool> isPaused = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => EnvelopesTableCompanion.insert(
                id: id,
                name: name,
                category: category,
                icon: icon,
                isSystem: isSystem,
                isArchived: isArchived,
                isPaused: isPaused,
                sortOrder: sortOrder,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$EnvelopesTableTable, EnvelopesTableData>(table),
                  $$EnvelopesTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                fromTransactions = false,
                toTransactions = false,
                subscriptionsTableRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (fromTransactions) db.transactionsTable,
                    if (toTransactions) db.transactionsTable,
                    if (subscriptionsTableRefs) db.subscriptionsTable,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (fromTransactions)
                        await $_getPrefetchedData<
                          EnvelopesTableData,
                          $EnvelopesTableTable,
                          TransactionsTableData
                        >(
                          currentTable: table,
                          referencedTable: $$EnvelopesTableTableReferences
                              ._fromTransactionsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EnvelopesTableTableReferences(
                                db,
                                table,
                                p0,
                              ).fromTransactions,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.fromEnvelopeId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (toTransactions)
                        await $_getPrefetchedData<
                          EnvelopesTableData,
                          $EnvelopesTableTable,
                          TransactionsTableData
                        >(
                          currentTable: table,
                          referencedTable: $$EnvelopesTableTableReferences
                              ._toTransactionsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EnvelopesTableTableReferences(
                                db,
                                table,
                                p0,
                              ).toTransactions,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.toEnvelopeId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (subscriptionsTableRefs)
                        await $_getPrefetchedData<
                          EnvelopesTableData,
                          $EnvelopesTableTable,
                          SubscriptionsTableData
                        >(
                          currentTable: table,
                          referencedTable: $$EnvelopesTableTableReferences
                              ._subscriptionsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EnvelopesTableTableReferences(
                                db,
                                table,
                                p0,
                              ).subscriptionsTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.envelopeId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$EnvelopesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EnvelopesTableTable,
      EnvelopesTableData,
      $$EnvelopesTableTableFilterComposer,
      $$EnvelopesTableTableOrderingComposer,
      $$EnvelopesTableTableAnnotationComposer,
      $$EnvelopesTableTableCreateCompanionBuilder,
      $$EnvelopesTableTableUpdateCompanionBuilder,
      (EnvelopesTableData, $$EnvelopesTableTableReferences),
      EnvelopesTableData,
      PrefetchHooks Function({
        bool fromTransactions,
        bool toTransactions,
        bool subscriptionsTableRefs,
      })
    >;
typedef $$GoalsTableTableCreateCompanionBuilder = GoalsTableCompanion Function({
  required String id,
  required String name,
  required String type,
  required int targetAmount,
  Value<String?> deadline,
  required String status,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$GoalsTableTableUpdateCompanionBuilder = GoalsTableCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> type,
  Value<int> targetAmount,
  Value<String?> deadline,
  Value<String> status,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$GoalsTableTableReferences
    extends BaseReferences<_$AppDatabase, $GoalsTableTable, GoalsTableData> {
  $$GoalsTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<
    $TransactionsTableTable,
    List<TransactionsTableData>
  >
  _transactionsTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.transactionsTable,
        aliasName: 'goals__id__transactions__goal_id',
      );

  $$TransactionsTableTableProcessedTableManager get transactionsTableRefs {
    final manager = $$TransactionsTableTableTableManager(
      $_db,
      $_db.transactionsTable,
    ).filter((f) => f.goalId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _transactionsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$GoalsTableTableFilterComposer
    extends Composer<_$AppDatabase, $GoalsTableTable> {
  $$GoalsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetAmount => $composableBuilder(
    column: $table.targetAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deadline => $composableBuilder(
    column: $table.deadline,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> transactionsTableRefs(
    Expression<bool> Function($$TransactionsTableTableFilterComposer f) f,
  ) {
    final $$TransactionsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactionsTable,
      getReferencedColumn: (t) => t.goalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableTableFilterComposer(
            $db: $db,
            $table: $db.transactionsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GoalsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $GoalsTableTable> {
  $$GoalsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetAmount => $composableBuilder(
    column: $table.targetAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deadline => $composableBuilder(
    column: $table.deadline,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GoalsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $GoalsTableTable> {
  $$GoalsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get targetAmount => $composableBuilder(
    column: $table.targetAmount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get deadline =>
      $composableBuilder(column: $table.deadline, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> transactionsTableRefs<T extends Object>(
    Expression<T> Function($$TransactionsTableTableAnnotationComposer a) f,
  ) {
    final $$TransactionsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.transactionsTable,
          getReferencedColumn: (t) => t.goalId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TransactionsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.transactionsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$GoalsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GoalsTableTable,
          GoalsTableData,
          $$GoalsTableTableFilterComposer,
          $$GoalsTableTableOrderingComposer,
          $$GoalsTableTableAnnotationComposer,
          $$GoalsTableTableCreateCompanionBuilder,
          $$GoalsTableTableUpdateCompanionBuilder,
          (GoalsTableData, $$GoalsTableTableReferences),
          GoalsTableData,
          PrefetchHooks Function({bool transactionsTableRefs})
        > {
  $$GoalsTableTableTableManager(_$AppDatabase db, $GoalsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GoalsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GoalsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GoalsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int> targetAmount = const Value.absent(),
                Value<String?> deadline = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GoalsTableCompanion(
                id: id,
                name: name,
                type: type,
                targetAmount: targetAmount,
                deadline: deadline,
                status: status,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String type,
                required int targetAmount,
                Value<String?> deadline = const Value.absent(),
                required String status,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => GoalsTableCompanion.insert(
                id: id,
                name: name,
                type: type,
                targetAmount: targetAmount,
                deadline: deadline,
                status: status,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$GoalsTableTable, GoalsTableData>(table),
                  $$GoalsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({transactionsTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (transactionsTableRefs) db.transactionsTable,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (transactionsTableRefs)
                    await $_getPrefetchedData<
                      GoalsTableData,
                      $GoalsTableTable,
                      TransactionsTableData
                    >(
                      currentTable: table,
                      referencedTable: $$GoalsTableTableReferences
                          ._transactionsTableRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$GoalsTableTableReferences(
                            db,
                            table,
                            p0,
                          ).transactionsTableRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.goalId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$GoalsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GoalsTableTable,
      GoalsTableData,
      $$GoalsTableTableFilterComposer,
      $$GoalsTableTableOrderingComposer,
      $$GoalsTableTableAnnotationComposer,
      $$GoalsTableTableCreateCompanionBuilder,
      $$GoalsTableTableUpdateCompanionBuilder,
      (GoalsTableData, $$GoalsTableTableReferences),
      GoalsTableData,
      PrefetchHooks Function({bool transactionsTableRefs})
    >;
typedef $$PendingIncomesTableTableCreateCompanionBuilder =
    PendingIncomesTableCompanion Function({
      required String id,
      required int amount,
      Value<String?> client,
      Value<String?> expectedDate,
      required String status,
      Value<String?> receivedTransactionId,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$PendingIncomesTableTableUpdateCompanionBuilder =
    PendingIncomesTableCompanion Function({
      Value<String> id,
      Value<int> amount,
      Value<String?> client,
      Value<String?> expectedDate,
      Value<String> status,
      Value<String?> receivedTransactionId,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$PendingIncomesTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $PendingIncomesTableTable,
          PendingIncomesTableData
        > {
  $$PendingIncomesTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $TransactionsTableTable,
    List<TransactionsTableData>
  >
  _transactionsTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.transactionsTable,
        aliasName: 'pending_incomes__id__transactions__pending_income_id',
      );

  $$TransactionsTableTableProcessedTableManager get transactionsTableRefs {
    final manager =
        $$TransactionsTableTableTableManager(
          $_db,
          $_db.transactionsTable,
        ).filter(
          (f) => f.pendingIncomeId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _transactionsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PendingIncomesTableTableFilterComposer
    extends Composer<_$AppDatabase, $PendingIncomesTableTable> {
  $$PendingIncomesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get client => $composableBuilder(
    column: $table.client,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get expectedDate => $composableBuilder(
    column: $table.expectedDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get receivedTransactionId => $composableBuilder(
    column: $table.receivedTransactionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> transactionsTableRefs(
    Expression<bool> Function($$TransactionsTableTableFilterComposer f) f,
  ) {
    final $$TransactionsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactionsTable,
      getReferencedColumn: (t) => t.pendingIncomeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableTableFilterComposer(
            $db: $db,
            $table: $db.transactionsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PendingIncomesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PendingIncomesTableTable> {
  $$PendingIncomesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get client => $composableBuilder(
    column: $table.client,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get expectedDate => $composableBuilder(
    column: $table.expectedDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get receivedTransactionId => $composableBuilder(
    column: $table.receivedTransactionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PendingIncomesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PendingIncomesTableTable> {
  $$PendingIncomesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get client =>
      $composableBuilder(column: $table.client, builder: (column) => column);

  GeneratedColumn<String> get expectedDate => $composableBuilder(
    column: $table.expectedDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get receivedTransactionId => $composableBuilder(
    column: $table.receivedTransactionId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> transactionsTableRefs<T extends Object>(
    Expression<T> Function($$TransactionsTableTableAnnotationComposer a) f,
  ) {
    final $$TransactionsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.transactionsTable,
          getReferencedColumn: (t) => t.pendingIncomeId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TransactionsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.transactionsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$PendingIncomesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PendingIncomesTableTable,
          PendingIncomesTableData,
          $$PendingIncomesTableTableFilterComposer,
          $$PendingIncomesTableTableOrderingComposer,
          $$PendingIncomesTableTableAnnotationComposer,
          $$PendingIncomesTableTableCreateCompanionBuilder,
          $$PendingIncomesTableTableUpdateCompanionBuilder,
          (PendingIncomesTableData, $$PendingIncomesTableTableReferences),
          PendingIncomesTableData,
          PrefetchHooks Function({bool transactionsTableRefs})
        > {
  $$PendingIncomesTableTableTableManager(
    _$AppDatabase db,
    $PendingIncomesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PendingIncomesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PendingIncomesTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$PendingIncomesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<String?> client = const Value.absent(),
                Value<String?> expectedDate = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> receivedTransactionId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PendingIncomesTableCompanion(
                id: id,
                amount: amount,
                client: client,
                expectedDate: expectedDate,
                status: status,
                receivedTransactionId: receivedTransactionId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int amount,
                Value<String?> client = const Value.absent(),
                Value<String?> expectedDate = const Value.absent(),
                required String status,
                Value<String?> receivedTransactionId = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => PendingIncomesTableCompanion.insert(
                id: id,
                amount: amount,
                client: client,
                expectedDate: expectedDate,
                status: status,
                receivedTransactionId: receivedTransactionId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $PendingIncomesTableTable,
                    PendingIncomesTableData
                  >(table),
                  $$PendingIncomesTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({transactionsTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (transactionsTableRefs) db.transactionsTable,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (transactionsTableRefs)
                    await $_getPrefetchedData<
                      PendingIncomesTableData,
                      $PendingIncomesTableTable,
                      TransactionsTableData
                    >(
                      currentTable: table,
                      referencedTable: $$PendingIncomesTableTableReferences
                          ._transactionsTableRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$PendingIncomesTableTableReferences(
                            db,
                            table,
                            p0,
                          ).transactionsTableRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.pendingIncomeId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$PendingIncomesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PendingIncomesTableTable,
      PendingIncomesTableData,
      $$PendingIncomesTableTableFilterComposer,
      $$PendingIncomesTableTableOrderingComposer,
      $$PendingIncomesTableTableAnnotationComposer,
      $$PendingIncomesTableTableCreateCompanionBuilder,
      $$PendingIncomesTableTableUpdateCompanionBuilder,
      (PendingIncomesTableData, $$PendingIncomesTableTableReferences),
      PendingIncomesTableData,
      PrefetchHooks Function({bool transactionsTableRefs})
    >;
typedef $$BufferEntriesTableTableCreateCompanionBuilder =
    BufferEntriesTableCompanion Function({
      required String id,
      required int amount,
      required String releaseMonth,
      Value<String> status,
      required String holdTransactionId,
      Value<String?> releaseTransactionId,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$BufferEntriesTableTableUpdateCompanionBuilder =
    BufferEntriesTableCompanion Function({
      Value<String> id,
      Value<int> amount,
      Value<String> releaseMonth,
      Value<String> status,
      Value<String> holdTransactionId,
      Value<String?> releaseTransactionId,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$BufferEntriesTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $BufferEntriesTableTable,
          BufferEntriesTableData
        > {
  $$BufferEntriesTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $TransactionsTableTable,
    List<TransactionsTableData>
  >
  _transactionsTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.transactionsTable,
        aliasName: 'buffer_entries__id__transactions__buffer_entry_id',
      );

  $$TransactionsTableTableProcessedTableManager get transactionsTableRefs {
    final manager = $$TransactionsTableTableTableManager(
      $_db,
      $_db.transactionsTable,
    ).filter((f) => f.bufferEntryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _transactionsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$BufferEntriesTableTableFilterComposer
    extends Composer<_$AppDatabase, $BufferEntriesTableTable> {
  $$BufferEntriesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get releaseMonth => $composableBuilder(
    column: $table.releaseMonth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get holdTransactionId => $composableBuilder(
    column: $table.holdTransactionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get releaseTransactionId => $composableBuilder(
    column: $table.releaseTransactionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> transactionsTableRefs(
    Expression<bool> Function($$TransactionsTableTableFilterComposer f) f,
  ) {
    final $$TransactionsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactionsTable,
      getReferencedColumn: (t) => t.bufferEntryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableTableFilterComposer(
            $db: $db,
            $table: $db.transactionsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BufferEntriesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $BufferEntriesTableTable> {
  $$BufferEntriesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get releaseMonth => $composableBuilder(
    column: $table.releaseMonth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get holdTransactionId => $composableBuilder(
    column: $table.holdTransactionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get releaseTransactionId => $composableBuilder(
    column: $table.releaseTransactionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BufferEntriesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $BufferEntriesTableTable> {
  $$BufferEntriesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get releaseMonth => $composableBuilder(
    column: $table.releaseMonth,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get holdTransactionId => $composableBuilder(
    column: $table.holdTransactionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get releaseTransactionId => $composableBuilder(
    column: $table.releaseTransactionId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> transactionsTableRefs<T extends Object>(
    Expression<T> Function($$TransactionsTableTableAnnotationComposer a) f,
  ) {
    final $$TransactionsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.transactionsTable,
          getReferencedColumn: (t) => t.bufferEntryId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TransactionsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.transactionsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$BufferEntriesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BufferEntriesTableTable,
          BufferEntriesTableData,
          $$BufferEntriesTableTableFilterComposer,
          $$BufferEntriesTableTableOrderingComposer,
          $$BufferEntriesTableTableAnnotationComposer,
          $$BufferEntriesTableTableCreateCompanionBuilder,
          $$BufferEntriesTableTableUpdateCompanionBuilder,
          (BufferEntriesTableData, $$BufferEntriesTableTableReferences),
          BufferEntriesTableData,
          PrefetchHooks Function({bool transactionsTableRefs})
        > {
  $$BufferEntriesTableTableTableManager(
    _$AppDatabase db,
    $BufferEntriesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BufferEntriesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BufferEntriesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BufferEntriesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<String> releaseMonth = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> holdTransactionId = const Value.absent(),
                Value<String?> releaseTransactionId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BufferEntriesTableCompanion(
                id: id,
                amount: amount,
                releaseMonth: releaseMonth,
                status: status,
                holdTransactionId: holdTransactionId,
                releaseTransactionId: releaseTransactionId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int amount,
                required String releaseMonth,
                Value<String> status = const Value.absent(),
                required String holdTransactionId,
                Value<String?> releaseTransactionId = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => BufferEntriesTableCompanion.insert(
                id: id,
                amount: amount,
                releaseMonth: releaseMonth,
                status: status,
                holdTransactionId: holdTransactionId,
                releaseTransactionId: releaseTransactionId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BufferEntriesTableTable, BufferEntriesTableData>(
                    table,
                  ),
                  $$BufferEntriesTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({transactionsTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (transactionsTableRefs) db.transactionsTable,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (transactionsTableRefs)
                    await $_getPrefetchedData<
                      BufferEntriesTableData,
                      $BufferEntriesTableTable,
                      TransactionsTableData
                    >(
                      currentTable: table,
                      referencedTable: $$BufferEntriesTableTableReferences
                          ._transactionsTableRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$BufferEntriesTableTableReferences(
                            db,
                            table,
                            p0,
                          ).transactionsTableRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.bufferEntryId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$BufferEntriesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BufferEntriesTableTable,
      BufferEntriesTableData,
      $$BufferEntriesTableTableFilterComposer,
      $$BufferEntriesTableTableOrderingComposer,
      $$BufferEntriesTableTableAnnotationComposer,
      $$BufferEntriesTableTableCreateCompanionBuilder,
      $$BufferEntriesTableTableUpdateCompanionBuilder,
      (BufferEntriesTableData, $$BufferEntriesTableTableReferences),
      BufferEntriesTableData,
      PrefetchHooks Function({bool transactionsTableRefs})
    >;
typedef $$TransactionsTableTableCreateCompanionBuilder =
    TransactionsTableCompanion Function({
      required String id,
      required String type,
      required int amount,
      required DateTime occurredAt,
      required String localDate,
      Value<String?> fromEnvelopeId,
      Value<String?> toEnvelopeId,
      Value<String?> goalId,
      Value<String?> assetId,
      Value<bool> countsAsSpending,
      Value<String?> note,
      Value<String?> source,
      Value<String?> pendingIncomeId,
      Value<String?> bufferEntryId,
      Value<DateTime?> deletedAt,
      required DateTime createdAt,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });
typedef $$TransactionsTableTableUpdateCompanionBuilder =
    TransactionsTableCompanion Function({
      Value<String> id,
      Value<String> type,
      Value<int> amount,
      Value<DateTime> occurredAt,
      Value<String> localDate,
      Value<String?> fromEnvelopeId,
      Value<String?> toEnvelopeId,
      Value<String?> goalId,
      Value<String?> assetId,
      Value<bool> countsAsSpending,
      Value<String?> note,
      Value<String?> source,
      Value<String?> pendingIncomeId,
      Value<String?> bufferEntryId,
      Value<DateTime?> deletedAt,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });

final class $$TransactionsTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $TransactionsTableTable,
          TransactionsTableData
        > {
  $$TransactionsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $EnvelopesTableTable _fromEnvelopeIdTable(_$AppDatabase db) => db
      .envelopesTable
      .createAlias('transactions__from_envelope_id__envelopes__id');

  $$EnvelopesTableTableProcessedTableManager? get fromEnvelopeId {
    final $_column = $_itemColumn<String>('from_envelope_id');
    if ($_column == null) return null;
    final manager = $$EnvelopesTableTableTableManager(
      $_db,
      $_db.envelopesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_fromEnvelopeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $EnvelopesTableTable _toEnvelopeIdTable(_$AppDatabase db) => db
      .envelopesTable
      .createAlias('transactions__to_envelope_id__envelopes__id');

  $$EnvelopesTableTableProcessedTableManager? get toEnvelopeId {
    final $_column = $_itemColumn<String>('to_envelope_id');
    if ($_column == null) return null;
    final manager = $$EnvelopesTableTableTableManager(
      $_db,
      $_db.envelopesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_toEnvelopeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $GoalsTableTable _goalIdTable(_$AppDatabase db) =>
      db.goalsTable.createAlias('transactions__goal_id__goals__id');

  $$GoalsTableTableProcessedTableManager? get goalId {
    final $_column = $_itemColumn<String>('goal_id');
    if ($_column == null) return null;
    final manager = $$GoalsTableTableTableManager(
      $_db,
      $_db.goalsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_goalIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PendingIncomesTableTable _pendingIncomeIdTable(_$AppDatabase db) => db
      .pendingIncomesTable
      .createAlias('transactions__pending_income_id__pending_incomes__id');

  $$PendingIncomesTableTableProcessedTableManager? get pendingIncomeId {
    final $_column = $_itemColumn<String>('pending_income_id');
    if ($_column == null) return null;
    final manager = $$PendingIncomesTableTableTableManager(
      $_db,
      $_db.pendingIncomesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_pendingIncomeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $BufferEntriesTableTable _bufferEntryIdTable(_$AppDatabase db) => db
      .bufferEntriesTable
      .createAlias('transactions__buffer_entry_id__buffer_entries__id');

  $$BufferEntriesTableTableProcessedTableManager? get bufferEntryId {
    final $_column = $_itemColumn<String>('buffer_entry_id');
    if ($_column == null) return null;
    final manager = $$BufferEntriesTableTableTableManager(
      $_db,
      $_db.bufferEntriesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_bufferEntryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TransactionsTableTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionsTableTable> {
  $$TransactionsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localDate => $composableBuilder(
    column: $table.localDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get assetId => $composableBuilder(
    column: $table.assetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get countsAsSpending => $composableBuilder(
    column: $table.countsAsSpending,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$EnvelopesTableTableFilterComposer get fromEnvelopeId {
    final $$EnvelopesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fromEnvelopeId,
      referencedTable: $db.envelopesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EnvelopesTableTableFilterComposer(
            $db: $db,
            $table: $db.envelopesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EnvelopesTableTableFilterComposer get toEnvelopeId {
    final $$EnvelopesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.toEnvelopeId,
      referencedTable: $db.envelopesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EnvelopesTableTableFilterComposer(
            $db: $db,
            $table: $db.envelopesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$GoalsTableTableFilterComposer get goalId {
    final $$GoalsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.goalId,
      referencedTable: $db.goalsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GoalsTableTableFilterComposer(
            $db: $db,
            $table: $db.goalsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PendingIncomesTableTableFilterComposer get pendingIncomeId {
    final $$PendingIncomesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pendingIncomeId,
      referencedTable: $db.pendingIncomesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PendingIncomesTableTableFilterComposer(
            $db: $db,
            $table: $db.pendingIncomesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BufferEntriesTableTableFilterComposer get bufferEntryId {
    final $$BufferEntriesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bufferEntryId,
      referencedTable: $db.bufferEntriesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BufferEntriesTableTableFilterComposer(
            $db: $db,
            $table: $db.bufferEntriesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransactionsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionsTableTable> {
  $$TransactionsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localDate => $composableBuilder(
    column: $table.localDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get assetId => $composableBuilder(
    column: $table.assetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get countsAsSpending => $composableBuilder(
    column: $table.countsAsSpending,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$EnvelopesTableTableOrderingComposer get fromEnvelopeId {
    final $$EnvelopesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fromEnvelopeId,
      referencedTable: $db.envelopesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EnvelopesTableTableOrderingComposer(
            $db: $db,
            $table: $db.envelopesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EnvelopesTableTableOrderingComposer get toEnvelopeId {
    final $$EnvelopesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.toEnvelopeId,
      referencedTable: $db.envelopesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EnvelopesTableTableOrderingComposer(
            $db: $db,
            $table: $db.envelopesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$GoalsTableTableOrderingComposer get goalId {
    final $$GoalsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.goalId,
      referencedTable: $db.goalsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GoalsTableTableOrderingComposer(
            $db: $db,
            $table: $db.goalsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PendingIncomesTableTableOrderingComposer get pendingIncomeId {
    final $$PendingIncomesTableTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.pendingIncomeId,
          referencedTable: $db.pendingIncomesTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PendingIncomesTableTableOrderingComposer(
                $db: $db,
                $table: $db.pendingIncomesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$BufferEntriesTableTableOrderingComposer get bufferEntryId {
    final $$BufferEntriesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bufferEntryId,
      referencedTable: $db.bufferEntriesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BufferEntriesTableTableOrderingComposer(
            $db: $db,
            $table: $db.bufferEntriesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransactionsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionsTableTable> {
  $$TransactionsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get localDate =>
      $composableBuilder(column: $table.localDate, builder: (column) => column);

  GeneratedColumn<String> get assetId =>
      $composableBuilder(column: $table.assetId, builder: (column) => column);

  GeneratedColumn<bool> get countsAsSpending => $composableBuilder(
    column: $table.countsAsSpending,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$EnvelopesTableTableAnnotationComposer get fromEnvelopeId {
    final $$EnvelopesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fromEnvelopeId,
      referencedTable: $db.envelopesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EnvelopesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.envelopesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EnvelopesTableTableAnnotationComposer get toEnvelopeId {
    final $$EnvelopesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.toEnvelopeId,
      referencedTable: $db.envelopesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EnvelopesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.envelopesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$GoalsTableTableAnnotationComposer get goalId {
    final $$GoalsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.goalId,
      referencedTable: $db.goalsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GoalsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.goalsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PendingIncomesTableTableAnnotationComposer get pendingIncomeId {
    final $$PendingIncomesTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.pendingIncomeId,
          referencedTable: $db.pendingIncomesTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PendingIncomesTableTableAnnotationComposer(
                $db: $db,
                $table: $db.pendingIncomesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$BufferEntriesTableTableAnnotationComposer get bufferEntryId {
    final $$BufferEntriesTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.bufferEntryId,
          referencedTable: $db.bufferEntriesTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$BufferEntriesTableTableAnnotationComposer(
                $db: $db,
                $table: $db.bufferEntriesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$TransactionsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransactionsTableTable,
          TransactionsTableData,
          $$TransactionsTableTableFilterComposer,
          $$TransactionsTableTableOrderingComposer,
          $$TransactionsTableTableAnnotationComposer,
          $$TransactionsTableTableCreateCompanionBuilder,
          $$TransactionsTableTableUpdateCompanionBuilder,
          (TransactionsTableData, $$TransactionsTableTableReferences),
          TransactionsTableData,
          PrefetchHooks Function({
            bool fromEnvelopeId,
            bool toEnvelopeId,
            bool goalId,
            bool pendingIncomeId,
            bool bufferEntryId,
          })
        > {
  $$TransactionsTableTableTableManager(
    _$AppDatabase db,
    $TransactionsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<DateTime> occurredAt = const Value.absent(),
                Value<String> localDate = const Value.absent(),
                Value<String?> fromEnvelopeId = const Value.absent(),
                Value<String?> toEnvelopeId = const Value.absent(),
                Value<String?> goalId = const Value.absent(),
                Value<String?> assetId = const Value.absent(),
                Value<bool> countsAsSpending = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String?> source = const Value.absent(),
                Value<String?> pendingIncomeId = const Value.absent(),
                Value<String?> bufferEntryId = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TransactionsTableCompanion(
                id: id,
                type: type,
                amount: amount,
                occurredAt: occurredAt,
                localDate: localDate,
                fromEnvelopeId: fromEnvelopeId,
                toEnvelopeId: toEnvelopeId,
                goalId: goalId,
                assetId: assetId,
                countsAsSpending: countsAsSpending,
                note: note,
                source: source,
                pendingIncomeId: pendingIncomeId,
                bufferEntryId: bufferEntryId,
                deletedAt: deletedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String type,
                required int amount,
                required DateTime occurredAt,
                required String localDate,
                Value<String?> fromEnvelopeId = const Value.absent(),
                Value<String?> toEnvelopeId = const Value.absent(),
                Value<String?> goalId = const Value.absent(),
                Value<String?> assetId = const Value.absent(),
                Value<bool> countsAsSpending = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String?> source = const Value.absent(),
                Value<String?> pendingIncomeId = const Value.absent(),
                Value<String?> bufferEntryId = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                required DateTime createdAt,
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TransactionsTableCompanion.insert(
                id: id,
                type: type,
                amount: amount,
                occurredAt: occurredAt,
                localDate: localDate,
                fromEnvelopeId: fromEnvelopeId,
                toEnvelopeId: toEnvelopeId,
                goalId: goalId,
                assetId: assetId,
                countsAsSpending: countsAsSpending,
                note: note,
                source: source,
                pendingIncomeId: pendingIncomeId,
                bufferEntryId: bufferEntryId,
                deletedAt: deletedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TransactionsTableTable, TransactionsTableData>(
                    table,
                  ),
                  $$TransactionsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                fromEnvelopeId = false,
                toEnvelopeId = false,
                goalId = false,
                pendingIncomeId = false,
                bufferEntryId = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (fromEnvelopeId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.fromEnvelopeId,
                            referencedTable: $$TransactionsTableTableReferences
                                ._fromEnvelopeIdTable(db),
                            referencedColumn: $$TransactionsTableTableReferences
                                ._fromEnvelopeIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (toEnvelopeId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.toEnvelopeId,
                            referencedTable: $$TransactionsTableTableReferences
                                ._toEnvelopeIdTable(db),
                            referencedColumn: $$TransactionsTableTableReferences
                                ._toEnvelopeIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (goalId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.goalId,
                            referencedTable: $$TransactionsTableTableReferences
                                ._goalIdTable(db),
                            referencedColumn: $$TransactionsTableTableReferences
                                ._goalIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (pendingIncomeId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.pendingIncomeId,
                            referencedTable: $$TransactionsTableTableReferences
                                ._pendingIncomeIdTable(db),
                            referencedColumn: $$TransactionsTableTableReferences
                                ._pendingIncomeIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (bufferEntryId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.bufferEntryId,
                            referencedTable: $$TransactionsTableTableReferences
                                ._bufferEntryIdTable(db),
                            referencedColumn: $$TransactionsTableTableReferences
                                ._bufferEntryIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$TransactionsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransactionsTableTable,
      TransactionsTableData,
      $$TransactionsTableTableFilterComposer,
      $$TransactionsTableTableOrderingComposer,
      $$TransactionsTableTableAnnotationComposer,
      $$TransactionsTableTableCreateCompanionBuilder,
      $$TransactionsTableTableUpdateCompanionBuilder,
      (TransactionsTableData, $$TransactionsTableTableReferences),
      TransactionsTableData,
      PrefetchHooks Function({
        bool fromEnvelopeId,
        bool toEnvelopeId,
        bool goalId,
        bool pendingIncomeId,
        bool bufferEntryId,
      })
    >;
typedef $$SubscriptionsTableTableCreateCompanionBuilder =
    SubscriptionsTableCompanion Function({
      required String id,
      required String name,
      required int amount,
      required String cycle,
      required String nextDueDate,
      required String envelopeId,
      Value<bool> isActive,
      required int notificationSeq,
      Value<int> rowid,
    });
typedef $$SubscriptionsTableTableUpdateCompanionBuilder =
    SubscriptionsTableCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<int> amount,
      Value<String> cycle,
      Value<String> nextDueDate,
      Value<String> envelopeId,
      Value<bool> isActive,
      Value<int> notificationSeq,
      Value<int> rowid,
    });

final class $$SubscriptionsTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $SubscriptionsTableTable,
          SubscriptionsTableData
        > {
  $$SubscriptionsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $EnvelopesTableTable _envelopeIdTable(_$AppDatabase db) => db
      .envelopesTable
      .createAlias('subscriptions__envelope_id__envelopes__id');

  $$EnvelopesTableTableProcessedTableManager get envelopeId {
    final $_column = $_itemColumn<String>('envelope_id')!;

    final manager = $$EnvelopesTableTableTableManager(
      $_db,
      $_db.envelopesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_envelopeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SubscriptionsTableTableFilterComposer
    extends Composer<_$AppDatabase, $SubscriptionsTableTable> {
  $$SubscriptionsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cycle => $composableBuilder(
    column: $table.cycle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nextDueDate => $composableBuilder(
    column: $table.nextDueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get notificationSeq => $composableBuilder(
    column: $table.notificationSeq,
    builder: (column) => ColumnFilters(column),
  );

  $$EnvelopesTableTableFilterComposer get envelopeId {
    final $$EnvelopesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.envelopeId,
      referencedTable: $db.envelopesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EnvelopesTableTableFilterComposer(
            $db: $db,
            $table: $db.envelopesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SubscriptionsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SubscriptionsTableTable> {
  $$SubscriptionsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cycle => $composableBuilder(
    column: $table.cycle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nextDueDate => $composableBuilder(
    column: $table.nextDueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get notificationSeq => $composableBuilder(
    column: $table.notificationSeq,
    builder: (column) => ColumnOrderings(column),
  );

  $$EnvelopesTableTableOrderingComposer get envelopeId {
    final $$EnvelopesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.envelopeId,
      referencedTable: $db.envelopesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EnvelopesTableTableOrderingComposer(
            $db: $db,
            $table: $db.envelopesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SubscriptionsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SubscriptionsTableTable> {
  $$SubscriptionsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get cycle =>
      $composableBuilder(column: $table.cycle, builder: (column) => column);

  GeneratedColumn<String> get nextDueDate => $composableBuilder(
    column: $table.nextDueDate,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<int> get notificationSeq => $composableBuilder(
    column: $table.notificationSeq,
    builder: (column) => column,
  );

  $$EnvelopesTableTableAnnotationComposer get envelopeId {
    final $$EnvelopesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.envelopeId,
      referencedTable: $db.envelopesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EnvelopesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.envelopesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SubscriptionsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SubscriptionsTableTable,
          SubscriptionsTableData,
          $$SubscriptionsTableTableFilterComposer,
          $$SubscriptionsTableTableOrderingComposer,
          $$SubscriptionsTableTableAnnotationComposer,
          $$SubscriptionsTableTableCreateCompanionBuilder,
          $$SubscriptionsTableTableUpdateCompanionBuilder,
          (SubscriptionsTableData, $$SubscriptionsTableTableReferences),
          SubscriptionsTableData,
          PrefetchHooks Function({bool envelopeId})
        > {
  $$SubscriptionsTableTableTableManager(
    _$AppDatabase db,
    $SubscriptionsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SubscriptionsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SubscriptionsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SubscriptionsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<String> cycle = const Value.absent(),
                Value<String> nextDueDate = const Value.absent(),
                Value<String> envelopeId = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> notificationSeq = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SubscriptionsTableCompanion(
                id: id,
                name: name,
                amount: amount,
                cycle: cycle,
                nextDueDate: nextDueDate,
                envelopeId: envelopeId,
                isActive: isActive,
                notificationSeq: notificationSeq,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required int amount,
                required String cycle,
                required String nextDueDate,
                required String envelopeId,
                Value<bool> isActive = const Value.absent(),
                required int notificationSeq,
                Value<int> rowid = const Value.absent(),
              }) => SubscriptionsTableCompanion.insert(
                id: id,
                name: name,
                amount: amount,
                cycle: cycle,
                nextDueDate: nextDueDate,
                envelopeId: envelopeId,
                isActive: isActive,
                notificationSeq: notificationSeq,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SubscriptionsTableTable, SubscriptionsTableData>(
                    table,
                  ),
                  $$SubscriptionsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({envelopeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (envelopeId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.envelopeId,
                        referencedTable: $$SubscriptionsTableTableReferences
                            ._envelopeIdTable(db),
                        referencedColumn: $$SubscriptionsTableTableReferences
                            ._envelopeIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SubscriptionsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SubscriptionsTableTable,
      SubscriptionsTableData,
      $$SubscriptionsTableTableFilterComposer,
      $$SubscriptionsTableTableOrderingComposer,
      $$SubscriptionsTableTableAnnotationComposer,
      $$SubscriptionsTableTableCreateCompanionBuilder,
      $$SubscriptionsTableTableUpdateCompanionBuilder,
      (SubscriptionsTableData, $$SubscriptionsTableTableReferences),
      SubscriptionsTableData,
      PrefetchHooks Function({bool envelopeId})
    >;
typedef $$ResistedEventsTableTableCreateCompanionBuilder =
    ResistedEventsTableCompanion Function({
      required String id,
      required int amount,
      required DateTime occurredAt,
      required String localDate,
      Value<int> rowid,
    });
typedef $$ResistedEventsTableTableUpdateCompanionBuilder =
    ResistedEventsTableCompanion Function({
      Value<String> id,
      Value<int> amount,
      Value<DateTime> occurredAt,
      Value<String> localDate,
      Value<int> rowid,
    });

class $$ResistedEventsTableTableFilterComposer
    extends Composer<_$AppDatabase, $ResistedEventsTableTable> {
  $$ResistedEventsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localDate => $composableBuilder(
    column: $table.localDate,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ResistedEventsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ResistedEventsTableTable> {
  $$ResistedEventsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localDate => $composableBuilder(
    column: $table.localDate,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ResistedEventsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ResistedEventsTableTable> {
  $$ResistedEventsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get localDate =>
      $composableBuilder(column: $table.localDate, builder: (column) => column);
}

class $$ResistedEventsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ResistedEventsTableTable,
          ResistedEventsTableData,
          $$ResistedEventsTableTableFilterComposer,
          $$ResistedEventsTableTableOrderingComposer,
          $$ResistedEventsTableTableAnnotationComposer,
          $$ResistedEventsTableTableCreateCompanionBuilder,
          $$ResistedEventsTableTableUpdateCompanionBuilder,
          (
            ResistedEventsTableData,
            BaseReferences<
              _$AppDatabase,
              $ResistedEventsTableTable,
              ResistedEventsTableData
            >,
          ),
          ResistedEventsTableData,
          PrefetchHooks Function()
        > {
  $$ResistedEventsTableTableTableManager(
    _$AppDatabase db,
    $ResistedEventsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ResistedEventsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ResistedEventsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ResistedEventsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<DateTime> occurredAt = const Value.absent(),
                Value<String> localDate = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ResistedEventsTableCompanion(
                id: id,
                amount: amount,
                occurredAt: occurredAt,
                localDate: localDate,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int amount,
                required DateTime occurredAt,
                required String localDate,
                Value<int> rowid = const Value.absent(),
              }) => ResistedEventsTableCompanion.insert(
                id: id,
                amount: amount,
                occurredAt: occurredAt,
                localDate: localDate,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $ResistedEventsTableTable,
                    ResistedEventsTableData
                  >(table),
                  BaseReferences<
                    _$AppDatabase,
                    $ResistedEventsTableTable,
                    ResistedEventsTableData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ResistedEventsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ResistedEventsTableTable,
      ResistedEventsTableData,
      $$ResistedEventsTableTableFilterComposer,
      $$ResistedEventsTableTableOrderingComposer,
      $$ResistedEventsTableTableAnnotationComposer,
      $$ResistedEventsTableTableCreateCompanionBuilder,
      $$ResistedEventsTableTableUpdateCompanionBuilder,
      (
        ResistedEventsTableData,
        BaseReferences<
          _$AppDatabase,
          $ResistedEventsTableTable,
          ResistedEventsTableData
        >,
      ),
      ResistedEventsTableData,
      PrefetchHooks Function()
    >;
typedef $$AppSettingsTableTableCreateCompanionBuilder =
    AppSettingsTableCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$AppSettingsTableTableUpdateCompanionBuilder =
    AppSettingsTableCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$AppSettingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTableTable> {
  $$AppSettingsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTableTable> {
  $$AppSettingsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTableTable> {
  $$AppSettingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$AppSettingsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTableTable,
          AppSettingsTableData,
          $$AppSettingsTableTableFilterComposer,
          $$AppSettingsTableTableOrderingComposer,
          $$AppSettingsTableTableAnnotationComposer,
          $$AppSettingsTableTableCreateCompanionBuilder,
          $$AppSettingsTableTableUpdateCompanionBuilder,
          (
            AppSettingsTableData,
            BaseReferences<
              _$AppDatabase,
              $AppSettingsTableTable,
              AppSettingsTableData
            >,
          ),
          AppSettingsTableData,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableTableManager(
    _$AppDatabase db,
    $AppSettingsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => AppSettingsTableCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsTableCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AppSettingsTableTable, AppSettingsTableData>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $AppSettingsTableTable,
                    AppSettingsTableData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTableTable,
      AppSettingsTableData,
      $$AppSettingsTableTableFilterComposer,
      $$AppSettingsTableTableOrderingComposer,
      $$AppSettingsTableTableAnnotationComposer,
      $$AppSettingsTableTableCreateCompanionBuilder,
      $$AppSettingsTableTableUpdateCompanionBuilder,
      (
        AppSettingsTableData,
        BaseReferences<
          _$AppDatabase,
          $AppSettingsTableTable,
          AppSettingsTableData
        >,
      ),
      AppSettingsTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$EnvelopesTableTableTableManager get envelopesTable =>
      $$EnvelopesTableTableTableManager(_db, _db.envelopesTable);
  $$GoalsTableTableTableManager get goalsTable =>
      $$GoalsTableTableTableManager(_db, _db.goalsTable);
  $$PendingIncomesTableTableTableManager get pendingIncomesTable =>
      $$PendingIncomesTableTableTableManager(_db, _db.pendingIncomesTable);
  $$BufferEntriesTableTableTableManager get bufferEntriesTable =>
      $$BufferEntriesTableTableTableManager(_db, _db.bufferEntriesTable);
  $$TransactionsTableTableTableManager get transactionsTable =>
      $$TransactionsTableTableTableManager(_db, _db.transactionsTable);
  $$SubscriptionsTableTableTableManager get subscriptionsTable =>
      $$SubscriptionsTableTableTableManager(_db, _db.subscriptionsTable);
  $$ResistedEventsTableTableTableManager get resistedEventsTable =>
      $$ResistedEventsTableTableTableManager(_db, _db.resistedEventsTable);
  $$AppSettingsTableTableTableManager get appSettingsTable =>
      $$AppSettingsTableTableTableManager(_db, _db.appSettingsTable);
}

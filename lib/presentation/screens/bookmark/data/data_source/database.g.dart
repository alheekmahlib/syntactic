// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $BookmarksTable extends Bookmarks
    with TableInfo<$BookmarksTable, BookmarkModel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BookmarksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, true,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _bookNameMeta =
      const VerificationMeta('bookName');
  @override
  late final GeneratedColumn<String> bookName = GeneratedColumn<String>(
      'book_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _chapterNameMeta =
      const VerificationMeta('chapterName');
  @override
  late final GeneratedColumn<String> chapterName = GeneratedColumn<String>(
      'chapter_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _poemTextMeta =
      const VerificationMeta('poemText');
  @override
  late final GeneratedColumn<String> poemText = GeneratedColumn<String>(
      'poem_text', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _chapterNumberMeta =
      const VerificationMeta('chapterNumber');
  @override
  late final GeneratedColumn<int> chapterNumber = GeneratedColumn<int>(
      'chapter_number', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _bookNumberMeta =
      const VerificationMeta('bookNumber');
  @override
  late final GeneratedColumn<int> bookNumber = GeneratedColumn<int>(
      'book_number', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _bookTypeMeta =
      const VerificationMeta('bookType');
  @override
  late final GeneratedColumn<String> bookType = GeneratedColumn<String>(
      'book_type', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _poemNumberMeta =
      const VerificationMeta('poemNumber');
  @override
  late final GeneratedColumn<int> poemNumber = GeneratedColumn<int>(
      'poem_number', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        bookName,
        chapterName,
        poemText,
        chapterNumber,
        bookNumber,
        bookType,
        poemNumber,
        date
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bookmarks';
  @override
  VerificationContext validateIntegrity(Insertable<BookmarkModel> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('book_name')) {
      context.handle(_bookNameMeta,
          bookName.isAcceptableOrUnknown(data['book_name']!, _bookNameMeta));
    }
    if (data.containsKey('chapter_name')) {
      context.handle(
          _chapterNameMeta,
          chapterName.isAcceptableOrUnknown(
              data['chapter_name']!, _chapterNameMeta));
    }
    if (data.containsKey('poem_text')) {
      context.handle(_poemTextMeta,
          poemText.isAcceptableOrUnknown(data['poem_text']!, _poemTextMeta));
    }
    if (data.containsKey('chapter_number')) {
      context.handle(
          _chapterNumberMeta,
          chapterNumber.isAcceptableOrUnknown(
              data['chapter_number']!, _chapterNumberMeta));
    }
    if (data.containsKey('book_number')) {
      context.handle(
          _bookNumberMeta,
          bookNumber.isAcceptableOrUnknown(
              data['book_number']!, _bookNumberMeta));
    }
    if (data.containsKey('book_type')) {
      context.handle(_bookTypeMeta,
          bookType.isAcceptableOrUnknown(data['book_type']!, _bookTypeMeta));
    }
    if (data.containsKey('poem_number')) {
      context.handle(
          _poemNumberMeta,
          poemNumber.isAcceptableOrUnknown(
              data['poem_number']!, _poemNumberMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BookmarkModel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BookmarkModel(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id']),
      bookName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}book_name']),
      chapterName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}chapter_name']),
      poemText: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}poem_text']),
      chapterNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}chapter_number']),
      bookNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}book_number']),
      bookType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}book_type']),
      poemNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}poem_number']),
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date']),
    );
  }

  @override
  $BookmarksTable createAlias(String alias) {
    return $BookmarksTable(attachedDatabase, alias);
  }
}

class BookmarkModel extends DataClass implements Insertable<BookmarkModel> {
  final int? id;
  final String? bookName;
  final String? chapterName;
  final String? poemText;
  final int? chapterNumber;
  final int? bookNumber;
  final String? bookType;
  final int? poemNumber;
  final DateTime? date;
  const BookmarkModel(
      {this.id,
      this.bookName,
      this.chapterName,
      this.poemText,
      this.chapterNumber,
      this.bookNumber,
      this.bookType,
      this.poemNumber,
      this.date});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || bookName != null) {
      map['book_name'] = Variable<String>(bookName);
    }
    if (!nullToAbsent || chapterName != null) {
      map['chapter_name'] = Variable<String>(chapterName);
    }
    if (!nullToAbsent || poemText != null) {
      map['poem_text'] = Variable<String>(poemText);
    }
    if (!nullToAbsent || chapterNumber != null) {
      map['chapter_number'] = Variable<int>(chapterNumber);
    }
    if (!nullToAbsent || bookNumber != null) {
      map['book_number'] = Variable<int>(bookNumber);
    }
    if (!nullToAbsent || bookType != null) {
      map['book_type'] = Variable<String>(bookType);
    }
    if (!nullToAbsent || poemNumber != null) {
      map['poem_number'] = Variable<int>(poemNumber);
    }
    if (!nullToAbsent || date != null) {
      map['date'] = Variable<DateTime>(date);
    }
    return map;
  }

  BookmarksCompanion toCompanion(bool nullToAbsent) {
    return BookmarksCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      bookName: bookName == null && nullToAbsent
          ? const Value.absent()
          : Value(bookName),
      chapterName: chapterName == null && nullToAbsent
          ? const Value.absent()
          : Value(chapterName),
      poemText: poemText == null && nullToAbsent
          ? const Value.absent()
          : Value(poemText),
      chapterNumber: chapterNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(chapterNumber),
      bookNumber: bookNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(bookNumber),
      bookType: bookType == null && nullToAbsent
          ? const Value.absent()
          : Value(bookType),
      poemNumber: poemNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(poemNumber),
      date: date == null && nullToAbsent ? const Value.absent() : Value(date),
    );
  }

  factory BookmarkModel.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BookmarkModel(
      id: serializer.fromJson<int?>(json['id']),
      bookName: serializer.fromJson<String?>(json['bookName']),
      chapterName: serializer.fromJson<String?>(json['chapterName']),
      poemText: serializer.fromJson<String?>(json['poemText']),
      chapterNumber: serializer.fromJson<int?>(json['chapterNumber']),
      bookNumber: serializer.fromJson<int?>(json['bookNumber']),
      bookType: serializer.fromJson<String?>(json['bookType']),
      poemNumber: serializer.fromJson<int?>(json['poemNumber']),
      date: serializer.fromJson<DateTime?>(json['date']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int?>(id),
      'bookName': serializer.toJson<String?>(bookName),
      'chapterName': serializer.toJson<String?>(chapterName),
      'poemText': serializer.toJson<String?>(poemText),
      'chapterNumber': serializer.toJson<int?>(chapterNumber),
      'bookNumber': serializer.toJson<int?>(bookNumber),
      'bookType': serializer.toJson<String?>(bookType),
      'poemNumber': serializer.toJson<int?>(poemNumber),
      'date': serializer.toJson<DateTime?>(date),
    };
  }

  BookmarkModel copyWith(
          {Value<int?> id = const Value.absent(),
          Value<String?> bookName = const Value.absent(),
          Value<String?> chapterName = const Value.absent(),
          Value<String?> poemText = const Value.absent(),
          Value<int?> chapterNumber = const Value.absent(),
          Value<int?> bookNumber = const Value.absent(),
          Value<String?> bookType = const Value.absent(),
          Value<int?> poemNumber = const Value.absent(),
          Value<DateTime?> date = const Value.absent()}) =>
      BookmarkModel(
        id: id.present ? id.value : this.id,
        bookName: bookName.present ? bookName.value : this.bookName,
        chapterName: chapterName.present ? chapterName.value : this.chapterName,
        poemText: poemText.present ? poemText.value : this.poemText,
        chapterNumber:
            chapterNumber.present ? chapterNumber.value : this.chapterNumber,
        bookNumber: bookNumber.present ? bookNumber.value : this.bookNumber,
        bookType: bookType.present ? bookType.value : this.bookType,
        poemNumber: poemNumber.present ? poemNumber.value : this.poemNumber,
        date: date.present ? date.value : this.date,
      );
  BookmarkModel copyWithCompanion(BookmarksCompanion data) {
    return BookmarkModel(
      id: data.id.present ? data.id.value : this.id,
      bookName: data.bookName.present ? data.bookName.value : this.bookName,
      chapterName:
          data.chapterName.present ? data.chapterName.value : this.chapterName,
      poemText: data.poemText.present ? data.poemText.value : this.poemText,
      chapterNumber: data.chapterNumber.present
          ? data.chapterNumber.value
          : this.chapterNumber,
      bookNumber:
          data.bookNumber.present ? data.bookNumber.value : this.bookNumber,
      bookType: data.bookType.present ? data.bookType.value : this.bookType,
      poemNumber:
          data.poemNumber.present ? data.poemNumber.value : this.poemNumber,
      date: data.date.present ? data.date.value : this.date,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BookmarkModel(')
          ..write('id: $id, ')
          ..write('bookName: $bookName, ')
          ..write('chapterName: $chapterName, ')
          ..write('poemText: $poemText, ')
          ..write('chapterNumber: $chapterNumber, ')
          ..write('bookNumber: $bookNumber, ')
          ..write('bookType: $bookType, ')
          ..write('poemNumber: $poemNumber, ')
          ..write('date: $date')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, bookName, chapterName, poemText,
      chapterNumber, bookNumber, bookType, poemNumber, date);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BookmarkModel &&
          other.id == this.id &&
          other.bookName == this.bookName &&
          other.chapterName == this.chapterName &&
          other.poemText == this.poemText &&
          other.chapterNumber == this.chapterNumber &&
          other.bookNumber == this.bookNumber &&
          other.bookType == this.bookType &&
          other.poemNumber == this.poemNumber &&
          other.date == this.date);
}

class BookmarksCompanion extends UpdateCompanion<BookmarkModel> {
  final Value<int?> id;
  final Value<String?> bookName;
  final Value<String?> chapterName;
  final Value<String?> poemText;
  final Value<int?> chapterNumber;
  final Value<int?> bookNumber;
  final Value<String?> bookType;
  final Value<int?> poemNumber;
  final Value<DateTime?> date;
  const BookmarksCompanion({
    this.id = const Value.absent(),
    this.bookName = const Value.absent(),
    this.chapterName = const Value.absent(),
    this.poemText = const Value.absent(),
    this.chapterNumber = const Value.absent(),
    this.bookNumber = const Value.absent(),
    this.bookType = const Value.absent(),
    this.poemNumber = const Value.absent(),
    this.date = const Value.absent(),
  });
  BookmarksCompanion.insert({
    this.id = const Value.absent(),
    this.bookName = const Value.absent(),
    this.chapterName = const Value.absent(),
    this.poemText = const Value.absent(),
    this.chapterNumber = const Value.absent(),
    this.bookNumber = const Value.absent(),
    this.bookType = const Value.absent(),
    this.poemNumber = const Value.absent(),
    this.date = const Value.absent(),
  });
  static Insertable<BookmarkModel> custom({
    Expression<int>? id,
    Expression<String>? bookName,
    Expression<String>? chapterName,
    Expression<String>? poemText,
    Expression<int>? chapterNumber,
    Expression<int>? bookNumber,
    Expression<String>? bookType,
    Expression<int>? poemNumber,
    Expression<DateTime>? date,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bookName != null) 'book_name': bookName,
      if (chapterName != null) 'chapter_name': chapterName,
      if (poemText != null) 'poem_text': poemText,
      if (chapterNumber != null) 'chapter_number': chapterNumber,
      if (bookNumber != null) 'book_number': bookNumber,
      if (bookType != null) 'book_type': bookType,
      if (poemNumber != null) 'poem_number': poemNumber,
      if (date != null) 'date': date,
    });
  }

  BookmarksCompanion copyWith(
      {Value<int?>? id,
      Value<String?>? bookName,
      Value<String?>? chapterName,
      Value<String?>? poemText,
      Value<int?>? chapterNumber,
      Value<int?>? bookNumber,
      Value<String?>? bookType,
      Value<int?>? poemNumber,
      Value<DateTime?>? date}) {
    return BookmarksCompanion(
      id: id ?? this.id,
      bookName: bookName ?? this.bookName,
      chapterName: chapterName ?? this.chapterName,
      poemText: poemText ?? this.poemText,
      chapterNumber: chapterNumber ?? this.chapterNumber,
      bookNumber: bookNumber ?? this.bookNumber,
      bookType: bookType ?? this.bookType,
      poemNumber: poemNumber ?? this.poemNumber,
      date: date ?? this.date,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (bookName.present) {
      map['book_name'] = Variable<String>(bookName.value);
    }
    if (chapterName.present) {
      map['chapter_name'] = Variable<String>(chapterName.value);
    }
    if (poemText.present) {
      map['poem_text'] = Variable<String>(poemText.value);
    }
    if (chapterNumber.present) {
      map['chapter_number'] = Variable<int>(chapterNumber.value);
    }
    if (bookNumber.present) {
      map['book_number'] = Variable<int>(bookNumber.value);
    }
    if (bookType.present) {
      map['book_type'] = Variable<String>(bookType.value);
    }
    if (poemNumber.present) {
      map['poem_number'] = Variable<int>(poemNumber.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BookmarksCompanion(')
          ..write('id: $id, ')
          ..write('bookName: $bookName, ')
          ..write('chapterName: $chapterName, ')
          ..write('poemText: $poemText, ')
          ..write('chapterNumber: $chapterNumber, ')
          ..write('bookNumber: $bookNumber, ')
          ..write('bookType: $bookType, ')
          ..write('poemNumber: $poemNumber, ')
          ..write('date: $date')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $BookmarksTable bookmarks = $BookmarksTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [bookmarks];
}

typedef $$BookmarksTableCreateCompanionBuilder = BookmarksCompanion Function({
  Value<int?> id,
  Value<String?> bookName,
  Value<String?> chapterName,
  Value<String?> poemText,
  Value<int?> chapterNumber,
  Value<int?> bookNumber,
  Value<String?> bookType,
  Value<int?> poemNumber,
  Value<DateTime?> date,
});
typedef $$BookmarksTableUpdateCompanionBuilder = BookmarksCompanion Function({
  Value<int?> id,
  Value<String?> bookName,
  Value<String?> chapterName,
  Value<String?> poemText,
  Value<int?> chapterNumber,
  Value<int?> bookNumber,
  Value<String?> bookType,
  Value<int?> poemNumber,
  Value<DateTime?> date,
});

class $$BookmarksTableFilterComposer
    extends Composer<_$AppDatabase, $BookmarksTable> {
  $$BookmarksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bookName => $composableBuilder(
      column: $table.bookName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get chapterName => $composableBuilder(
      column: $table.chapterName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get poemText => $composableBuilder(
      column: $table.poemText, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get chapterNumber => $composableBuilder(
      column: $table.chapterNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get bookNumber => $composableBuilder(
      column: $table.bookNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bookType => $composableBuilder(
      column: $table.bookType, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get poemNumber => $composableBuilder(
      column: $table.poemNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));
}

class $$BookmarksTableOrderingComposer
    extends Composer<_$AppDatabase, $BookmarksTable> {
  $$BookmarksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bookName => $composableBuilder(
      column: $table.bookName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get chapterName => $composableBuilder(
      column: $table.chapterName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get poemText => $composableBuilder(
      column: $table.poemText, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get chapterNumber => $composableBuilder(
      column: $table.chapterNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get bookNumber => $composableBuilder(
      column: $table.bookNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bookType => $composableBuilder(
      column: $table.bookType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get poemNumber => $composableBuilder(
      column: $table.poemNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));
}

class $$BookmarksTableAnnotationComposer
    extends Composer<_$AppDatabase, $BookmarksTable> {
  $$BookmarksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get bookName =>
      $composableBuilder(column: $table.bookName, builder: (column) => column);

  GeneratedColumn<String> get chapterName => $composableBuilder(
      column: $table.chapterName, builder: (column) => column);

  GeneratedColumn<String> get poemText =>
      $composableBuilder(column: $table.poemText, builder: (column) => column);

  GeneratedColumn<int> get chapterNumber => $composableBuilder(
      column: $table.chapterNumber, builder: (column) => column);

  GeneratedColumn<int> get bookNumber => $composableBuilder(
      column: $table.bookNumber, builder: (column) => column);

  GeneratedColumn<String> get bookType =>
      $composableBuilder(column: $table.bookType, builder: (column) => column);

  GeneratedColumn<int> get poemNumber => $composableBuilder(
      column: $table.poemNumber, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);
}

class $$BookmarksTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BookmarksTable,
    BookmarkModel,
    $$BookmarksTableFilterComposer,
    $$BookmarksTableOrderingComposer,
    $$BookmarksTableAnnotationComposer,
    $$BookmarksTableCreateCompanionBuilder,
    $$BookmarksTableUpdateCompanionBuilder,
    (
      BookmarkModel,
      BaseReferences<_$AppDatabase, $BookmarksTable, BookmarkModel>
    ),
    BookmarkModel,
    PrefetchHooks Function()> {
  $$BookmarksTableTableManager(_$AppDatabase db, $BookmarksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BookmarksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BookmarksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BookmarksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int?> id = const Value.absent(),
            Value<String?> bookName = const Value.absent(),
            Value<String?> chapterName = const Value.absent(),
            Value<String?> poemText = const Value.absent(),
            Value<int?> chapterNumber = const Value.absent(),
            Value<int?> bookNumber = const Value.absent(),
            Value<String?> bookType = const Value.absent(),
            Value<int?> poemNumber = const Value.absent(),
            Value<DateTime?> date = const Value.absent(),
          }) =>
              BookmarksCompanion(
            id: id,
            bookName: bookName,
            chapterName: chapterName,
            poemText: poemText,
            chapterNumber: chapterNumber,
            bookNumber: bookNumber,
            bookType: bookType,
            poemNumber: poemNumber,
            date: date,
          ),
          createCompanionCallback: ({
            Value<int?> id = const Value.absent(),
            Value<String?> bookName = const Value.absent(),
            Value<String?> chapterName = const Value.absent(),
            Value<String?> poemText = const Value.absent(),
            Value<int?> chapterNumber = const Value.absent(),
            Value<int?> bookNumber = const Value.absent(),
            Value<String?> bookType = const Value.absent(),
            Value<int?> poemNumber = const Value.absent(),
            Value<DateTime?> date = const Value.absent(),
          }) =>
              BookmarksCompanion.insert(
            id: id,
            bookName: bookName,
            chapterName: chapterName,
            poemText: poemText,
            chapterNumber: chapterNumber,
            bookNumber: bookNumber,
            bookType: bookType,
            poemNumber: poemNumber,
            date: date,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$BookmarksTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BookmarksTable,
    BookmarkModel,
    $$BookmarksTableFilterComposer,
    $$BookmarksTableOrderingComposer,
    $$BookmarksTableAnnotationComposer,
    $$BookmarksTableCreateCompanionBuilder,
    $$BookmarksTableUpdateCompanionBuilder,
    (
      BookmarkModel,
      BaseReferences<_$AppDatabase, $BookmarksTable, BookmarkModel>
    ),
    BookmarkModel,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$BookmarksTableTableManager get bookmarks =>
      $$BookmarksTableTableManager(_db, _db.bookmarks);
}

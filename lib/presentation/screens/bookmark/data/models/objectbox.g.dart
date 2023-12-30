// GENERATED CODE - DO NOT MODIFY BY HAND
// This code was generated by ObjectBox. To update it run the generator again:
// With a Flutter package, run `flutter pub run build_runner build`.
// With a Dart package, run `dart run build_runner build`.
// See also https://docs.objectbox.io/getting-started#generate-objectbox-code

// ignore_for_file: camel_case_types, depend_on_referenced_packages
// coverage:ignore-file

import 'dart:typed_data';

import 'package:flat_buffers/flat_buffers.dart' as fb;
import 'package:objectbox/internal.dart'; // generated code can access "internal" functionality
import 'package:objectbox/objectbox.dart';
import 'package:objectbox_flutter_libs/objectbox_flutter_libs.dart';

import 'bookmarks_models.dart';

export 'package:objectbox/objectbox.dart'; // so that callers only have to import this file

final _entities = <ModelEntity>[
  ModelEntity(
      id: const IdUid(1, 2707594022700497880),
      name: 'BookmarkModel',
      lastPropertyId: const IdUid(6, 9038785900599313422),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 8154918382132883467),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 924141956585272061),
            name: 'bookName',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 3676506214505927617),
            name: 'chapterName',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 7243237338801334951),
            name: 'poemText',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 5871506908965403),
            name: 'chapterNumber',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 9038785900599313422),
            name: 'date',
            type: 10,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[])
];

/// Shortcut for [Store.new] that passes [getObjectBoxModel] and for Flutter
/// apps by default a [directory] using `defaultStoreDirectory()` from the
/// ObjectBox Flutter library.
///
/// Note: for desktop apps it is recommended to specify a unique [directory].
///
/// See [Store.new] for an explanation of all parameters.
Future<Store> openStore(
        {String? directory,
        int? maxDBSizeInKB,
        int? fileMode,
        int? maxReaders,
        bool queriesCaseSensitiveDefault = true,
        String? macosApplicationGroup}) async =>
    Store(getObjectBoxModel(),
        directory: directory ?? (await defaultStoreDirectory()).path,
        maxDBSizeInKB: maxDBSizeInKB,
        fileMode: fileMode,
        maxReaders: maxReaders,
        queriesCaseSensitiveDefault: queriesCaseSensitiveDefault,
        macosApplicationGroup: macosApplicationGroup);

/// Returns the ObjectBox model definition for this project for use with
/// [Store.new].
ModelDefinition getObjectBoxModel() {
  final model = ModelInfo(
      entities: _entities,
      lastEntityId: const IdUid(1, 2707594022700497880),
      lastIndexId: const IdUid(0, 0),
      lastRelationId: const IdUid(0, 0),
      lastSequenceId: const IdUid(0, 0),
      retiredEntityUids: const [],
      retiredIndexUids: const [],
      retiredPropertyUids: const [],
      retiredRelationUids: const [],
      modelVersion: 5,
      modelVersionParserMinimum: 5,
      version: 1);

  final bindings = <Type, EntityDefinition>{
    BookmarkModel: EntityDefinition<BookmarkModel>(
        model: _entities[0],
        toOneRelations: (BookmarkModel object) => [],
        toManyRelations: (BookmarkModel object) => {},
        getId: (BookmarkModel object) => object.id,
        setId: (BookmarkModel object, int id) {
          object.id = id;
        },
        objectToFB: (BookmarkModel object, fb.Builder fbb) {
          final bookNameOffset = object.bookName == null
              ? null
              : fbb.writeString(object.bookName!);
          final chapterNameOffset = object.chapterName == null
              ? null
              : fbb.writeString(object.chapterName!);
          final poemTextOffset = object.poemText == null
              ? null
              : fbb.writeString(object.poemText!);
          fbb.startTable(7);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, bookNameOffset);
          fbb.addOffset(2, chapterNameOffset);
          fbb.addOffset(3, poemTextOffset);
          fbb.addInt64(4, object.chapterNumber);
          fbb.addInt64(5, object.date?.millisecondsSinceEpoch);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);
          final dateValue =
              const fb.Int64Reader().vTableGetNullable(buffer, rootOffset, 14);
          final object = BookmarkModel()
            ..id = const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0)
            ..bookName = const fb.StringReader(asciiOptimization: true)
                .vTableGetNullable(buffer, rootOffset, 6)
            ..chapterName = const fb.StringReader(asciiOptimization: true)
                .vTableGetNullable(buffer, rootOffset, 8)
            ..poemText = const fb.StringReader(asciiOptimization: true)
                .vTableGetNullable(buffer, rootOffset, 10)
            ..chapterNumber =
                const fb.Int64Reader().vTableGetNullable(buffer, rootOffset, 12)
            ..date = dateValue == null
                ? null
                : DateTime.fromMillisecondsSinceEpoch(dateValue);

          return object;
        })
  };

  return ModelDefinition(model, bindings);
}

/// [BookmarkModel] entity fields to define ObjectBox queries.
class BookmarkModel_ {
  /// see [BookmarkModel.id]
  static final id =
      QueryIntegerProperty<BookmarkModel>(_entities[0].properties[0]);

  /// see [BookmarkModel.bookName]
  static final bookName =
      QueryStringProperty<BookmarkModel>(_entities[0].properties[1]);

  /// see [BookmarkModel.chapterName]
  static final chapterName =
      QueryStringProperty<BookmarkModel>(_entities[0].properties[2]);

  /// see [BookmarkModel.poemText]
  static final poemText =
      QueryStringProperty<BookmarkModel>(_entities[0].properties[3]);

  /// see [BookmarkModel.chapterNumber]
  static final chapterNumber =
      QueryIntegerProperty<BookmarkModel>(_entities[0].properties[4]);

  /// see [BookmarkModel.date]
  static final date =
      QueryIntegerProperty<BookmarkModel>(_entities[0].properties[5]);
}

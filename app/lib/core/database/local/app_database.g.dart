// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  DrinkDao? _drinkDaoInstance;

  RatingDao? _ratingDaoInstance;

  SyncQueueDao? _syncQueueDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `drinks` (`id` TEXT NOT NULL, `name` TEXT NOT NULL, `description` TEXT, `type` TEXT NOT NULL, `abv` REAL NOT NULL, `country` TEXT, `region` TEXT, `distillery` TEXT, `barcode` TEXT, `yearProduced` INTEGER, `price` REAL, `imageUrl` TEXT, `createdAt` INTEGER NOT NULL, `updatedAt` INTEGER NOT NULL, `lastSyncedAt` INTEGER, `isDeleted` INTEGER NOT NULL, `needsSync` INTEGER NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `ratings` (`id` TEXT NOT NULL, `drinkId` TEXT NOT NULL, `userId` TEXT NOT NULL, `overall` REAL NOT NULL, `nose` REAL, `taste` REAL, `finish` REAL, `notes` TEXT, `occasion` TEXT, `mood` TEXT, `location` TEXT, `createdAt` INTEGER NOT NULL, `updatedAt` INTEGER NOT NULL, `lastSyncedAt` INTEGER, `isDeleted` INTEGER NOT NULL, `needsSync` INTEGER NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `sync_queue` (`id` TEXT NOT NULL, `entityType` TEXT NOT NULL, `entityId` TEXT NOT NULL, `operation` TEXT NOT NULL, `payload` TEXT, `retryCount` INTEGER NOT NULL, `createdAt` INTEGER NOT NULL, `lastAttemptAt` INTEGER, `error` TEXT, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  DrinkDao get drinkDao {
    return _drinkDaoInstance ??= _$DrinkDao(database, changeListener);
  }

  @override
  RatingDao get ratingDao {
    return _ratingDaoInstance ??= _$RatingDao(database, changeListener);
  }

  @override
  SyncQueueDao get syncQueueDao {
    return _syncQueueDaoInstance ??= _$SyncQueueDao(database, changeListener);
  }
}

class _$DrinkDao extends DrinkDao {
  _$DrinkDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _drinkEntityInsertionAdapter = InsertionAdapter(
            database,
            'drinks',
            (DrinkEntity item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'description': item.description,
                  'type': item.type,
                  'abv': item.abv,
                  'country': item.country,
                  'region': item.region,
                  'distillery': item.distillery,
                  'barcode': item.barcode,
                  'yearProduced': item.yearProduced,
                  'price': item.price,
                  'imageUrl': item.imageUrl,
                  'createdAt': _dateTimeConverter.encode(item.createdAt),
                  'updatedAt': _dateTimeConverter.encode(item.updatedAt),
                  'lastSyncedAt':
                      _nullableDateTimeConverter.encode(item.lastSyncedAt),
                  'isDeleted': item.isDeleted ? 1 : 0,
                  'needsSync': item.needsSync ? 1 : 0
                }),
        _drinkEntityUpdateAdapter = UpdateAdapter(
            database,
            'drinks',
            ['id'],
            (DrinkEntity item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'description': item.description,
                  'type': item.type,
                  'abv': item.abv,
                  'country': item.country,
                  'region': item.region,
                  'distillery': item.distillery,
                  'barcode': item.barcode,
                  'yearProduced': item.yearProduced,
                  'price': item.price,
                  'imageUrl': item.imageUrl,
                  'createdAt': _dateTimeConverter.encode(item.createdAt),
                  'updatedAt': _dateTimeConverter.encode(item.updatedAt),
                  'lastSyncedAt':
                      _nullableDateTimeConverter.encode(item.lastSyncedAt),
                  'isDeleted': item.isDeleted ? 1 : 0,
                  'needsSync': item.needsSync ? 1 : 0
                }),
        _drinkEntityDeletionAdapter = DeletionAdapter(
            database,
            'drinks',
            ['id'],
            (DrinkEntity item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'description': item.description,
                  'type': item.type,
                  'abv': item.abv,
                  'country': item.country,
                  'region': item.region,
                  'distillery': item.distillery,
                  'barcode': item.barcode,
                  'yearProduced': item.yearProduced,
                  'price': item.price,
                  'imageUrl': item.imageUrl,
                  'createdAt': _dateTimeConverter.encode(item.createdAt),
                  'updatedAt': _dateTimeConverter.encode(item.updatedAt),
                  'lastSyncedAt':
                      _nullableDateTimeConverter.encode(item.lastSyncedAt),
                  'isDeleted': item.isDeleted ? 1 : 0,
                  'needsSync': item.needsSync ? 1 : 0
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<DrinkEntity> _drinkEntityInsertionAdapter;

  final UpdateAdapter<DrinkEntity> _drinkEntityUpdateAdapter;

  final DeletionAdapter<DrinkEntity> _drinkEntityDeletionAdapter;

  @override
  Future<List<DrinkEntity>> getAllDrinks() async {
    return _queryAdapter.queryList(
        'SELECT * FROM drinks WHERE isDeleted = 0 ORDER BY createdAt DESC',
        mapper: (Map<String, Object?> row) => DrinkEntity(
            id: row['id'] as String,
            name: row['name'] as String,
            description: row['description'] as String?,
            type: row['type'] as String,
            abv: row['abv'] as double,
            country: row['country'] as String?,
            region: row['region'] as String?,
            distillery: row['distillery'] as String?,
            barcode: row['barcode'] as String?,
            yearProduced: row['yearProduced'] as int?,
            price: row['price'] as double?,
            imageUrl: row['imageUrl'] as String?,
            createdAt: _dateTimeConverter.decode(row['createdAt'] as int),
            updatedAt: _dateTimeConverter.decode(row['updatedAt'] as int),
            lastSyncedAt:
                _nullableDateTimeConverter.decode(row['lastSyncedAt'] as int?),
            isDeleted: (row['isDeleted'] as int) != 0,
            needsSync: (row['needsSync'] as int) != 0));
  }

  @override
  Future<DrinkEntity?> getDrinkById(String id) async {
    return _queryAdapter.query(
        'SELECT * FROM drinks WHERE id = ?1 AND isDeleted = 0',
        mapper: (Map<String, Object?> row) => DrinkEntity(
            id: row['id'] as String,
            name: row['name'] as String,
            description: row['description'] as String?,
            type: row['type'] as String,
            abv: row['abv'] as double,
            country: row['country'] as String?,
            region: row['region'] as String?,
            distillery: row['distillery'] as String?,
            barcode: row['barcode'] as String?,
            yearProduced: row['yearProduced'] as int?,
            price: row['price'] as double?,
            imageUrl: row['imageUrl'] as String?,
            createdAt: _dateTimeConverter.decode(row['createdAt'] as int),
            updatedAt: _dateTimeConverter.decode(row['updatedAt'] as int),
            lastSyncedAt:
                _nullableDateTimeConverter.decode(row['lastSyncedAt'] as int?),
            isDeleted: (row['isDeleted'] as int) != 0,
            needsSync: (row['needsSync'] as int) != 0),
        arguments: [id]);
  }

  @override
  Future<DrinkEntity?> getDrinkByBarcode(String barcode) async {
    return _queryAdapter.query(
        'SELECT * FROM drinks WHERE barcode = ?1 AND isDeleted = 0',
        mapper: (Map<String, Object?> row) => DrinkEntity(
            id: row['id'] as String,
            name: row['name'] as String,
            description: row['description'] as String?,
            type: row['type'] as String,
            abv: row['abv'] as double,
            country: row['country'] as String?,
            region: row['region'] as String?,
            distillery: row['distillery'] as String?,
            barcode: row['barcode'] as String?,
            yearProduced: row['yearProduced'] as int?,
            price: row['price'] as double?,
            imageUrl: row['imageUrl'] as String?,
            createdAt: _dateTimeConverter.decode(row['createdAt'] as int),
            updatedAt: _dateTimeConverter.decode(row['updatedAt'] as int),
            lastSyncedAt:
                _nullableDateTimeConverter.decode(row['lastSyncedAt'] as int?),
            isDeleted: (row['isDeleted'] as int) != 0,
            needsSync: (row['needsSync'] as int) != 0),
        arguments: [barcode]);
  }

  @override
  Future<List<DrinkEntity>> searchDrinks(String searchTerm) async {
    return _queryAdapter.queryList(
        'SELECT * FROM drinks      WHERE isDeleted = 0      AND (       name LIKE ?1        OR description LIKE ?1        OR country LIKE ?1       OR distillery LIKE ?1     )     ORDER BY createdAt DESC',
        mapper: (Map<String, Object?> row) => DrinkEntity(id: row['id'] as String, name: row['name'] as String, description: row['description'] as String?, type: row['type'] as String, abv: row['abv'] as double, country: row['country'] as String?, region: row['region'] as String?, distillery: row['distillery'] as String?, barcode: row['barcode'] as String?, yearProduced: row['yearProduced'] as int?, price: row['price'] as double?, imageUrl: row['imageUrl'] as String?, createdAt: _dateTimeConverter.decode(row['createdAt'] as int), updatedAt: _dateTimeConverter.decode(row['updatedAt'] as int), lastSyncedAt: _nullableDateTimeConverter.decode(row['lastSyncedAt'] as int?), isDeleted: (row['isDeleted'] as int) != 0, needsSync: (row['needsSync'] as int) != 0),
        arguments: [searchTerm]);
  }

  @override
  Future<List<DrinkEntity>> getDrinksByType(String type) async {
    return _queryAdapter.queryList(
        'SELECT * FROM drinks WHERE type = ?1 AND isDeleted = 0 ORDER BY name ASC',
        mapper: (Map<String, Object?> row) => DrinkEntity(id: row['id'] as String, name: row['name'] as String, description: row['description'] as String?, type: row['type'] as String, abv: row['abv'] as double, country: row['country'] as String?, region: row['region'] as String?, distillery: row['distillery'] as String?, barcode: row['barcode'] as String?, yearProduced: row['yearProduced'] as int?, price: row['price'] as double?, imageUrl: row['imageUrl'] as String?, createdAt: _dateTimeConverter.decode(row['createdAt'] as int), updatedAt: _dateTimeConverter.decode(row['updatedAt'] as int), lastSyncedAt: _nullableDateTimeConverter.decode(row['lastSyncedAt'] as int?), isDeleted: (row['isDeleted'] as int) != 0, needsSync: (row['needsSync'] as int) != 0),
        arguments: [type]);
  }

  @override
  Future<List<DrinkEntity>> getDrinksByCountry(String country) async {
    return _queryAdapter.queryList(
        'SELECT * FROM drinks WHERE country = ?1 AND isDeleted = 0 ORDER BY name ASC',
        mapper: (Map<String, Object?> row) => DrinkEntity(id: row['id'] as String, name: row['name'] as String, description: row['description'] as String?, type: row['type'] as String, abv: row['abv'] as double, country: row['country'] as String?, region: row['region'] as String?, distillery: row['distillery'] as String?, barcode: row['barcode'] as String?, yearProduced: row['yearProduced'] as int?, price: row['price'] as double?, imageUrl: row['imageUrl'] as String?, createdAt: _dateTimeConverter.decode(row['createdAt'] as int), updatedAt: _dateTimeConverter.decode(row['updatedAt'] as int), lastSyncedAt: _nullableDateTimeConverter.decode(row['lastSyncedAt'] as int?), isDeleted: (row['isDeleted'] as int) != 0, needsSync: (row['needsSync'] as int) != 0),
        arguments: [country]);
  }

  @override
  Future<List<DrinkEntity>> getDrinksNeedingSync() async {
    return _queryAdapter.queryList('SELECT * FROM drinks WHERE needsSync = 1',
        mapper: (Map<String, Object?> row) => DrinkEntity(
            id: row['id'] as String,
            name: row['name'] as String,
            description: row['description'] as String?,
            type: row['type'] as String,
            abv: row['abv'] as double,
            country: row['country'] as String?,
            region: row['region'] as String?,
            distillery: row['distillery'] as String?,
            barcode: row['barcode'] as String?,
            yearProduced: row['yearProduced'] as int?,
            price: row['price'] as double?,
            imageUrl: row['imageUrl'] as String?,
            createdAt: _dateTimeConverter.decode(row['createdAt'] as int),
            updatedAt: _dateTimeConverter.decode(row['updatedAt'] as int),
            lastSyncedAt:
                _nullableDateTimeConverter.decode(row['lastSyncedAt'] as int?),
            isDeleted: (row['isDeleted'] as int) != 0,
            needsSync: (row['needsSync'] as int) != 0));
  }

  @override
  Future<List<DrinkEntity>> getDrinksNotSyncedSince(DateTime since) async {
    return _queryAdapter.queryList(
        'SELECT * FROM drinks WHERE lastSyncedAt IS NULL OR lastSyncedAt < ?1',
        mapper: (Map<String, Object?> row) => DrinkEntity(
            id: row['id'] as String,
            name: row['name'] as String,
            description: row['description'] as String?,
            type: row['type'] as String,
            abv: row['abv'] as double,
            country: row['country'] as String?,
            region: row['region'] as String?,
            distillery: row['distillery'] as String?,
            barcode: row['barcode'] as String?,
            yearProduced: row['yearProduced'] as int?,
            price: row['price'] as double?,
            imageUrl: row['imageUrl'] as String?,
            createdAt: _dateTimeConverter.decode(row['createdAt'] as int),
            updatedAt: _dateTimeConverter.decode(row['updatedAt'] as int),
            lastSyncedAt:
                _nullableDateTimeConverter.decode(row['lastSyncedAt'] as int?),
            isDeleted: (row['isDeleted'] as int) != 0,
            needsSync: (row['needsSync'] as int) != 0),
        arguments: [_dateTimeConverter.encode(since)]);
  }

  @override
  Future<List<String>> getDistinctTypes() async {
    return _queryAdapter.queryList(
        'SELECT DISTINCT type FROM drinks WHERE isDeleted = 0 ORDER BY type ASC',
        mapper: (Map<String, Object?> row) => row.values.first as String);
  }

  @override
  Future<List<String>> getDistinctCountries() async {
    return _queryAdapter.queryList(
        'SELECT DISTINCT country FROM drinks WHERE isDeleted = 0 AND country IS NOT NULL ORDER BY country ASC',
        mapper: (Map<String, Object?> row) => row.values.first as String);
  }

  @override
  Future<int?> getDrinksCount() async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM drinks WHERE isDeleted = 0',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<int?> getDrinksCountByType(String type) async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM drinks WHERE type = ?1 AND isDeleted = 0',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [type]);
  }

  @override
  Future<void> softDeleteDrink(
    String id,
    DateTime deletedAt,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE drinks SET isDeleted = 1, needsSync = 1, updatedAt = ?2 WHERE id = ?1',
        arguments: [id, _dateTimeConverter.encode(deletedAt)]);
  }

  @override
  Future<void> markDrinkSynced(
    String id,
    DateTime syncedAt,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE drinks SET needsSync = 0, lastSyncedAt = ?2 WHERE id = ?1',
        arguments: [id, _dateTimeConverter.encode(syncedAt)]);
  }

  @override
  Future<void> markDrinkNeedsSync(
    String id,
    DateTime updatedAt,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE drinks SET needsSync = 1, updatedAt = ?2 WHERE id = ?1',
        arguments: [id, _dateTimeConverter.encode(updatedAt)]);
  }

  @override
  Future<void> cleanupDeletedDrinks(DateTime before) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM drinks WHERE isDeleted = 1 AND lastSyncedAt IS NOT NULL AND lastSyncedAt < ?1',
        arguments: [_dateTimeConverter.encode(before)]);
  }

  @override
  Future<List<DrinkEntity>> getDrinksWithLimit(
    int limit,
    int offset,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM drinks WHERE isDeleted = 0 ORDER BY createdAt DESC LIMIT ?1 OFFSET ?2',
        mapper: (Map<String, Object?> row) => DrinkEntity(id: row['id'] as String, name: row['name'] as String, description: row['description'] as String?, type: row['type'] as String, abv: row['abv'] as double, country: row['country'] as String?, region: row['region'] as String?, distillery: row['distillery'] as String?, barcode: row['barcode'] as String?, yearProduced: row['yearProduced'] as int?, price: row['price'] as double?, imageUrl: row['imageUrl'] as String?, createdAt: _dateTimeConverter.decode(row['createdAt'] as int), updatedAt: _dateTimeConverter.decode(row['updatedAt'] as int), lastSyncedAt: _nullableDateTimeConverter.decode(row['lastSyncedAt'] as int?), isDeleted: (row['isDeleted'] as int) != 0, needsSync: (row['needsSync'] as int) != 0),
        arguments: [limit, offset]);
  }

  @override
  Future<List<DrinkEntity>> getDrinksWithTypeFilter(
    String type,
    int limit,
    int offset,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM drinks WHERE isDeleted = 0 AND type = ?1 ORDER BY createdAt DESC LIMIT ?2 OFFSET ?3',
        mapper: (Map<String, Object?> row) => DrinkEntity(id: row['id'] as String, name: row['name'] as String, description: row['description'] as String?, type: row['type'] as String, abv: row['abv'] as double, country: row['country'] as String?, region: row['region'] as String?, distillery: row['distillery'] as String?, barcode: row['barcode'] as String?, yearProduced: row['yearProduced'] as int?, price: row['price'] as double?, imageUrl: row['imageUrl'] as String?, createdAt: _dateTimeConverter.decode(row['createdAt'] as int), updatedAt: _dateTimeConverter.decode(row['updatedAt'] as int), lastSyncedAt: _nullableDateTimeConverter.decode(row['lastSyncedAt'] as int?), isDeleted: (row['isDeleted'] as int) != 0, needsSync: (row['needsSync'] as int) != 0),
        arguments: [type, limit, offset]);
  }

  @override
  Future<List<DrinkEntity>> getDrinksWithCountryFilter(
    String country,
    int limit,
    int offset,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM drinks WHERE isDeleted = 0 AND country = ?1 ORDER BY createdAt DESC LIMIT ?2 OFFSET ?3',
        mapper: (Map<String, Object?> row) => DrinkEntity(id: row['id'] as String, name: row['name'] as String, description: row['description'] as String?, type: row['type'] as String, abv: row['abv'] as double, country: row['country'] as String?, region: row['region'] as String?, distillery: row['distillery'] as String?, barcode: row['barcode'] as String?, yearProduced: row['yearProduced'] as int?, price: row['price'] as double?, imageUrl: row['imageUrl'] as String?, createdAt: _dateTimeConverter.decode(row['createdAt'] as int), updatedAt: _dateTimeConverter.decode(row['updatedAt'] as int), lastSyncedAt: _nullableDateTimeConverter.decode(row['lastSyncedAt'] as int?), isDeleted: (row['isDeleted'] as int) != 0, needsSync: (row['needsSync'] as int) != 0),
        arguments: [country, limit, offset]);
  }

  @override
  Future<List<DrinkEntity>> getDrinksWithAbvFilter(
    double minAbv,
    double maxAbv,
    int limit,
    int offset,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM drinks WHERE isDeleted = 0 AND abv >= ?1 AND abv <= ?2 ORDER BY createdAt DESC LIMIT ?3 OFFSET ?4',
        mapper: (Map<String, Object?> row) => DrinkEntity(id: row['id'] as String, name: row['name'] as String, description: row['description'] as String?, type: row['type'] as String, abv: row['abv'] as double, country: row['country'] as String?, region: row['region'] as String?, distillery: row['distillery'] as String?, barcode: row['barcode'] as String?, yearProduced: row['yearProduced'] as int?, price: row['price'] as double?, imageUrl: row['imageUrl'] as String?, createdAt: _dateTimeConverter.decode(row['createdAt'] as int), updatedAt: _dateTimeConverter.decode(row['updatedAt'] as int), lastSyncedAt: _nullableDateTimeConverter.decode(row['lastSyncedAt'] as int?), isDeleted: (row['isDeleted'] as int) != 0, needsSync: (row['needsSync'] as int) != 0),
        arguments: [minAbv, maxAbv, limit, offset]);
  }

  @override
  Future<void> insertDrink(DrinkEntity drink) async {
    await _drinkEntityInsertionAdapter.insert(drink, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertDrinks(List<DrinkEntity> drinks) async {
    await _drinkEntityInsertionAdapter.insertList(
        drinks, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateDrink(DrinkEntity drink) async {
    await _drinkEntityUpdateAdapter.update(drink, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateDrinks(List<DrinkEntity> drinks) async {
    await _drinkEntityUpdateAdapter.updateList(
        drinks, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteDrink(DrinkEntity drink) async {
    await _drinkEntityDeletionAdapter.delete(drink);
  }
}

class _$RatingDao extends RatingDao {
  _$RatingDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _ratingEntityInsertionAdapter = InsertionAdapter(
            database,
            'ratings',
            (RatingEntity item) => <String, Object?>{
                  'id': item.id,
                  'drinkId': item.drinkId,
                  'userId': item.userId,
                  'overall': item.overall,
                  'nose': item.nose,
                  'taste': item.taste,
                  'finish': item.finish,
                  'notes': item.notes,
                  'occasion': item.occasion,
                  'mood': item.mood,
                  'location': item.location,
                  'createdAt': _dateTimeConverter.encode(item.createdAt),
                  'updatedAt': _dateTimeConverter.encode(item.updatedAt),
                  'lastSyncedAt':
                      _nullableDateTimeConverter.encode(item.lastSyncedAt),
                  'isDeleted': item.isDeleted ? 1 : 0,
                  'needsSync': item.needsSync ? 1 : 0
                }),
        _ratingEntityUpdateAdapter = UpdateAdapter(
            database,
            'ratings',
            ['id'],
            (RatingEntity item) => <String, Object?>{
                  'id': item.id,
                  'drinkId': item.drinkId,
                  'userId': item.userId,
                  'overall': item.overall,
                  'nose': item.nose,
                  'taste': item.taste,
                  'finish': item.finish,
                  'notes': item.notes,
                  'occasion': item.occasion,
                  'mood': item.mood,
                  'location': item.location,
                  'createdAt': _dateTimeConverter.encode(item.createdAt),
                  'updatedAt': _dateTimeConverter.encode(item.updatedAt),
                  'lastSyncedAt':
                      _nullableDateTimeConverter.encode(item.lastSyncedAt),
                  'isDeleted': item.isDeleted ? 1 : 0,
                  'needsSync': item.needsSync ? 1 : 0
                }),
        _ratingEntityDeletionAdapter = DeletionAdapter(
            database,
            'ratings',
            ['id'],
            (RatingEntity item) => <String, Object?>{
                  'id': item.id,
                  'drinkId': item.drinkId,
                  'userId': item.userId,
                  'overall': item.overall,
                  'nose': item.nose,
                  'taste': item.taste,
                  'finish': item.finish,
                  'notes': item.notes,
                  'occasion': item.occasion,
                  'mood': item.mood,
                  'location': item.location,
                  'createdAt': _dateTimeConverter.encode(item.createdAt),
                  'updatedAt': _dateTimeConverter.encode(item.updatedAt),
                  'lastSyncedAt':
                      _nullableDateTimeConverter.encode(item.lastSyncedAt),
                  'isDeleted': item.isDeleted ? 1 : 0,
                  'needsSync': item.needsSync ? 1 : 0
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<RatingEntity> _ratingEntityInsertionAdapter;

  final UpdateAdapter<RatingEntity> _ratingEntityUpdateAdapter;

  final DeletionAdapter<RatingEntity> _ratingEntityDeletionAdapter;

  @override
  Future<List<RatingEntity>> getAllRatings() async {
    return _queryAdapter.queryList(
        'SELECT * FROM ratings WHERE isDeleted = 0 ORDER BY createdAt DESC',
        mapper: (Map<String, Object?> row) => RatingEntity(
            id: row['id'] as String,
            drinkId: row['drinkId'] as String,
            userId: row['userId'] as String,
            overall: row['overall'] as double,
            nose: row['nose'] as double?,
            taste: row['taste'] as double?,
            finish: row['finish'] as double?,
            notes: row['notes'] as String?,
            occasion: row['occasion'] as String?,
            mood: row['mood'] as String?,
            location: row['location'] as String?,
            createdAt: _dateTimeConverter.decode(row['createdAt'] as int),
            updatedAt: _dateTimeConverter.decode(row['updatedAt'] as int),
            lastSyncedAt:
                _nullableDateTimeConverter.decode(row['lastSyncedAt'] as int?),
            isDeleted: (row['isDeleted'] as int) != 0,
            needsSync: (row['needsSync'] as int) != 0));
  }

  @override
  Future<RatingEntity?> getRatingById(String id) async {
    return _queryAdapter.query(
        'SELECT * FROM ratings WHERE id = ?1 AND isDeleted = 0',
        mapper: (Map<String, Object?> row) => RatingEntity(
            id: row['id'] as String,
            drinkId: row['drinkId'] as String,
            userId: row['userId'] as String,
            overall: row['overall'] as double,
            nose: row['nose'] as double?,
            taste: row['taste'] as double?,
            finish: row['finish'] as double?,
            notes: row['notes'] as String?,
            occasion: row['occasion'] as String?,
            mood: row['mood'] as String?,
            location: row['location'] as String?,
            createdAt: _dateTimeConverter.decode(row['createdAt'] as int),
            updatedAt: _dateTimeConverter.decode(row['updatedAt'] as int),
            lastSyncedAt:
                _nullableDateTimeConverter.decode(row['lastSyncedAt'] as int?),
            isDeleted: (row['isDeleted'] as int) != 0,
            needsSync: (row['needsSync'] as int) != 0),
        arguments: [id]);
  }

  @override
  Future<List<RatingEntity>> getRatingsByDrinkId(String drinkId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM ratings WHERE drinkId = ?1 AND isDeleted = 0 ORDER BY createdAt DESC',
        mapper: (Map<String, Object?> row) => RatingEntity(id: row['id'] as String, drinkId: row['drinkId'] as String, userId: row['userId'] as String, overall: row['overall'] as double, nose: row['nose'] as double?, taste: row['taste'] as double?, finish: row['finish'] as double?, notes: row['notes'] as String?, occasion: row['occasion'] as String?, mood: row['mood'] as String?, location: row['location'] as String?, createdAt: _dateTimeConverter.decode(row['createdAt'] as int), updatedAt: _dateTimeConverter.decode(row['updatedAt'] as int), lastSyncedAt: _nullableDateTimeConverter.decode(row['lastSyncedAt'] as int?), isDeleted: (row['isDeleted'] as int) != 0, needsSync: (row['needsSync'] as int) != 0),
        arguments: [drinkId]);
  }

  @override
  Future<List<RatingEntity>> getRatingsByUserId(String userId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM ratings WHERE userId = ?1 AND isDeleted = 0 ORDER BY createdAt DESC',
        mapper: (Map<String, Object?> row) => RatingEntity(id: row['id'] as String, drinkId: row['drinkId'] as String, userId: row['userId'] as String, overall: row['overall'] as double, nose: row['nose'] as double?, taste: row['taste'] as double?, finish: row['finish'] as double?, notes: row['notes'] as String?, occasion: row['occasion'] as String?, mood: row['mood'] as String?, location: row['location'] as String?, createdAt: _dateTimeConverter.decode(row['createdAt'] as int), updatedAt: _dateTimeConverter.decode(row['updatedAt'] as int), lastSyncedAt: _nullableDateTimeConverter.decode(row['lastSyncedAt'] as int?), isDeleted: (row['isDeleted'] as int) != 0, needsSync: (row['needsSync'] as int) != 0),
        arguments: [userId]);
  }

  @override
  Future<RatingEntity?> getUserRatingForDrink(
    String drinkId,
    String userId,
  ) async {
    return _queryAdapter.query(
        'SELECT * FROM ratings WHERE drinkId = ?1 AND userId = ?2 AND isDeleted = 0',
        mapper: (Map<String, Object?> row) => RatingEntity(id: row['id'] as String, drinkId: row['drinkId'] as String, userId: row['userId'] as String, overall: row['overall'] as double, nose: row['nose'] as double?, taste: row['taste'] as double?, finish: row['finish'] as double?, notes: row['notes'] as String?, occasion: row['occasion'] as String?, mood: row['mood'] as String?, location: row['location'] as String?, createdAt: _dateTimeConverter.decode(row['createdAt'] as int), updatedAt: _dateTimeConverter.decode(row['updatedAt'] as int), lastSyncedAt: _nullableDateTimeConverter.decode(row['lastSyncedAt'] as int?), isDeleted: (row['isDeleted'] as int) != 0, needsSync: (row['needsSync'] as int) != 0),
        arguments: [drinkId, userId]);
  }

  @override
  Future<List<RatingEntity>> getRatingsNeedingSync() async {
    return _queryAdapter.queryList('SELECT * FROM ratings WHERE needsSync = 1',
        mapper: (Map<String, Object?> row) => RatingEntity(
            id: row['id'] as String,
            drinkId: row['drinkId'] as String,
            userId: row['userId'] as String,
            overall: row['overall'] as double,
            nose: row['nose'] as double?,
            taste: row['taste'] as double?,
            finish: row['finish'] as double?,
            notes: row['notes'] as String?,
            occasion: row['occasion'] as String?,
            mood: row['mood'] as String?,
            location: row['location'] as String?,
            createdAt: _dateTimeConverter.decode(row['createdAt'] as int),
            updatedAt: _dateTimeConverter.decode(row['updatedAt'] as int),
            lastSyncedAt:
                _nullableDateTimeConverter.decode(row['lastSyncedAt'] as int?),
            isDeleted: (row['isDeleted'] as int) != 0,
            needsSync: (row['needsSync'] as int) != 0));
  }

  @override
  Future<List<RatingEntity>> getRatingsNotSyncedSince(DateTime since) async {
    return _queryAdapter.queryList(
        'SELECT * FROM ratings WHERE lastSyncedAt IS NULL OR lastSyncedAt < ?1',
        mapper: (Map<String, Object?> row) => RatingEntity(
            id: row['id'] as String,
            drinkId: row['drinkId'] as String,
            userId: row['userId'] as String,
            overall: row['overall'] as double,
            nose: row['nose'] as double?,
            taste: row['taste'] as double?,
            finish: row['finish'] as double?,
            notes: row['notes'] as String?,
            occasion: row['occasion'] as String?,
            mood: row['mood'] as String?,
            location: row['location'] as String?,
            createdAt: _dateTimeConverter.decode(row['createdAt'] as int),
            updatedAt: _dateTimeConverter.decode(row['updatedAt'] as int),
            lastSyncedAt:
                _nullableDateTimeConverter.decode(row['lastSyncedAt'] as int?),
            isDeleted: (row['isDeleted'] as int) != 0,
            needsSync: (row['needsSync'] as int) != 0),
        arguments: [_dateTimeConverter.encode(since)]);
  }

  @override
  Future<double?> getAverageRatingForDrink(String drinkId) async {
    return _queryAdapter.query(
        'SELECT AVG(overall) FROM ratings WHERE drinkId = ?1 AND isDeleted = 0',
        mapper: (Map<String, Object?> row) => row.values.first as double,
        arguments: [drinkId]);
  }

  @override
  Future<int?> getRatingCountForDrink(String drinkId) async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM ratings WHERE drinkId = ?1 AND isDeleted = 0',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [drinkId]);
  }

  @override
  Future<int?> getRatingCountForUser(String userId) async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM ratings WHERE userId = ?1 AND isDeleted = 0',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [userId]);
  }

  @override
  Future<List<RatingEntity>> getUserRatingsInDateRange(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM ratings      WHERE userId = ?1 AND isDeleted = 0      AND createdAt >= ?2 AND createdAt <= ?3     ORDER BY createdAt DESC',
        mapper: (Map<String, Object?> row) => RatingEntity(id: row['id'] as String, drinkId: row['drinkId'] as String, userId: row['userId'] as String, overall: row['overall'] as double, nose: row['nose'] as double?, taste: row['taste'] as double?, finish: row['finish'] as double?, notes: row['notes'] as String?, occasion: row['occasion'] as String?, mood: row['mood'] as String?, location: row['location'] as String?, createdAt: _dateTimeConverter.decode(row['createdAt'] as int), updatedAt: _dateTimeConverter.decode(row['updatedAt'] as int), lastSyncedAt: _nullableDateTimeConverter.decode(row['lastSyncedAt'] as int?), isDeleted: (row['isDeleted'] as int) != 0, needsSync: (row['needsSync'] as int) != 0),
        arguments: [
          userId,
          _dateTimeConverter.encode(startDate),
          _dateTimeConverter.encode(endDate)
        ]);
  }

  @override
  Future<double?> getAverageRatingForUser(String userId) async {
    return _queryAdapter.query(
        'SELECT AVG(overall) FROM ratings      WHERE userId = ?1 AND isDeleted = 0',
        mapper: (Map<String, Object?> row) => row.values.first as double,
        arguments: [userId]);
  }

  @override
  Future<List<RatingEntity>> getTopRatedByUser(
    String userId,
    double minRating,
    int limit,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM ratings      WHERE userId = ?1 AND isDeleted = 0     AND overall >= ?2     ORDER BY overall DESC, createdAt DESC     LIMIT ?3',
        mapper: (Map<String, Object?> row) => RatingEntity(id: row['id'] as String, drinkId: row['drinkId'] as String, userId: row['userId'] as String, overall: row['overall'] as double, nose: row['nose'] as double?, taste: row['taste'] as double?, finish: row['finish'] as double?, notes: row['notes'] as String?, occasion: row['occasion'] as String?, mood: row['mood'] as String?, location: row['location'] as String?, createdAt: _dateTimeConverter.decode(row['createdAt'] as int), updatedAt: _dateTimeConverter.decode(row['updatedAt'] as int), lastSyncedAt: _nullableDateTimeConverter.decode(row['lastSyncedAt'] as int?), isDeleted: (row['isDeleted'] as int) != 0, needsSync: (row['needsSync'] as int) != 0),
        arguments: [userId, minRating, limit]);
  }

  @override
  Future<List<RatingEntity>> getRecentRatingsByUser(
    String userId,
    int limit,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM ratings      WHERE userId = ?1 AND isDeleted = 0     ORDER BY createdAt DESC     LIMIT ?2',
        mapper: (Map<String, Object?> row) => RatingEntity(id: row['id'] as String, drinkId: row['drinkId'] as String, userId: row['userId'] as String, overall: row['overall'] as double, nose: row['nose'] as double?, taste: row['taste'] as double?, finish: row['finish'] as double?, notes: row['notes'] as String?, occasion: row['occasion'] as String?, mood: row['mood'] as String?, location: row['location'] as String?, createdAt: _dateTimeConverter.decode(row['createdAt'] as int), updatedAt: _dateTimeConverter.decode(row['updatedAt'] as int), lastSyncedAt: _nullableDateTimeConverter.decode(row['lastSyncedAt'] as int?), isDeleted: (row['isDeleted'] as int) != 0, needsSync: (row['needsSync'] as int) != 0),
        arguments: [userId, limit]);
  }

  @override
  Future<void> softDeleteRating(
    String id,
    DateTime deletedAt,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE ratings SET isDeleted = 1, needsSync = 1, updatedAt = ?2 WHERE id = ?1',
        arguments: [id, _dateTimeConverter.encode(deletedAt)]);
  }

  @override
  Future<void> markRatingSynced(
    String id,
    DateTime syncedAt,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE ratings SET needsSync = 0, lastSyncedAt = ?2 WHERE id = ?1',
        arguments: [id, _dateTimeConverter.encode(syncedAt)]);
  }

  @override
  Future<void> markRatingNeedsSync(
    String id,
    DateTime updatedAt,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE ratings SET needsSync = 1, updatedAt = ?2 WHERE id = ?1',
        arguments: [id, _dateTimeConverter.encode(updatedAt)]);
  }

  @override
  Future<void> cleanupDeletedRatings(DateTime before) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM ratings WHERE isDeleted = 1 AND lastSyncedAt IS NOT NULL AND lastSyncedAt < ?1',
        arguments: [_dateTimeConverter.encode(before)]);
  }

  @override
  Future<int?> getUserRatingCount(String userId) async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM ratings WHERE userId = ?1 AND isDeleted = 0',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [userId]);
  }

  @override
  Future<double?> getUserAverageRating(String userId) async {
    return _queryAdapter.query(
        'SELECT AVG(overall) FROM ratings WHERE userId = ?1 AND isDeleted = 0',
        mapper: (Map<String, Object?> row) => row.values.first as double,
        arguments: [userId]);
  }

  @override
  Future<double?> getUserMinRating(String userId) async {
    return _queryAdapter.query(
        'SELECT MIN(overall) FROM ratings WHERE userId = ?1 AND isDeleted = 0',
        mapper: (Map<String, Object?> row) => row.values.first as double,
        arguments: [userId]);
  }

  @override
  Future<double?> getUserMaxRating(String userId) async {
    return _queryAdapter.query(
        'SELECT MAX(overall) FROM ratings WHERE userId = ?1 AND isDeleted = 0',
        mapper: (Map<String, Object?> row) => row.values.first as double,
        arguments: [userId]);
  }

  @override
  Future<int?> getDrinkRatingCount(String drinkId) async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM ratings WHERE drinkId = ?1 AND isDeleted = 0',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [drinkId]);
  }

  @override
  Future<void> insertRating(RatingEntity rating) async {
    await _ratingEntityInsertionAdapter.insert(
        rating, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertRatings(List<RatingEntity> ratings) async {
    await _ratingEntityInsertionAdapter.insertList(
        ratings, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateRating(RatingEntity rating) async {
    await _ratingEntityUpdateAdapter.update(rating, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateRatings(List<RatingEntity> ratings) async {
    await _ratingEntityUpdateAdapter.updateList(
        ratings, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteRating(RatingEntity rating) async {
    await _ratingEntityDeletionAdapter.delete(rating);
  }
}

class _$SyncQueueDao extends SyncQueueDao {
  _$SyncQueueDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _syncQueueEntityInsertionAdapter = InsertionAdapter(
            database,
            'sync_queue',
            (SyncQueueEntity item) => <String, Object?>{
                  'id': item.id,
                  'entityType': item.entityType,
                  'entityId': item.entityId,
                  'operation': item.operation,
                  'payload': item.payload,
                  'retryCount': item.retryCount,
                  'createdAt': _dateTimeConverter.encode(item.createdAt),
                  'lastAttemptAt':
                      _nullableDateTimeConverter.encode(item.lastAttemptAt),
                  'error': item.error
                }),
        _syncQueueEntityUpdateAdapter = UpdateAdapter(
            database,
            'sync_queue',
            ['id'],
            (SyncQueueEntity item) => <String, Object?>{
                  'id': item.id,
                  'entityType': item.entityType,
                  'entityId': item.entityId,
                  'operation': item.operation,
                  'payload': item.payload,
                  'retryCount': item.retryCount,
                  'createdAt': _dateTimeConverter.encode(item.createdAt),
                  'lastAttemptAt':
                      _nullableDateTimeConverter.encode(item.lastAttemptAt),
                  'error': item.error
                }),
        _syncQueueEntityDeletionAdapter = DeletionAdapter(
            database,
            'sync_queue',
            ['id'],
            (SyncQueueEntity item) => <String, Object?>{
                  'id': item.id,
                  'entityType': item.entityType,
                  'entityId': item.entityId,
                  'operation': item.operation,
                  'payload': item.payload,
                  'retryCount': item.retryCount,
                  'createdAt': _dateTimeConverter.encode(item.createdAt),
                  'lastAttemptAt':
                      _nullableDateTimeConverter.encode(item.lastAttemptAt),
                  'error': item.error
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<SyncQueueEntity> _syncQueueEntityInsertionAdapter;

  final UpdateAdapter<SyncQueueEntity> _syncQueueEntityUpdateAdapter;

  final DeletionAdapter<SyncQueueEntity> _syncQueueEntityDeletionAdapter;

  @override
  Future<List<SyncQueueEntity>> getAllPendingSyncs() async {
    return _queryAdapter.queryList(
        'SELECT * FROM sync_queue ORDER BY createdAt ASC',
        mapper: (Map<String, Object?> row) => SyncQueueEntity(
            id: row['id'] as String,
            entityType: row['entityType'] as String,
            entityId: row['entityId'] as String,
            operation: row['operation'] as String,
            payload: row['payload'] as String?,
            retryCount: row['retryCount'] as int,
            createdAt: _dateTimeConverter.decode(row['createdAt'] as int),
            lastAttemptAt:
                _nullableDateTimeConverter.decode(row['lastAttemptAt'] as int?),
            error: row['error'] as String?));
  }

  @override
  Future<List<SyncQueueEntity>> getPendingSyncsByType(String entityType) async {
    return _queryAdapter.queryList(
        'SELECT * FROM sync_queue WHERE entityType = ?1 ORDER BY createdAt ASC',
        mapper: (Map<String, Object?> row) => SyncQueueEntity(
            id: row['id'] as String,
            entityType: row['entityType'] as String,
            entityId: row['entityId'] as String,
            operation: row['operation'] as String,
            payload: row['payload'] as String?,
            retryCount: row['retryCount'] as int,
            createdAt: _dateTimeConverter.decode(row['createdAt'] as int),
            lastAttemptAt:
                _nullableDateTimeConverter.decode(row['lastAttemptAt'] as int?),
            error: row['error'] as String?),
        arguments: [entityType]);
  }

  @override
  Future<SyncQueueEntity?> getPendingSyncForEntity(
    String entityId,
    String entityType,
  ) async {
    return _queryAdapter.query(
        'SELECT * FROM sync_queue WHERE entityId = ?1 AND entityType = ?2',
        mapper: (Map<String, Object?> row) => SyncQueueEntity(
            id: row['id'] as String,
            entityType: row['entityType'] as String,
            entityId: row['entityId'] as String,
            operation: row['operation'] as String,
            payload: row['payload'] as String?,
            retryCount: row['retryCount'] as int,
            createdAt: _dateTimeConverter.decode(row['createdAt'] as int),
            lastAttemptAt:
                _nullableDateTimeConverter.decode(row['lastAttemptAt'] as int?),
            error: row['error'] as String?),
        arguments: [entityId, entityType]);
  }

  @override
  Future<List<SyncQueueEntity>> getRetryableSyncs(
    int maxRetries,
    int limit,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM sync_queue WHERE retryCount < ?1 ORDER BY createdAt ASC LIMIT ?2',
        mapper: (Map<String, Object?> row) => SyncQueueEntity(id: row['id'] as String, entityType: row['entityType'] as String, entityId: row['entityId'] as String, operation: row['operation'] as String, payload: row['payload'] as String?, retryCount: row['retryCount'] as int, createdAt: _dateTimeConverter.decode(row['createdAt'] as int), lastAttemptAt: _nullableDateTimeConverter.decode(row['lastAttemptAt'] as int?), error: row['error'] as String?),
        arguments: [maxRetries, limit]);
  }

  @override
  Future<int?> getPendingSyncCount() async {
    return _queryAdapter.query('SELECT COUNT(*) FROM sync_queue',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<int?> getPendingSyncCountByType(String entityType) async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM sync_queue WHERE entityType = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [entityType]);
  }

  @override
  Future<int?> getFailedSyncCount(int maxRetries) async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM sync_queue WHERE retryCount >= ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [maxRetries]);
  }

  @override
  Future<void> deleteSyncItemById(String id) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM sync_queue WHERE id = ?1', arguments: [id]);
  }

  @override
  Future<void> deleteSyncItemsForEntity(
    String entityId,
    String entityType,
  ) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM sync_queue WHERE entityId = ?1 AND entityType = ?2',
        arguments: [entityId, entityType]);
  }

  @override
  Future<void> incrementRetryCount(
    String id,
    DateTime attemptTime,
    String error,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE sync_queue SET retryCount = retryCount + 1, lastAttemptAt = ?2, error = ?3 WHERE id = ?1',
        arguments: [id, _dateTimeConverter.encode(attemptTime), error]);
  }

  @override
  Future<void> cleanupFailedSyncs(
    int maxRetries,
    DateTime before,
  ) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM sync_queue WHERE retryCount >= ?1 AND createdAt < ?2',
        arguments: [maxRetries, _dateTimeConverter.encode(before)]);
  }

  @override
  Future<void> cleanupOldSyncs(DateTime before) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM sync_queue WHERE createdAt < ?1',
        arguments: [_dateTimeConverter.encode(before)]);
  }

  @override
  Future<List<SyncQueueEntity>> getBatchSyncs(
    String entityType,
    String operation,
    int batchSize,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM sync_queue WHERE entityType = ?1 AND operation = ?2 ORDER BY createdAt ASC LIMIT ?3',
        mapper: (Map<String, Object?> row) => SyncQueueEntity(id: row['id'] as String, entityType: row['entityType'] as String, entityId: row['entityId'] as String, operation: row['operation'] as String, payload: row['payload'] as String?, retryCount: row['retryCount'] as int, createdAt: _dateTimeConverter.decode(row['createdAt'] as int), lastAttemptAt: _nullableDateTimeConverter.decode(row['lastAttemptAt'] as int?), error: row['error'] as String?),
        arguments: [entityType, operation, batchSize]);
  }

  @override
  Future<List<String>> getDistinctEntityTypes() async {
    return _queryAdapter.queryList(
        'SELECT DISTINCT entityType FROM sync_queue ORDER BY entityType',
        mapper: (Map<String, Object?> row) => row.values.first as String);
  }

  @override
  Future<List<String>> getDistinctOperations() async {
    return _queryAdapter.queryList(
        'SELECT DISTINCT operation FROM sync_queue ORDER BY operation',
        mapper: (Map<String, Object?> row) => row.values.first as String);
  }

  @override
  Future<void> insertSyncItem(SyncQueueEntity syncItem) async {
    await _syncQueueEntityInsertionAdapter.insert(
        syncItem, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertSyncItems(List<SyncQueueEntity> syncItems) async {
    await _syncQueueEntityInsertionAdapter.insertList(
        syncItems, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateSyncItem(SyncQueueEntity syncItem) async {
    await _syncQueueEntityUpdateAdapter.update(
        syncItem, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteSyncItem(SyncQueueEntity syncItem) async {
    await _syncQueueEntityDeletionAdapter.delete(syncItem);
  }
}

// ignore_for_file: unused_element
final _dateTimeConverter = DateTimeConverter();
final _nullableDateTimeConverter = NullableDateTimeConverter();

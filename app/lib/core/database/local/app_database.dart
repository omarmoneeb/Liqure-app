import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:flutter/foundation.dart';

import 'entities/drink_entity.dart';
import 'entities/rating_entity.dart';
import 'entities/sync_queue_entity.dart';
import 'daos/drink_dao.dart';
import 'daos/rating_dao.dart';
import 'daos/sync_queue_dao.dart';
import 'converters/date_time_converter.dart';

part 'app_database.g.dart'; // Generated file

@Database(
  version: 1,
  entities: [
    DrinkEntity,
    RatingEntity,
    SyncQueueEntity,
  ],
)
abstract class AppDatabase extends FloorDatabase {
  DrinkDao get drinkDao;
  RatingDao get ratingDao;
  SyncQueueDao get syncQueueDao;
  
  static const String _databaseName = 'liquor_journal.db';
  
  static Future<AppDatabase> create() async {
    if (kIsWeb) {
      // For web, use in-memory database since web storage is handled differently
      return await $FloorAppDatabase
          .inMemoryDatabaseBuilder()
          .addMigrations([])
          .build();
    } else {
      return await $FloorAppDatabase
          .databaseBuilder(_databaseName)
          .addMigrations([])
          .build();
    }
  }
  
  static Future<AppDatabase> createInMemory() async {
    return await $FloorAppDatabase
        .inMemoryDatabaseBuilder()
        .build();
  }
}


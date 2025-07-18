import 'package:floor/floor.dart';
import '../converters/date_time_converter.dart';

@Entity(tableName: 'sync_queue')
@TypeConverters([DateTimeConverter, NullableDateTimeConverter])
class SyncQueueEntity {
  @PrimaryKey()
  final String id;
  
  final String entityType; // 'drink', 'rating'
  final String entityId;
  final String operation; // 'create', 'update', 'delete'
  final String? payload; // JSON payload for the operation
  final int retryCount;
  final DateTime createdAt;
  final DateTime? lastAttemptAt;
  final String? error;
  
  const SyncQueueEntity({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.operation,
    this.payload,
    this.retryCount = 0,
    required this.createdAt,
    this.lastAttemptAt,
    this.error,
  });
  
  SyncQueueEntity copyWith({
    String? id,
    String? entityType,
    String? entityId,
    String? operation,
    String? payload,
    int? retryCount,
    DateTime? createdAt,
    DateTime? lastAttemptAt,
    String? error,
  }) {
    return SyncQueueEntity(
      id: id ?? this.id,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      operation: operation ?? this.operation,
      payload: payload ?? this.payload,
      retryCount: retryCount ?? this.retryCount,
      createdAt: createdAt ?? this.createdAt,
      lastAttemptAt: lastAttemptAt ?? this.lastAttemptAt,
      error: error ?? this.error,
    );
  }
  
  @override
  String toString() {
    return 'SyncQueueEntity(id: $id, entityType: $entityType, operation: $operation, retryCount: $retryCount)';
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SyncQueueEntity && other.id == id;
  }
  
  @override
  int get hashCode => id.hashCode;
}
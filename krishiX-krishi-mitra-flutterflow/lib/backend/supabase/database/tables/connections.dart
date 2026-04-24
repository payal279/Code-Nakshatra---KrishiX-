import '../database.dart';

class ConnectionsTable extends SupabaseTable<ConnectionsRow> {
  @override
  String get tableName => 'connections';

  @override
  ConnectionsRow createRow(Map<String, dynamic> data) => ConnectionsRow(data);
}

class ConnectionsRow extends SupabaseDataRow {
  ConnectionsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ConnectionsTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  String get senderId => getField<String>('sender_id')!;
  set senderId(String value) => setField<String>('sender_id', value);

  String get receiverId => getField<String>('receiver_id')!;
  set receiverId(String value) => setField<String>('receiver_id', value);

  String get status => getField<String>('status')!;
  set status(String value) => setField<String>('status', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}

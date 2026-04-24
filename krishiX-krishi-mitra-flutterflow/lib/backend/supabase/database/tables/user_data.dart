import '../database.dart';

class UserDataTable extends SupabaseTable<UserDataRow> {
  @override
  String get tableName => 'userData';

  @override
  UserDataRow createRow(Map<String, dynamic> data) => UserDataRow(data);
}

class UserDataRow extends SupabaseDataRow {
  UserDataRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => UserDataTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get email => getField<String>('email');
  set email(String? value) => setField<String>('email', value);

  String? get firstName => getField<String>('firstName');
  set firstName(String? value) => setField<String>('firstName', value);

  String? get phone => getField<String>('phone');
  set phone(String? value) => setField<String>('phone', value);
}

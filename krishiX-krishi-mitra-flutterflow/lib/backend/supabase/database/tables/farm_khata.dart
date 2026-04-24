import '../database.dart';

class FarmKhataTable extends SupabaseTable<FarmKhataRow> {
  @override
  String get tableName => 'farm_khata';

  @override
  FarmKhataRow createRow(Map<String, dynamic> data) => FarmKhataRow(data);
}

class FarmKhataRow extends SupabaseDataRow {
  FarmKhataRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => FarmKhataTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String get title => getField<String>('title')!;
  set title(String value) => setField<String>('title', value);

  double get amount => getField<double>('amount')!;
  set amount(double value) => setField<double>('amount', value);

  bool? get isExpense => getField<bool>('is_expense');
  set isExpense(bool? value) => setField<bool>('is_expense', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);
}

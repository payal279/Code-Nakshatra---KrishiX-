import '../database.dart';

class LoggingTable extends SupabaseTable<LoggingRow> {
  @override
  String get tableName => 'logging';

  @override
  LoggingRow createRow(Map<String, dynamic> data) => LoggingRow(data);
}

class LoggingRow extends SupabaseDataRow {
  LoggingRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => LoggingTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get date => getField<String>('Date');
  set date(String? value) => setField<String>('Date', value);

  String? get farmerName => getField<String>('Farmer_Name');
  set farmerName(String? value) => setField<String>('Farmer_Name', value);

  String? get cropType => getField<String>('Crop_Type');
  set cropType(String? value) => setField<String>('Crop_Type', value);

  String? get activityDone => getField<String>('Activity_Done');
  set activityDone(String? value) => setField<String>('Activity_Done', value);

  String? get quantitykgLiters => getField<String>('Quantity (kg/liters)');
  set quantitykgLiters(String? value) =>
      setField<String>('Quantity (kg/liters)', value);

  int? get expenses => getField<int>('Expenses (₹)');
  set expenses(int? value) => setField<int>('Expenses (₹)', value);

  String? get notes => getField<String>('Notes');
  set notes(String? value) => setField<String>('Notes', value);
}

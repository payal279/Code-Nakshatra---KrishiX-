import '../database.dart';

class CropdataTable extends SupabaseTable<CropdataRow> {
  @override
  String get tableName => 'cropdata';

  @override
  CropdataRow createRow(Map<String, dynamic> data) => CropdataRow(data);
}

class CropdataRow extends SupabaseDataRow {
  CropdataRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => CropdataTable();

  int get id => getField<int>('ID')!;
  set id(int value) => setField<int>('ID', value);

  String? get crop => getField<String>('Crop');
  set crop(String? value) => setField<String>('Crop', value);

  String? get stage => getField<String>('Stage');
  set stage(String? value) => setField<String>('Stage', value);

  String? get timing => getField<String>('Timing');
  set timing(String? value) => setField<String>('Timing', value);

  String? get practice => getField<String>('Practice');
  set practice(String? value) => setField<String>('Practice', value);

  String? get fertilizerAction => getField<String>('Fertilizer/Action');
  set fertilizerAction(String? value) =>
      setField<String>('Fertilizer/Action', value);

  String? get notes => getField<String>('Notes');
  set notes(String? value) => setField<String>('Notes', value);
}

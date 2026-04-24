import '../database.dart';

class GovSchemesTable extends SupabaseTable<GovSchemesRow> {
  @override
  String get tableName => 'govSchemes';

  @override
  GovSchemesRow createRow(Map<String, dynamic> data) => GovSchemesRow(data);
}

class GovSchemesRow extends SupabaseDataRow {
  GovSchemesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => GovSchemesTable();

  int get id => getField<int>('ID')!;
  set id(int value) => setField<int>('ID', value);

  String? get schemeName => getField<String>('Scheme Name');
  set schemeName(String? value) => setField<String>('Scheme Name', value);

  String? get description => getField<String>('Description');
  set description(String? value) => setField<String>('Description', value);

  String? get objectives => getField<String>('Objectives');
  set objectives(String? value) => setField<String>('Objectives', value);

  String? get eligibilityNotes => getField<String>('Eligibility/Notes');
  set eligibilityNotes(String? value) =>
      setField<String>('Eligibility/Notes', value);

  String? get links => getField<String>('links');
  set links(String? value) => setField<String>('links', value);
}

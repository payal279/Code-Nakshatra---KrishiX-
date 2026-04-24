import '../database.dart';

class UpcomingEventsTable extends SupabaseTable<UpcomingEventsRow> {
  @override
  String get tableName => 'upcoming_events';

  @override
  UpcomingEventsRow createRow(Map<String, dynamic> data) =>
      UpcomingEventsRow(data);
}

class UpcomingEventsRow extends SupabaseDataRow {
  UpcomingEventsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => UpcomingEventsTable();

  int get id => getField<int>('ID')!;
  set id(int value) => setField<int>('ID', value);

  String? get date => getField<String>('Date');
  set date(String? value) => setField<String>('Date', value);

  String? get host => getField<String>('Host');
  set host(String? value) => setField<String>('Host', value);

  String? get titleOfEvent => getField<String>('Title of Event');
  set titleOfEvent(String? value) => setField<String>('Title of Event', value);

  String? get speaker => getField<String>('Speaker');
  set speaker(String? value) => setField<String>('Speaker', value);

  String? get location => getField<String>('Location');
  set location(String? value) => setField<String>('Location', value);

  String? get time => getField<String>('Time');
  set time(String? value) => setField<String>('Time', value);

  String? get mode => getField<String>('Mode');
  set mode(String? value) => setField<String>('Mode', value);
}

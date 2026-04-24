import '../database.dart';

class MoodTrackerTable extends SupabaseTable<MoodTrackerRow> {
  @override
  String get tableName => 'mood tracker';

  @override
  MoodTrackerRow createRow(Map<String, dynamic> data) => MoodTrackerRow(data);
}

class MoodTrackerRow extends SupabaseDataRow {
  MoodTrackerRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => MoodTrackerTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

  String? get mood => getField<String>('mood');
  set mood(String? value) => setField<String>('mood', value);

  String? get moodEmoji => getField<String>('mood_emoji');
  set moodEmoji(String? value) => setField<String>('mood_emoji', value);

  int? get moodValue => getField<int>('mood_value');
  set moodValue(int? value) => setField<int>('mood_value', value);

  DateTime? get recordedAt => getField<DateTime>('recorded_at');
  set recordedAt(DateTime? value) => setField<DateTime>('recorded_at', value);

  String? get notes => getField<String>('notes');
  set notes(String? value) => setField<String>('notes', value);

  String? get location => getField<String>('location');
  set location(String? value) => setField<String>('location', value);

  String? get weather => getField<String>('weather');
  set weather(String? value) => setField<String>('weather', value);

  int? get sleepHours => getField<int>('sleep_hours');
  set sleepHours(int? value) => setField<int>('sleep_hours', value);

  int? get stressLevel => getField<int>('stress_level');
  set stressLevel(int? value) => setField<int>('stress_level', value);

  int? get energyLevel => getField<int>('energy_level');
  set energyLevel(int? value) => setField<int>('energy_level', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);
}

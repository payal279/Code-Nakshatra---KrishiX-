import '../database.dart';

class FarmerDataTable extends SupabaseTable<FarmerDataRow> {
  @override
  String get tableName => 'farmerData';

  @override
  FarmerDataRow createRow(Map<String, dynamic> data) => FarmerDataRow(data);
}

class FarmerDataRow extends SupabaseDataRow {
  FarmerDataRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => FarmerDataTable();

  String? get fullName => getField<String>('Full_Name');
  set fullName(String? value) => setField<String>('Full_Name', value);

  int? get age => getField<int>('Age');
  set age(int? value) => setField<int>('Age', value);

  String? get gender => getField<String>('Gender');
  set gender(String? value) => setField<String>('Gender', value);

  int? get mobileNumber => getField<int>('Mobile_Number');
  set mobileNumber(int? value) => setField<int>('Mobile_Number', value);

  String? get emailAddress => getField<String>('Email_Address');
  set emailAddress(String? value) => setField<String>('Email_Address', value);

  String? get state => getField<String>('State');
  set state(String? value) => setField<String>('State', value);

  String? get district => getField<String>('District');
  set district(String? value) => setField<String>('District', value);

  String? get villageTown => getField<String>('Village_Town');
  set villageTown(String? value) => setField<String>('Village_Town', value);

  int? get pINCode => getField<int>('PIN_Code');
  set pINCode(int? value) => setField<int>('PIN_Code', value);

  String? get gPSCoordinates => getField<String>('GPS_Coordinates');
  set gPSCoordinates(String? value) =>
      setField<String>('GPS_Coordinates', value);

  int? get totalLandArea => getField<int>('Total_Land_Area');
  set totalLandArea(int? value) => setField<int>('Total_Land_Area', value);

  double? get cultivatedLand => getField<double>('Cultivated_Land');
  set cultivatedLand(double? value) =>
      setField<double>('Cultivated_Land', value);

  String? get primaryCrop => getField<String>('Primary_Crop');
  set primaryCrop(String? value) => setField<String>('Primary_Crop', value);

  String? get otherCrops => getField<String>('Other_Crops');
  set otherCrops(String? value) => setField<String>('Other_Crops', value);

  String? get soilType => getField<String>('Soil_Type');
  set soilType(String? value) => setField<String>('Soil_Type', value);

  String? get irrigationMethod => getField<String>('Irrigation_Method');
  set irrigationMethod(String? value) =>
      setField<String>('Irrigation_Method', value);

  String get uid => getField<String>('uid')!;
  set uid(String value) => setField<String>('uid', value);
}

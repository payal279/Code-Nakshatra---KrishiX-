import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ApisRecord extends FirestoreRecord {
  ApisRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "chatbotAPI" field.
  String? _chatbotAPI;
  String get chatbotAPI => _chatbotAPI ?? '';
  bool hasChatbotAPI() => _chatbotAPI != null;

  // "newsAPI" field.
  String? _newsAPI;
  String get newsAPI => _newsAPI ?? '';
  bool hasNewsAPI() => _newsAPI != null;

  // "cropmodelAPI" field.
  String? _cropmodelAPI;
  String get cropmodelAPI => _cropmodelAPI ?? '';
  bool hasCropmodelAPI() => _cropmodelAPI != null;

  // "googleCropCheckAPI" field.
  String? _googleCropCheckAPI;
  String get googleCropCheckAPI => _googleCropCheckAPI ?? '';
  bool hasGoogleCropCheckAPI() => _googleCropCheckAPI != null;

  void _initializeFields() {
    _chatbotAPI = snapshotData['chatbotAPI'] as String?;
    _newsAPI = snapshotData['newsAPI'] as String?;
    _cropmodelAPI = snapshotData['cropmodelAPI'] as String?;
    _googleCropCheckAPI = snapshotData['googleCropCheckAPI'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('apis');

  static Stream<ApisRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ApisRecord.fromSnapshot(s));

  static Future<ApisRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => ApisRecord.fromSnapshot(s));

  static ApisRecord fromSnapshot(DocumentSnapshot snapshot) => ApisRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ApisRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ApisRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ApisRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ApisRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createApisRecordData({
  String? chatbotAPI,
  String? newsAPI,
  String? cropmodelAPI,
  String? googleCropCheckAPI,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'chatbotAPI': chatbotAPI,
      'newsAPI': newsAPI,
      'cropmodelAPI': cropmodelAPI,
      'googleCropCheckAPI': googleCropCheckAPI,
    }.withoutNulls,
  );

  return firestoreData;
}

class ApisRecordDocumentEquality implements Equality<ApisRecord> {
  const ApisRecordDocumentEquality();

  @override
  bool equals(ApisRecord? e1, ApisRecord? e2) {
    return e1?.chatbotAPI == e2?.chatbotAPI &&
        e1?.newsAPI == e2?.newsAPI &&
        e1?.cropmodelAPI == e2?.cropmodelAPI &&
        e1?.googleCropCheckAPI == e2?.googleCropCheckAPI;
  }

  @override
  int hash(ApisRecord? e) => const ListEquality().hash(
      [e?.chatbotAPI, e?.newsAPI, e?.cropmodelAPI, e?.googleCropCheckAPI]);

  @override
  bool isValidKey(Object? o) => o is ApisRecord;
}

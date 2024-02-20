import 'package:cloud_firestore/cloud_firestore.dart';

class Contact {
  late String uid;
  late DateTime addedOn; // Change to DateTime type

  Contact({
    required this.uid,
    required this.addedOn,
  });

  // Avoid using the name Timestamp here
  get timestamp => null;

  Map<String, dynamic> toMap() {
    var data = <String, dynamic>{};
    data['contact_id'] = uid;
    data['added_on'] = addedOn; // Convert DateTime to Timestamp directly
    return data;
  }

  Contact.fromMap(Map<String, dynamic> mapData) {
    uid = mapData['contact_id'];
    addedOn = (mapData['added_on'] as Timestamp).toDate(); // Convert Timestamp to DateTime
  }
}
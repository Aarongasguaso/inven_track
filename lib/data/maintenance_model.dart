import 'package:cloud_firestore/cloud_firestore.dart';

class Maintenance {
  final String id;
  final String equipmentId;
  final String description;
  final DateTime date;

  Maintenance({
    required this.id,
    required this.equipmentId,
    required this.description,
    required this.date,
  });

  factory Maintenance.fromMap(String id, Map<String, dynamic> data) {
    return Maintenance(
      id: id,
      equipmentId: data['equipmentId'] ?? '',
      description: data['description'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'equipmentId': equipmentId,
      'description': description,
      'date': date,
    };
  }
}

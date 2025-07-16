import 'package:cloud_firestore/cloud_firestore.dart';

class Equipment {
  final String id;
  final String name;
  final String type;
  final String status;
  final DateTime createdAt;

  Equipment({
    required this.id,
    required this.name,
    required this.type,
    required this.status,
    required this.createdAt,
  });

  factory Equipment.fromMap(String id, Map<String, dynamic> data) {
    final rawDate = data['createdAt'];
    DateTime parsedDate;

    if (rawDate is Timestamp) {
      parsedDate = rawDate.toDate();
    } else if (rawDate is DateTime) {
      parsedDate = rawDate;
    } else if (rawDate is String) {
      parsedDate = DateTime.tryParse(rawDate) ?? DateTime.now();
    } else {
      parsedDate = DateTime.now(); // fallback
    }

    return Equipment(
      id: id,
      name: data['name'] ?? '',
      type: data['type'] ?? '',
      status: data['status'] ?? '',
      createdAt: parsedDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': type,
      'status': status,
      'createdAt': createdAt,
    };
  }

  Equipment copyWith({
    String? id,
    String? name,
    String? type,
    String? status,
    DateTime? createdAt,
  }) {
    return Equipment(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

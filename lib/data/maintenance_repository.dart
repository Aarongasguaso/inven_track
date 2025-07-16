import 'package:cloud_firestore/cloud_firestore.dart';
import 'maintenance_model.dart';

class MaintenanceRepository {
  final _collection = FirebaseFirestore.instance.collection('maintenance');

  Future<void> addMaintenance(Maintenance maintenance) async {
    await _collection.add(maintenance.toMap());
  }

  Stream<List<Maintenance>> getMaintenanceByEquipment(String equipmentId) {
    return _collection
        .where('equipmentId', isEqualTo: equipmentId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Maintenance.fromMap(doc.id, doc.data())).toList());
  }
}

import 'dart:async';
import 'package:flutter/foundation.dart'; // Para kIsWeb
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'equipment_model.dart';
import '../services/equipment_local_db.dart';

class EquipmentRepository {
  final _db = FirebaseFirestore.instance.collection('equipment');
  final EquipmentLocalDb? _localDb = kIsWeb ? null : EquipmentLocalDb();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  EquipmentRepository() {
    if (!kIsWeb) _startConnectivityMonitor();
  }

  void _startConnectivityMonitor() {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((result) async {
      if (result != ConnectivityResult.none) {
        await syncLocalToFirestore();
      }
    });
  }

  Future<void> addEquipment(Equipment equipment) async {
    final docRef = await _db.add(equipment.toMap());

    if (!kIsWeb) {
      final localEquipment = equipment.copyWith(id: docRef.id);
      await _localDb?.insertEquipment(localEquipment);
    }
  }

  Future<void> deleteEquipment(String id) async {
    await _db.doc(id).delete();
    if (!kIsWeb) {
      await _localDb?.deleteEquipment(id);
    }
  }

  Future<void> updateEquipment(String id, Map<String, dynamic> data) async {
    await _db.doc(id).update(data);

    if (!kIsWeb) {
      final updated = Equipment.fromMap(id, data);
      await _localDb?.insertEquipment(updated);
    }
  }

  Stream<List<Equipment>> getEquipments() async* {
    if (kIsWeb) {
      // En web: solo Firebase
      yield* _db.snapshots().map((snapshot) {
        return snapshot.docs
            .map((doc) => Equipment.fromMap(doc.id, doc.data()))
            .toList();
      });
      return;
    }

    // En móviles/escritorio: verifica conexión
    final connectivity = await Connectivity().checkConnectivity();

    if (connectivity == ConnectivityResult.none) {
      // 🔌 Sin conexión: usar SQLite
      final localEquipments = await _localDb?.getEquipments() ?? [];
      yield localEquipments;
    } else {
      // ☁️ Con conexión: usar Firebase + sincronizar local
      yield* _db.snapshots().map((snapshot) {
        final list = snapshot.docs
            .map((doc) => Equipment.fromMap(doc.id, doc.data()))
            .toList();

        _localDb?.replaceAll(list); // Actualizar cache local
        return list;
      });
    }
  }

  Future<void> syncLocalToFirestore() async {
    if (kIsWeb) return;

    final localEquipments = await _localDb?.getEquipments() ?? [];

    for (final equipment in localEquipments) {
      final doc = await _db.doc(equipment.id).get();
      if (!doc.exists) {
        await _db.doc(equipment.id).set(equipment.toMap());
      }
    }
  }

  void dispose() {
    _connectivitySubscription?.cancel();
  }
}

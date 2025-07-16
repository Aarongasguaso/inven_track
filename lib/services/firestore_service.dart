import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  static Future<void> enableOfflinePersistence() async {
    await FirebaseFirestore.instance.enablePersistence(
      const PersistenceSettings(synchronizeTabs: true),
    );
  }
}

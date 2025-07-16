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

  @override
  String toString() {
    return 'Equipment(id: $id, name: $name, type: $type, status: $status, createdAt: $createdAt)';
  }
}

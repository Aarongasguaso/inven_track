import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/equipment_model.dart';

class EquipmentCard extends StatelessWidget {
  final Equipment equipment;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onMaintenance;

  const EquipmentCard({
    Key? key,
    required this.equipment,
    required this.onEdit,
    required this.onDelete,
    required this.onMaintenance,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(equipment.createdAt);

    return Semantics(
      label:
          'Equipo ${equipment.name}, tipo ${equipment.type}, estado ${equipment.status}, registrado el $formattedDate',
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 4,
        child: ListTile(
          title: Text(
            equipment.name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tipo: ${equipment.type}', style: const TextStyle(fontSize: 16)),
                Text('Estado: ${equipment.status}', style: const TextStyle(fontSize: 16)),
                Text(
                  'Fecha: $formattedDate',
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Tooltip(
                message: 'Editar equipo',
                child: IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: onEdit,
                ),
              ),
              Tooltip(
                message: 'Eliminar equipo',
                child: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: onDelete,
                ),
              ),
              Tooltip(
                message: 'Historial de mantenimiento',
                child: IconButton(
                  icon: const Icon(Icons.build_circle, color: Colors.orange),
                  onPressed: onMaintenance,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

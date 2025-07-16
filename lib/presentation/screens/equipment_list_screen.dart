import 'package:flutter/material.dart';
import '../../data/equipment_model.dart';
import '../../data/equipment_repository.dart';
import 'edit_equipment_screen.dart';
import 'maintenance_history_screen.dart';
import '../../ui/widgets/equipment_card.dart';

class EquipmentListScreen extends StatefulWidget {
  const EquipmentListScreen({super.key});

  @override
  State<EquipmentListScreen> createState() => _EquipmentListScreenState();
}

class _EquipmentListScreenState extends State<EquipmentListScreen> {
  final _repository = EquipmentRepository();
  final _searchController = TextEditingController();
  String _searchText = '';
  String? _selectedType = 'Todos';
  String? _selectedStatus = 'Todos';

  final List<String> _equipmentTypes = ['Todos', 'Eléctrico', 'Mecánico', 'Electrónico', 'Otro'];
  final List<String> _equipmentStates = ['Todos', 'Operativo', 'En mantenimiento', 'Dañado'];

  void deleteEquipment(BuildContext context, String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('¿Eliminar equipo?'),
        content: const Text('¿Estás seguro de que deseas eliminar este equipo?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Eliminar')),
        ],
      ),
    );

    if (confirm == true) {
      await _repository.deleteEquipment(id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Equipo eliminado')));
      }
    }
  }

  void editEquipment(BuildContext context, Equipment equipment) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditEquipmentScreen(id: equipment.id, initialData: equipment.toMap()),
      ),
    );
  }

  List<Equipment> filtrarEquipos(List<Equipment> equipos) {
    return equipos.where((e) {
      final matchName = e.name.toLowerCase().contains(_searchText.toLowerCase());
      final matchType = _selectedType == 'Todos' || e.type == _selectedType;
      final matchStatus = _selectedStatus == 'Todos' || e.status == _selectedStatus;
      return matchName && matchType && matchStatus;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Equipos Registrados')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    labelText: 'Buscar por nombre',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => setState(() => _searchText = value),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedType,
                        items: _equipmentTypes
                            .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                            .toList(),
                        onChanged: (value) => setState(() => _selectedType = value),
                        decoration: const InputDecoration(labelText: 'Tipo'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedStatus,
                        items: _equipmentStates
                            .map((status) => DropdownMenuItem(value: status, child: Text(status)))
                            .toList(),
                        onChanged: (value) => setState(() => _selectedStatus = value),
                        decoration: const InputDecoration(labelText: 'Estado'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Equipment>>(
              stream: _repository.getEquipments(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final equipos = filtrarEquipos(snapshot.data ?? []);

                if (equipos.isEmpty) {
                  return const Center(child: Text('No hay equipos que coincidan.'));
                }

                return ListView.builder(
                  itemCount: equipos.length,
                  cacheExtent: 500, // Mejora el scroll anticipado
                  itemBuilder: (context, index) {
                    final equipo = equipos[index];

                    return EquipmentCard(
                      equipment: equipo,
                      onEdit: () => editEquipment(context, equipo),
                      onDelete: () => deleteEquipment(context, equipo.id),
                      onMaintenance: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MaintenanceHistoryScreen(
                              equipoId: equipo.id,
                              equipoNombre: equipo.name,
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

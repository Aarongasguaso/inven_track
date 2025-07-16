import 'package:flutter/material.dart';
import '../../data/equipment_repository.dart';

class EditEquipmentScreen extends StatefulWidget {
  final String id;
  final Map<String, dynamic> initialData;

  const EditEquipmentScreen({required this.id, required this.initialData});

  @override
  State<EditEquipmentScreen> createState() => _EditEquipmentScreenState();
}

class _EditEquipmentScreenState extends State<EditEquipmentScreen> {
  final _nameController = TextEditingController();
  final _typeController = TextEditingController();
  final _statusController = TextEditingController();

  final _repository = EquipmentRepository();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.initialData['name'] ?? '';
    _typeController.text = widget.initialData['type'] ?? '';
    _statusController.text = widget.initialData['status'] ?? '';
  }

  void _saveChanges() async {
    final name = _nameController.text.trim();
    final type = _typeController.text.trim();
    final status = _statusController.text.trim();

    if (name.isEmpty || type.isEmpty || status.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor completa todos los campos.')),
      );
      return;
    }

    try {
      final updatedData = {
        'name': name,
        'type': type,
        'status': status,
        'createdAt': widget.initialData['createdAt'], // mantener fecha original
      };

      await _repository.updateEquipment(widget.id, updatedData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('✅ Equipo actualizado correctamente')),
      );
      Navigator.pop(context);
    } catch (e) {
      print("🔥 Error actualizando equipo: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Error al actualizar el equipo')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Editar equipo')),
      body: Semantics(
        label: 'Formulario de edición de equipo',
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nombre del equipo',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _typeController,
                decoration: InputDecoration(
                  labelText: 'Tipo',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _statusController,
                decoration: InputDecoration(
                  labelText: 'Estado',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 24),
              Tooltip(
                message: 'Guardar los cambios del equipo',
                child: ElevatedButton.icon(
                  onPressed: _saveChanges,
                  icon: Icon(Icons.save),
                  label: Text('Guardar Cambios'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    textStyle: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _typeController.dispose();
    _statusController.dispose();
    super.dispose();
  }
}

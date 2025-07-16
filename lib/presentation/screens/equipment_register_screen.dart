import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../data/equipment_model.dart';
import '../../data/equipment_repository.dart';
import '../../l10n/app_localizations.dart';

class EquipmentRegisterScreen extends StatefulWidget {
  @override
  State<EquipmentRegisterScreen> createState() => _EquipmentRegisterScreenState();
}

class _EquipmentRegisterScreenState extends State<EquipmentRegisterScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _selectedType;
  String? _selectedStatus;

  final _repository = EquipmentRepository();

  final List<String> _equipmentTypes = ['Eléctrico', 'Mecánico', 'Electrónico', 'Otro'];
  final List<String> _equipmentStates = ['Operativo', 'En mantenimiento', 'Dañado'];

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(local.register_equipment)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Semantics(
          label: 'Formulario de registro de equipos',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: local.equipment_name,
                  border: OutlineInputBorder(),
                ),
                autofocus: true,
                textInputAction: TextInputAction.next,
              ),
              SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: local.equipment_description,
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.next,
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedType,
                items: _equipmentTypes
                    .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                    .toList(),
                onChanged: (value) => setState(() => _selectedType = value),
                decoration: InputDecoration(
                  labelText: 'Tipo de equipo',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                items: _equipmentStates
                    .map((status) => DropdownMenuItem(value: status, child: Text(status)))
                    .toList(),
                onChanged: (value) => setState(() => _selectedStatus = value),
                decoration: InputDecoration(
                  labelText: 'Estado del equipo',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 24),
              Center(
                child: Tooltip(
                  message: 'Guardar nuevo equipo',
                  child: ElevatedButton.icon(
                    onPressed: () => _registerEquipment(context),
                    icon: Icon(Icons.save),
                    label: Text(local.save_equipment),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      textStyle: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _registerEquipment(BuildContext context) async {
    final local = AppLocalizations.of(context)!;
    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();

    if (name.isEmpty || description.isEmpty || _selectedType == null || _selectedStatus == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(local.equipment_error)),
      );
      return;
    }

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Usuario no autenticado.")),
        );
        return;
      }

      final equipment = Equipment(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        type: _selectedType!,
        status: _selectedStatus!,
        createdAt: DateTime.now(),
      );

      await _repository.addEquipment(equipment); // ✅ Solo esto. El repo decide si usar SQLite.

      _nameController.clear();
      _descriptionController.clear();
      setState(() {
        _selectedType = null;
        _selectedStatus = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(local.equipment_saved)),
      );
    } catch (e) {
      print("🔥 Error guardando equipo: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(local.equipment_error)),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}

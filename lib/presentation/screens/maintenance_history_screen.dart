import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class MaintenanceHistoryScreen extends StatefulWidget {
  final String equipoId;
  final String equipoNombre;

  const MaintenanceHistoryScreen({
    required this.equipoId,
    required this.equipoNombre,
  });

  @override
  _MaintenanceHistoryScreenState createState() => _MaintenanceHistoryScreenState();
}

class _MaintenanceHistoryScreenState extends State<MaintenanceHistoryScreen> {
  final TextEditingController _descripcionController = TextEditingController();
  String mensaje = '';
  bool isLoading = false;

  Future<void> agregarMantenimiento() async {
    final descripcion = _descripcionController.text.trim();
    if (descripcion.isEmpty) {
      setState(() => mensaje = '❌ Ingresa una descripción.');
      return;
    }

    setState(() {
      isLoading = true;
      mensaje = '';
    });

    try {
      await FirebaseFirestore.instance
          .collection('equipment') // ✅ Colección correcta
          .doc(widget.equipoId)
          .collection('mantenimientos')
          .add({
        'descripcion': descripcion,
        'fecha': FieldValue.serverTimestamp(),
      });

      _descripcionController.clear();
      setState(() {
        mensaje = '✅ Mantenimiento agregado';
      });
    } catch (e) {
      print('Error al agregar mantenimiento: $e');
      setState(() {
        mensaje = '❌ Error al guardar';
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mantenimientoRef = FirebaseFirestore.instance
        .collection('equipment')
        .doc(widget.equipoId)
        .collection('mantenimientos')
        .orderBy('fecha', descending: true);

    return Scaffold(
      appBar: AppBar(
        title: Text('Mantenimiento: ${widget.equipoNombre}'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Semantics(
              label: 'Formulario de mantenimiento',
              child: Column(
                children: [
                  TextField(
                    controller: _descripcionController,
                    decoration: InputDecoration(
                      labelText: 'Descripción del mantenimiento',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.description),
                    ),
                    textInputAction: TextInputAction.done,
                  ),
                  SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: isLoading ? null : agregarMantenimiento,
                    icon: Icon(Icons.add),
                    label: isLoading
                        ? SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : Text('Agregar mantenimiento'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  ),
                  if (mensaje.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        mensaje,
                        style: TextStyle(
                          color: mensaje.contains('✅') ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Divider(),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: mantenimientoRef.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('Sin mantenimientos aún.'));
                }

                final mantenimientos = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: mantenimientos.length,
                  itemBuilder: (context, index) {
                    final data = mantenimientos[index].data() as Map<String, dynamic>;
                    final fecha = (data['fecha'] as Timestamp?)?.toDate();
                    final fechaFormatted = fecha != null
                        ? DateFormat('yyyy-MM-dd HH:mm').format(fecha)
                        : 'Fecha desconocida';

                    return ListTile(
                      leading: Icon(Icons.build, color: Colors.orange),
                      title: Text(data['descripcion'] ?? 'Sin descripción'),
                      subtitle: Text('Fecha: $fechaFormatted'),
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
    _descripcionController.dispose();
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String error = '';
  bool isLoading = false;

  void register() async {
    setState(() {
      isLoading = true;
      error = '';
    });

    final authService = Provider.of<AuthService>(context, listen: false);
    try {
      final success = await authService.register(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (success) {
        Navigator.pop(context); // Volver al login si el registro fue exitoso
      } else {
        setState(() => error = 'No se pudo registrar el usuario.');
      }
    } catch (e) {
      print("❌ Error de registro: $e");
      setState(() => error = 'Error: ${e.toString()}');
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registrarse')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Correo electrónico'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: isLoading ? null : register,
              child: isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Crear cuenta'),
            ),
            if (error.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(error, style: TextStyle(color: Colors.red)),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}

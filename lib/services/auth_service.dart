import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Iniciar sesión: retorna true si es exitoso, false si falla
  Future<bool> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      print("⚠️ Error al iniciar sesión: $e");
      return false;
    }
  }

  // Registrarse: retorna true si es exitoso, false si falla
  Future<bool> register(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      print("⚠️ Error al registrar usuario: $e");
      return false;
    }
  }

  // Cerrar sesión
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Obtener usuario actual
  User? get currentUser => _auth.currentUser;

  // Cambios en el estado de autenticación (útil para login automático)
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}

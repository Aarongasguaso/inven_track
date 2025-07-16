// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String helloUser(Object user) {
    return 'Hola, $user 👋';
  }

  @override
  String get register_equipment => 'Registrar nuevo equipo';

  @override
  String get view_equipment => 'Ver equipos registrados';

  @override
  String get dark_mode => 'Modo oscuro';

  @override
  String get email_label => 'Correo electrónico';

  @override
  String get password_label => 'Contraseña';

  @override
  String get login_button => 'Iniciar sesión';

  @override
  String get login_error => 'Correo o contraseña inválidos';

  @override
  String get equipment_name => 'Nombre del equipo';

  @override
  String get equipment_description => 'Descripción';

  @override
  String get save_equipment => 'Guardar equipo';

  @override
  String get equipment_saved => 'Equipo guardado exitosamente';

  @override
  String get equipment_error => 'Ocurrió un error al guardar el equipo';

  @override
  String get home_title => 'Inicio';

  @override
  String get logout => 'Cerrar sesión';

  @override
  String get logout_confirm => '¿Estás seguro de que deseas cerrar sesión?';

  @override
  String get cancel => 'Cancelar';
}

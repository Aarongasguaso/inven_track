// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String helloUser(Object user) {
    return 'Hello, $user 👋';
  }

  @override
  String get register_equipment => 'Register equipment';

  @override
  String get view_equipment => 'View registered equipment';

  @override
  String get dark_mode => 'Dark mode';

  @override
  String get email_label => 'Email';

  @override
  String get password_label => 'Password';

  @override
  String get login_button => 'Log In';

  @override
  String get login_error => 'Invalid email or password';

  @override
  String get equipment_name => 'Equipment name';

  @override
  String get equipment_description => 'Description';

  @override
  String get save_equipment => 'Save equipment';

  @override
  String get equipment_saved => 'Equipment saved successfully';

  @override
  String get equipment_error => 'An error occurred while saving the equipment';

  @override
  String get home_title => 'Home';

  @override
  String get logout => 'Log out';

  @override
  String get logout_confirm => 'Are you sure you want to log out?';

  @override
  String get cancel => 'Cancel';
}

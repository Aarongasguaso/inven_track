import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../../providers/theme_provider.dart';         // Ruta corregida
import '../../l10n/app_localizations.dart';           // Ruta corregida

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final local = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(local.home_title),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            tooltip: local.logout,
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text(local.logout),
                  content: Text(local.logout_confirm),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text(local.cancel),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text(local.logout),
                    ),
                  ],
                ),
              );
              if (confirm == true) {
                await FirebaseAuth.instance.signOut();
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.account_circle, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              local.helloUser(user?.email ?? 'Usuario'),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            Divider(height: 40),
            ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/register-equipment'),
              icon: Icon(Icons.add),
              label: Text(local.register_equipment),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/list-equipment'),
              icon: Icon(Icons.list),
              label: Text(local.view_equipment),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
            SizedBox(height: 32),
            Divider(),
            SwitchListTile(
              title: Text(local.dark_mode),
              value: themeProvider.isDarkMode,
              onChanged: themeProvider.toggleTheme,
              secondary: Icon(
                themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const <Widget>[
          ListTile(
            leading: Icon(Icons.email_outlined),
            title: Text('vous@exemple.fr'),
            subtitle: Text('Compte parent · membre depuis avril'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.school_outlined),
            title: Text('Mes écoles'),
            subtitle: Text('Collège Jean Moulin'),
          ),
          Divider(),
          SwitchListTile(
            value: true,
            onChanged: null,
            title: Text('Validation de mes signalements'),
            subtitle: Text('Notification push'),
          ),
          SwitchListTile(
            value: false,
            onChanged: null,
            title: Text('Rappel quotidien (8 h 30)'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.download_outlined),
            title: Text('Exporter mes données'),
          ),
          ListTile(
            leading: Icon(Icons.delete_outline, color: Colors.red),
            title: Text('Supprimer mon compte', style: TextStyle(color: Colors.red)),
          ),
          Divider(),
          ListTile(title: Text('CGU')),
          ListTile(title: Text('Politique de confidentialité')),
          ListTile(title: Text('Code source')),
          ListTile(
            title: Text('Version'),
            trailing: Text('0.1.0'),
          ),
        ],
      ),
    );
  }
}

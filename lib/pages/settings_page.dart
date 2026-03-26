import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool pushEnabled = true;
  bool workoutReminderEnabled = true;
  bool darkModeFollowSystem = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  value: pushEnabled,
                  onChanged: (value) {
                    setState(() {
                      pushEnabled = value;
                    });
                  },
                  title: const Text('Push Notifications'),
                  subtitle: const Text('Workout completion and challenge activity alerts'),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  value: workoutReminderEnabled,
                  onChanged: (value) {
                    setState(() {
                      workoutReminderEnabled = value;
                    });
                  },
                  title: const Text('Workout Reminder'),
                  subtitle: const Text('Remind me every day at 19:30'),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  value: darkModeFollowSystem,
                  onChanged: (value) {
                    setState(() {
                      darkModeFollowSystem = value;
                    });
                  },
                  title: const Text('Follow System Dark Mode'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Card(
            child: Column(
              children: const [
                ListTile(
                  leading: Icon(Icons.privacy_tip_outlined),
                  title: Text('Privacy Policy'),
                  trailing: Icon(Icons.chevron_right),
                ),
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.description_outlined),
                  title: Text('User Agreement'),
                  trailing: Icon(Icons.chevron_right),
                ),
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.info_outline),
                  title: Text('About App'),
                  subtitle: Text('Fitness v0.1.0'),
                  trailing: Icon(Icons.chevron_right),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

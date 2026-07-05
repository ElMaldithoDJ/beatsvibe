import 'package:beatsvibe/vm/settings_vm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsViewModel>(
      builder: (context, settingsViewModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Configuraciones'),
            leading: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(CupertinoIcons.back),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20),
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Theme.brightnessOf(context) == .dark
                        ? Colors.white.withValues(alpha: .1)
                        : Colors.grey.shade100,
                    child: Icon(
                      CupertinoIcons.gear,
                      size: 45,
                      color: Colors.grey,
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: settingsViewModel.settingsOptions.length,
                    itemBuilder: (context, index) {
                      final option = settingsViewModel.settingsOptions[index];
                      return ListTile(
                        title: Text(option.title),
                        subtitle: Text(option.subtitle!),
                        leading: Icon(option.icon),
                        trailing: Icon(CupertinoIcons.chevron_right, size: 16),
                        onTap: () => Get.toNamed(option.route!),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

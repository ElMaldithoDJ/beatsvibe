import 'package:beatsvibe/vm/settings_vm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class AppearanceSettingsView extends StatefulWidget {
  const AppearanceSettingsView({super.key});

  @override
  State<AppearanceSettingsView> createState() => _AppearanceSettingsViewState();
}

class _AppearanceSettingsViewState extends State<AppearanceSettingsView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsViewModel>(
      builder: (context, settingsVM, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Apariencia'),
            leading: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(CupertinoIcons.back),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    child: Column(
                      children: [
                        
                      ],
                    )
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

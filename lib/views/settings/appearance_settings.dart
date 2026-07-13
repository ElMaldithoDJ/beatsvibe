import 'package:beatsvibe/theme.dart';
import 'package:beatsvibe/variables.dart';
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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Tema",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: EdgeInsetsGeometry.symmetric(
                    vertical: 10,
                    horizontal: 16,
                  ),
                  child: Row(
                    children: [
                      ...ThemeMode.values.map(
                        (e) => Expanded(
                          child: Column(
                            spacing: 10,
                            children: [
                              SizedBox(
                                width: 50,
                                height: 50,
                                child: GestureDetector(
                                  onTap: () => settingsVM.setThemeMode(e),
                                  child: e == .system
                                      ? Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                              image: Image.asset(
                                                AppVariables.lightDarkMode,
                                              ).image,
                                              fit: BoxFit.cover,
                                            ),
                                            border: Border.all(
                                              color: settingsVM.themeMode == e
                                                  ? Theme.of(context)
                                                        .primaryColor
                                                  : Colors.grey.shade400,
                                              width: settingsVM.themeMode == e
                                                  ? 3
                                                  : 1,
                                            ),
                                          ),
                                        )
                                      : e == .light
                                      ? Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                            border: Border.all(
                                              color: settingsVM.themeMode == e
                                                  ? Theme.of(context)
                                                        .primaryColor
                                                  : Colors.grey,
                                              width: settingsVM.themeMode == e
                                                  ? 3
                                                  : 1,
                                            ),
                                          ),
                                        )
                                      : Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: AppTheme.darkBackgroundColor,
                                            border: Border.all(
                                              color: settingsVM.themeMode == e
                                                  ? Theme.of(context)
                                                        .primaryColor
                                                  : Colors.transparent,
                                              width: settingsVM.themeMode == e
                                                  ? 3
                                                  : 1,
                                            ),
                                          ),
                                        ),
                                ),
                              ),
                              Text(
                                e == .system
                                    ? 'Sistema'
                                    : e == .light
                                    ? 'Claro'
                                    : 'Oscuro',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: settingsVM.themeMode == e
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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

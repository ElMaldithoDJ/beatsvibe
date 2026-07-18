import 'package:beatsvibe/components/folder_component.dart';
import 'package:beatsvibe/vm/audio_vm.dart';
import 'package:beatsvibe/vm/settings_vm.dart';
import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class PlayerSettingsView extends StatefulWidget {
  const PlayerSettingsView({super.key});

  @override
  State<PlayerSettingsView> createState() => _PlayerSettingsViewState();
}

class _PlayerSettingsViewState extends State<PlayerSettingsView> {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final audioVM = Provider.of<AudioViewModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuraciones del reproductor'),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(CupertinoIcons.back),
        ),
      ),
      body: Consumer<SettingsViewModel>(
        builder: (context, settingsVM, child) {
          if (settingsVM.folderPath.isEmpty) {
            settingsVM.initFolder();
          }
          return SingleChildScrollView(
            controller: _controller,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [
                        Icon(CupertinoIcons.folder),
                        const SizedBox(width: 8),
                        const Text('Carpetas'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Theme.of(context).colorScheme.surface,
                      border: Border.all(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.1),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsetsGeometry.zero,
                            child: Column(
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: settingsVM.folderPath.length,
                                  itemBuilder: (context, index) {
                                    final folder = settingsVM.folderPath[index];
                                    return FolderComponent(folder: folder);
                                  },
                                ),
                                const SizedBox(height: 10),
                                FilledButton.icon(
                                  onPressed: () async {
                                    await settingsVM.addFolder().whenComplete(
                                      () async {
                                        await audioVM.onInit();
                                      },
                                    );
                                  },
                                  icon: const Icon(CupertinoIcons.add),
                                  label: const Text('Agregar carpeta'),
                                  style: FilledButton.styleFrom(
                                    backgroundColor: Theme.of(
                                      context,
                                    ).colorScheme.surface,
                                    foregroundColor: Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

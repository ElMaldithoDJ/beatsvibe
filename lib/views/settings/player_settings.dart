import 'package:beatsvibe/components/folder_component.dart';
import 'package:beatsvibe/vm/audio_vm.dart';
import 'package:beatsvibe/vm/settings_vm.dart';
import 'package:flutter/cupertino.dart'
    show CupertinoActivityIndicator, CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class PlayerSettingsView extends StatefulWidget {
  const PlayerSettingsView({super.key});

  @override
  State<PlayerSettingsView> createState() => _PlayerSettingsViewState();
}

class _PlayerSettingsViewState extends State<PlayerSettingsView> {
  final ScrollController _controller = ScrollController();
  bool equalizerEnabled = false;

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
    return Consumer<SettingsViewModel>(
      builder: (context, settingsVM, child) {
        if (settingsVM.folderPath.isEmpty) {
          settingsVM.initFolder();
        }
        return PopScope(
          canPop: !settingsVM.isLoading,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop && !settingsVM.isLoading) {
              Get.back();
            }
            if (settingsVM.isLoading) {
              cantPop();
            }
          },
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Configuraciones del reproductor'),
              leading: IconButton(
                onPressed: () {
                  if (!settingsVM.isLoading) {
                    Get.back();
                  } else {
                    cantPop();
                  }
                },
                icon: const Icon(CupertinoIcons.back),
              ),
            ),
            body: SingleChildScrollView(
              controller: _controller,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: [
                          Icon(CupertinoIcons.folder_fill, color: Colors.amber),
                          const SizedBox(width: 8),
                          const Text('Carpetas'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Theme.of(context).scaffoldBackgroundColor,
                        border: Border.all(
                          color: Theme.of(context).colorScheme.onSurface
                              .withOpacity(0.1),
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
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount:
                                        settingsVM.folderPath.isEmpty &&
                                            !settingsVM.isLoading
                                        ? 1
                                        : settingsVM.folderPath.length +
                                              (settingsVM.isLoading ? 1 : 0),
                                    itemBuilder: (context, index) {
                                      if (settingsVM.folderPath.isEmpty &&
                                          !settingsVM.isLoading) {
                                        return const Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 8,
                                          ),
                                          child: Row(
                                            children: [Text('Sin carpetas')],
                                          ),
                                        );
                                      }
                                      if (settingsVM.isLoading &&
                                          index ==
                                              settingsVM.folderPath.length) {
                                        return const Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 8,
                                          ),
                                          child: Row(
                                            children: [
                                              CupertinoActivityIndicator(),
                                              SizedBox(width: 10),
                                              Text('Cargando...'),
                                            ],
                                          ),
                                        );
                                      }
                                      return FolderComponent(
                                        folder: settingsVM.folderPath[index],
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      FilledButton.icon(
                                        onPressed: () async {
                                          await settingsVM
                                              .addFolder()
                                              .whenComplete(() {
                                                audioVM.onInit();
                                              });
                                        },
                                        icon: const Icon(CupertinoIcons.add),
                                        label: const Text('Agregar carpeta'),
                                        style: FilledButton.styleFrom(
                                          backgroundColor: Colors.transparent,
                                          foregroundColor: Colors.blueAccent,
                                          side: const BorderSide(
                                            color: Colors.blueAccent,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          Icon(CupertinoIcons.tuningfork, color: Colors.amber),
                          const SizedBox(width: 8),
                          const Text('Ecualizador'),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        SwitchListTile(
                          title: const Text('Ecualizador'),
                          subtitle: const Text('Ecualizador de audio'),
                          value: equalizerEnabled,
                          onChanged: (value) {
                            equalizerEnabled = !equalizerEnabled;
                            setState(() {});
                          },
                          activeColor: Colors.green,
                          activeThumbColor: Colors.white,
                          activeTrackColor: Colors.green,
                          inactiveThumbColor: Colors.white,
                          inactiveTrackColor: Colors.grey.shade300,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide.none,
                          ),
                          dense: true,
                          trackOutlineColor: MaterialStatePropertyAll(Colors.transparent),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void cantPop() {
    Fluttertoast.showToast(
      msg: 'No se puede salir mientras se carga',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}

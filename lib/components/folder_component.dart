import 'package:beatsvibe/models/folders_model.dart';
import 'package:beatsvibe/vm/audio_vm.dart';
import 'package:beatsvibe/vm/settings_vm.dart';
import 'package:beatsvibe/vm/player_vm.dart';
import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FolderComponent extends StatefulWidget {
  final FoldersModel? folder;
  const FolderComponent({super.key, this.folder});

  @override
  State<FolderComponent> createState() => _FolderComponentState();
}

class _FolderComponentState extends State<FolderComponent> {
  @override
  Widget build(BuildContext context) {
    final settingsVM = Provider.of<SettingsViewModel>(context, listen: false);
    final audioVM = Provider.of<AudioViewModel>(context, listen: false);
    final playerVM = Provider.of<PlayerViewModel>(context, listen: false);
    return DecoratedBox(
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: Row(
          crossAxisAlignment: .start,
          children: [
            const Icon(CupertinoIcons.folder),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.folder!.name ?? ''),
                  Text(
                    "${widget.folder?.items} canciones",
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(CupertinoIcons.delete, size: 18),
              onPressed: () async {
                await settingsVM.deleteFolder(widget.folder!.id).whenComplete(
                  () async {
                    await audioVM.onInit();
                    await playerVM.removeDeletedSongsFromQueue();
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

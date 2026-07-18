import 'package:beatsvibe/vm/audio_vm.dart';
import 'package:beatsvibe/vm/playlist_vm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

class AddPlaylistForm extends StatefulWidget {
  const AddPlaylistForm({super.key});

  @override
  State<AddPlaylistForm> createState() => _AddPlaylistFormState();
}

class _AddPlaylistFormState extends State<AddPlaylistForm> {
  String? _selectedPlaylistId;

  @override
  Widget build(BuildContext context) {
    final playlistVM = Provider.of<PlaylistViewModel>(context);
    final audioVM = Provider.of<AudioViewModel>(context, listen: false);

    return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: const Text('Agregar a Playlist'),
      content: Column(
        mainAxisSize: .min,
        children: [
          DropdownMenuFormField(
            width: 280,
            alignmentOffset: Offset(0, 5),
            menuStyle: MenuStyle(
              visualDensity: VisualDensity.compact,
              alignment: .bottomLeft,
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              side: WidgetStatePropertyAll(
                BorderSide(color: Colors.grey.shade700, width: .5),
              ),
              elevation: WidgetStatePropertyAll(3),
              padding: WidgetStatePropertyAll(EdgeInsetsGeometry.zero),
              backgroundColor: WidgetStatePropertyAll(Theme.of(context).scaffoldBackgroundColor),
            ),
            hintText: 'Selecciona una playlist',
            dropdownMenuEntries: [
              ...playlistVM.playlists.map(
                (e) => DropdownMenuEntry<String>(value: e.id!, label: e.title!),
              ),
            ],
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              fillColor: Colors.transparent,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade700, width: .5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade700, width: .5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade700, width: .5),
              ),
            ),
            onSelected: (value) {
              setState(() {
                _selectedPlaylistId = value;
              });
            },
            showTrailingIcon: false,
            leadingIcon: const Icon(CupertinoIcons.music_note_list, size: 16),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: 280,
            height: 50,
            child: FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: const Text('Nueva playlist'),
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text('Cancelar')),
        FilledButton(
          onPressed: _selectedPlaylistId == null || playlistVM.playlists.isEmpty
              ? null
              : () async {
                  final playlist = await playlistVM.getPlaylist(
                    _selectedPlaylistId!,
                  );
                  if (playlist != null) {
                    final existingSongs = playlist.songs ?? [];
                    int addedCount = 0;

                    for (var song in audioVM.songsSelected) {
                      if (!existingSongs.any((e) => e.id == song.id)) {
                        existingSongs.add(song);
                        addedCount++;
                      }
                    }

                    if (addedCount > 0) {
                      playlist.songs = existingSongs;
                      await playlistVM.updatePlaylist(playlist);
                    }

                    Get.back();
                    Get.snackbar(
                      'Playlist actualizada',
                      addedCount > 0
                          ? 'Se agregaron $addedCount canciones a la playlist.'
                          : 'Las canciones ya estaban en la playlist.',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      colorText: Theme.of(context).textTheme.bodyMedium?.color,
                    );
                  }
                },
          child: const Text('Agregar'),
        ),
      ],
    );
  }
}

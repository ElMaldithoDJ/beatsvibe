import 'package:beatsvibe/components/audio_item.dart';
import 'package:beatsvibe/vm/audio_vm.dart';
import 'package:beatsvibe/vm/playlist_vm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class SongSelector extends StatefulWidget {
  const SongSelector({super.key});

  @override
  State<SongSelector> createState() => _SongSelectorState();
}

class _SongSelectorState extends State<SongSelector> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AudioViewModel, PlaylistViewModel>(
      builder: (context, audioVM, playlistVM, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Seleccionar Canción"),
            leading: IconButton(
              icon: const Icon(CupertinoIcons.back),
              onPressed: () {
                Get.back();
              },
            ),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  decoration: InputDecoration(
                    hintText: 'Buscar',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    audioVM.onSearch(value);
                  },
                  onTapOutside: (event) {
                    _searchFocusNode.unfocus();
                  },
                ),
              ),
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: audioVM.songs.length,
                  itemBuilder: (context, index) {
                    final song = audioVM.songs[index];
                    return GestureDetector(
                      onTap: () {
                        if (playlistVM.selectedSongs.contains(song)) {
                          playlistVM.removeSelectedSong(song);
                        } else {
                          playlistVM.addSelectedSong(song);
                        }
                      },
                      child: AudioItem(
                        song: song,
                        index: index,
                        isSelected: playlistVM.selectedSongs.contains(song),
                        showIsSelected: true,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          bottomNavigationBar: SafeArea(
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  _searchController.clear();
                  audioVM.onSearch("");
                  Get.back();
                },
                label: Text(
                  "Agregar a Playlist (${playlistVM.selectedSongs.length})",
                ),
                icon: const Icon(CupertinoIcons.floppy_disk),
              ),
            ),
          ),
        );
      },
    );
  }
}

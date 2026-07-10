import 'package:beatsvibe/variables.dart';
import 'package:beatsvibe/vm/audio_vm.dart';
import 'package:beatsvibe/vm/playlist_vm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  itemBuilder: (context, index) {
                    final song = audioVM.songs[index];
                    return ListTile(
                      onTap: () {
                        if (playlistVM.selectedSongs.contains(song)) {
                          playlistVM.removeSelectedSong(song);
                        } else {
                          playlistVM.addSelectedSong(song);
                        }
                      },
                      leading: SvgPicture.asset(
                        AppVariables.appLogo,
                        width: 35,
                        height: 35,
                      ),
                      title: Text(song.title),
                      subtitle: song.artist != null && song.artist!.isNotEmpty
                          ? Text(
                              song.artist!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )
                          : null,
                      trailing: Checkbox(
                        value: playlistVM.selectedSongs.contains(song),
                        onChanged: (value) {
                          if (value == true) {
                            playlistVM.addSelectedSong(song);
                          } else {
                            playlistVM.removeSelectedSong(song);
                          }
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      splashColor: Colors.transparent,
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

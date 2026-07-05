import 'package:beatsvibe/components/audio_cupertino.dart';
import 'package:beatsvibe/components/audio_item.dart';
import 'package:beatsvibe/components/no_songs.dart';
import 'package:beatsvibe/routes.dart';
import 'package:beatsvibe/vm/audio_vm.dart';
import 'package:beatsvibe/vm/player_vm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class MusicView extends StatefulWidget {
  const MusicView({super.key});

  @override
  State<MusicView> createState() => _MusicViewState();
}

class _MusicViewState extends State<MusicView> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _searchNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final audioVM = Provider.of<AudioViewModel>(context, listen: true);
    final playerVM = Provider.of<PlayerViewModel>(context, listen: false);

    return audioVM.songsCopy.isEmpty
        ? !audioVM.isLoading
              ? const NoSongs()
              : const SizedBox.shrink()
        : Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 16,
                ),
                child: SizedBox(
                  height: 45,
                  child: TextField(
                    controller: _searchController,
                    focusNode: _searchNode,
                    decoration: InputDecoration(
                      hintText: 'Titulo o Artista de la cancion...',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      audioVM.onSearch(value);
                    },
                    onTapOutside: (event) {
                      _searchNode.unfocus();
                    },
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: audioVM.songs.length,
                  shrinkWrap: true,
                  controller: _scrollController,
                  padding: const .only(bottom: 10),
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  itemBuilder: (context, index) {
                    final song = audioVM.songs[index];
                    return GestureDetector(
                      onTap: () {
                        if (playerVM.currentItem?.id != song.id ||
                            playerVM.lastPlayed?.id != song.id) {
                          playerVM.play(song, playlist: audioVM.songsCopy);
                        }
                        if (_searchController.text.isNotEmpty) {
                          _searchController.clear();
                          audioVM.onSearch("");
                        }
                        Get.toNamed(AppRoutes.player);
                      },

                      child: SizedBox(
                        width: .maxFinite,
                        child: AudioCupertinoContextMenu(
                          actions: [
                            AudioCupertinoMenuItem(
                              title: "Seleccionar",
                              onTap: () {},
                            ),
                            AudioCupertinoMenuItem(
                              title: "Agregar a playlist",
                              icon: CupertinoIcons.add_circled,
                              onTap: () {},
                            ),
                            AudioCupertinoMenuItem(
                              title: "Info",
                              icon: CupertinoIcons.info_circle,
                              onTap: () {},
                            ),
                            AudioCupertinoMenuItem(
                              title: "Eliminar",
                              icon: CupertinoIcons.delete_solid,
                              isDestructive: true,
                              onTap: () async {
                                await playerVM.deleteSong(song.id);
                              },
                            ),
                          ],
                          child: AudioItem(
                            song: song,
                            index: index,
                            showIsPlaying: true,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
  }
}

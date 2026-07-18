import 'package:beatsvibe/components/add_playlist_form.dart';
import 'package:beatsvibe/components/audio_cupertino.dart';
import 'package:beatsvibe/components/audio_item.dart';
import 'package:beatsvibe/components/no_songs.dart';
import 'package:beatsvibe/models/mediaitem_data.dart';
import 'package:beatsvibe/routes.dart';
import 'package:beatsvibe/vm/audio_vm.dart';
import 'package:beatsvibe/vm/favorites_vm.dart';
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

class _MusicViewState extends State<MusicView> with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();
  final PageStorageBucket _bucket = PageStorageBucket();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentPlaying();
    });
  }

  void _scrollToCurrentPlaying() {
    if (!mounted) return;
    final playerVM = Provider.of<PlayerViewModel>(context, listen: false);
    final audioVM = Provider.of<AudioViewModel>(context, listen: false);

    if (playerVM.currentItem != null && audioVM.songs.isNotEmpty) {
      final index = audioVM.songs.indexWhere((s) => s.id == playerVM.currentItem!.id);
      if (index != -1 && _scrollController.hasClients) {
        // Altura aproximada de un AudioItem
        final offset = index * 60.0;
        _scrollController.animateTo(
          offset,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final audioVM = Provider.of<AudioViewModel>(context, listen: true);
    final playerVM = Provider.of<PlayerViewModel>(context, listen: false);
    final favoriteVM = Provider.of<FavoritesViewModel>(context, listen: true);

    return audioVM.songsCopy.isEmpty
        ? !audioVM.isLoading
              ? const NoSongs()
              : const SizedBox.shrink()
        : Column(
            children: [
              Expanded(
                child: PageStorage(
                  bucket: _bucket,
                  key: const PageStorageKey('music_view'),
                  child: ListView.builder(
                    itemCount: audioVM.songs.length,
                    shrinkWrap: true,
                    controller: _scrollController,
                    padding: .only(
                      bottom:
                          audioVM.songsCopy.isNotEmpty ||
                              playerVM.currentItem != null
                          ? 70
                          : 10,
                    ),
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    itemBuilder: (context, index) {
                      final song = audioVM.songs[index];
                      return GestureDetector(
                        onTap: () {
                          if (audioVM.songsSelected.isNotEmpty) {
                            bool isSelected = audioVM.isSongSelected(song.id);
                            if (!isSelected) {
                              audioVM.selectSong(song.id);
                            } else {
                              audioVM.selectSong(song.id);
                            }
                          } else {
                            if (playerVM.currentItem?.id != song.id ||
                                playerVM.lastPlayed?.id != song.id) {
                              playerVM.play(
                                song: song,
                                playlist: audioVM.songsCopy,
                              );
                            } else if (!playerVM.isPlaying &&
                                (playerVM.currentItem?.id == song.id ||
                                    playerVM.lastPlayed?.id == song.id)) {
                              playerVM.play();
                            }
                            Get.toNamed(AppRoutes.player);
                          }
                        },

                        child: SizedBox(
                          width: .infinity,
                          child: AudioCupertinoContextMenu(
                            actions: [
                              AudioCupertinoMenuItem(
                                title: audioVM.isSongSelected(song.id)
                                    ? "Quitar"
                                    : "Seleccionar",
                                icon: audioVM.isSongSelected(song.id)
                                    ? CupertinoIcons.minus
                                    : CupertinoIcons.add,
                                onTap: () {
                                  audioVM.selectSong(song.id);
                                },
                              ),
                              AudioCupertinoMenuItem(
                                title: "Agregar a playlist",
                                icon: CupertinoIcons.add_circled,
                                onTap: () {
                                  showPlaylistDialog(song, audioVM);
                                },
                              ),
                              AudioCupertinoMenuItem(
                                title: favoriteVM.isFavorite(song.id)
                                    ? "Ya no me gusta"
                                    : "Me gusta",
                                icon: !favoriteVM.isFavorite(song.id)
                                    ? CupertinoIcons.heart
                                    : CupertinoIcons.heart_fill,
                                iconColor: Colors.pinkAccent,
                                onTap: () async {
                                  await favoriteVM.toggleFavorite(
                                    song: song.toMediaItem(),
                                  );
                                },
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
                              isFavorite: favoriteVM.favorites.any(
                                (e) => e.id == song.id,
                              ),
                              isSelected: audioVM.isSongSelected(song.id),
                              showIsPlaying: true,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
  }

  void showPlaylistDialog(MediaItemData song, AudioViewModel audioVM) {
    Get.dialog(AddPlaylistForm());
  }
}

import 'package:beatsvibe/components/audio_cupertino.dart';
import 'package:beatsvibe/components/audio_item.dart' show AudioItem;
import 'package:beatsvibe/vm/favorites_vm.dart';
import 'package:beatsvibe/vm/player_vm.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class FavoritesView extends StatefulWidget {
  const FavoritesView({super.key});

  @override
  State<FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView> with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();

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
    final favoritesVM = Provider.of<FavoritesViewModel>(context, listen: false);

    if (playerVM.currentItem != null && favoritesVM.favorites.isNotEmpty) {
      final reversedFavorites = favoritesVM.favorites.reversed.toList();
      final index = reversedFavorites.indexWhere((s) => s.id == playerVM.currentItem!.id);
      if (index != -1 && _scrollController.hasClients) {
        final offset = index * 55.0;
        _scrollController.jumpTo(offset);
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
    final playerVM = Provider.of<PlayerViewModel>(context, listen: false);
    return Consumer<FavoritesViewModel>(
      builder: (context, favoritesVM, child) {
        if (favoritesVM.favorites.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(CupertinoIcons.heart, size: 50),
                Text(
                  "No hay canciones favoritas",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          );
        }
        return ListView.builder(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          itemCount: favoritesVM.favorites.length,
          itemBuilder: (context, index) {
            final song = favoritesVM.favorites[index];
            return GestureDetector(
              onTap: () {
                if (playerVM.currentItem?.id != song.id) {
                  playerVM.play(song: song, playlist: favoritesVM.favorites);
                }
              },
              child: AudioCupertinoContextMenu(
                actions: [
                  AudioCupertinoMenuItem(title: "Seleccionar", onTap: () {}),
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
                    title: favoritesVM.favorites.contains(song)
                        ? "Ya no me gusta"
                        : "Me gusta",
                    icon:
                        favoritesVM.favorites.contains(song)
                            ? CupertinoIcons.heart_fill
                            : CupertinoIcons.heart,
                    onTap: () {
                      favoritesVM.toggleFavorite(song: song.toMediaItem());
                    },
                  ),
                ],
                child: AudioItem(song: song, index: index, showIsPlaying: true,),
              ),
            );
          },
        );
      },
    );
  }
}

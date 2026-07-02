import 'package:beatsvibe/components/audio_cupertino.dart';
import 'package:beatsvibe/components/audio_item.dart' show AudioItem;
import 'package:beatsvibe/vm/favorites_vm.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class FavoritesView extends StatefulWidget {
  const new({super.key});

  @override
  State<FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView> {
  @override
  Widget build(BuildContext context) {
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
          physics: const BouncingScrollPhysics(),
          itemCount: favoritesVM.favorites.length,
          itemBuilder: (context, index) {
            final song = favoritesVM.favorites[index];
            return GestureDetector(
              onTap: () {},
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
                    title: "Eliminar",
                    icon: CupertinoIcons.delete_solid,
                    isDestructive: true,
                    onTap: () {
                      favoritesVM.toggleFavorite(song: song.toMediaItem());
                    },
                  ),
                ],
                child: AudioItem(song: song, index: index),
              ),
            );
          },
        );
      },
    );
  }
}

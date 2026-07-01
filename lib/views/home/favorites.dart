import 'package:beatsvibe/components/audio_item.dart' show AudioItem;
import 'package:beatsvibe/vm/favorites_vm.dart';
import 'package:flutter/material.dart';
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
        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: favoritesVM.favorites.length,
          itemBuilder: (context, index) {
            final song = favoritesVM.favorites[index];
            return AudioItem(
              song: song,
              index: index,
            );
          },
        );
      },
    );
  }
}
import 'package:audio_service/audio_service.dart';
import 'package:beatsvibe/models/mediaitem_data.dart';
import 'package:beatsvibe/service/hive_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FavoritesViewModel extends ChangeNotifier {
  final HiveService _hiveService = HiveService();
  List<MediaItemData> _favorites = [];

  List<MediaItemData> get favorites => _favorites.reversed.toList();

  FavoritesViewModel() {
    _init();
  }

  Future<void> _init() async {
    _favorites = await _hiveService.getFavoriteSongs();
    _favorites = _favorites.reversed.toList();
    notifyListeners();
  }

  Future<void> toggleFavorite({required MediaItem song}) async {
    final isFavorite = _favorites.any((e) => e.id == song.id);
    if (isFavorite) {
      await _hiveService.removeFavoriteSong(song.id);
      await _init();
    } else {
      final data = MediaItemData.fromMediaItem(song);
      if (data != null) {
        await _hiveService.addFavoriteSong(data);
        await _init();
        Fluttertoast.showToast(
          msg: "Canción agregada a favoritos",
          gravity: ToastGravity.BOTTOM,
          fontSize: 14,
          backgroundColor: Colors.pinkAccent,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG,
        );
      }
    }
  }

  bool isFavorite(String id) {
    return _favorites.any((e) => e.id == id);
  }
}

import 'package:audio_service/audio_service.dart';
import 'package:beatsvibe/models/mediaitem_data.dart';
import 'package:beatsvibe/service/hive_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FavoritesViewModel extends ChangeNotifier {
  final HiveService _hiveService = HiveService();
  List<MediaItemData> _favorites = [];

  List<MediaItemData> get favorites => _favorites;

  FavoritesViewModel() {
    _init();
  }

  Future<void> _init() async {
    _favorites = await _hiveService.getFavoriteSongs();
    notifyListeners();
  }

  Future<void> toggleFavorite({required MediaItem song}) async {
    final isFavorite = _favorites.any((e) => e.title == song.title);
    if (isFavorite) {
      await _hiveService.removeFavoriteSong(song.id);
      await _init();
    } else {
      final data = MediaItemData.fromMediaItem(song);
      if (data != null) {
        await _hiveService.addFavoriteSong(data);
        await _init();
      }
      Fluttertoast.showToast(
        msg: "Agregado a favoritos",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.pinkAccent,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }
}

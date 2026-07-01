import 'package:audio_service/audio_service.dart';
import 'package:beatsvibe/models/mediaitem_data.dart';
import 'package:beatsvibe/service/hive_service.dart';
import 'package:flutter/material.dart';

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

  Future<void> toggleFavorite({required MediaItem song}) async {}
}

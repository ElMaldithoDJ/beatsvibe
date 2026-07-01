import 'package:beatsvibe/models/playlist_data.dart';
import 'package:beatsvibe/service/hive_service.dart';
import 'package:flutter/material.dart';

class PlaylistViewModel extends ChangeNotifier {
  final HiveService _hiveService = HiveService();

  List<PlaylistModelData> _playlists = [];
  List<PlaylistModelData> get playlists => _playlists;

  PlaylistViewModel() {
    onInit();
  }

  void onInit() async {
    final lists = await _hiveService.getPlaylists();
    if (lists.isNotEmpty) {
      _playlists = lists;
      notifyListeners();
    } else {
      _playlists = [];
      notifyListeners();
    }
  }

  Future<void> createPlaylist(PlaylistModelData playlist) async {
    final id = await _hiveService.getPlaylists();
    final newPlaylist = PlaylistModelData(
      id: "${id.length + 1}",
      title: playlist.title,
      description: playlist.description,
      artwork: playlist.artwork,
      songs: playlist.songs,
    );
    await _hiveService.addPlaylist(newPlaylist).whenComplete(() => onInit());
  }

  Future<void> removePlaylist(String id) async {
    await _hiveService.removePlaylist(id).whenComplete(() => onInit());
  }

  Future<void> updatePlaylist(PlaylistModelData playlist) async {
    await _hiveService.updatePlaylist(playlist).whenComplete(() => onInit());
  }
}

import 'package:beatsvibe/models/mediaitem_data.dart';
import 'package:beatsvibe/models/playlist_data.dart';
import 'package:beatsvibe/service/hive_service.dart';
import 'package:flutter/material.dart';

class PlaylistViewModel extends ChangeNotifier {
  final HiveService _hiveService = HiveService();

  List<PlaylistModelData> _playlists = [];
  List<PlaylistModelData> get playlists => _playlists;

  final List<MediaItemData> _selectedSongs = [];
  List<MediaItemData> get selectedSongs => _selectedSongs;

  void addSelectedSong(MediaItemData song) {
    if (!_selectedSongs.contains(song)) {
      _selectedSongs.add(song);
      notifyListeners();
    }
  }

  void removeSelectedSong(MediaItemData song) {
    _selectedSongs.remove(song);
    notifyListeners();
  }

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

  Future<PlaylistModelData?> getPlaylist(String id) async {
    return await _hiveService.getPlaylist(id);
  }

  Future<void> removePlaylist(String id) async {
    await _hiveService.removePlaylist(id).whenComplete(() => onInit());
  }

  Future<void> updatePlaylist(PlaylistModelData playlist) async {
    await _hiveService.updatePlaylist(playlist).whenComplete(() => onInit());
  }

  void clearSelectedSongs() {
    _selectedSongs.clear();
    notifyListeners();
  }
}

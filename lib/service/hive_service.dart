import 'package:beatsvibe/models/mediaitem_data.dart';
import 'package:beatsvibe/models/playlist_data.dart';
import 'package:flutter/material.dart' show ThemeMode;
import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static final String _songsBox = 'songs';
  static final String _playlistsBox = 'playlists';
  static final String _favoriteSongsBox = 'favorite_songs';
  static final String _recentlyPlayedBox = 'recently_played';
  static final String _lastPlayedSongBox = 'last_played';
  static final String _themeBox = 'theme';

  // Get all songs
  Future<List<MediaItemData>> getAllSongs() async {
    final box = await Hive.openBox(_songsBox);
    if (box.isNotEmpty) {
      return box.values
          .map((e) => MediaItemData.fromJson(e as Map<dynamic, dynamic>))
          .toList();
    }
    return [];
  }

  Future<void> saveAllSongs(List<MediaItemData> songs) async {
    songs.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
    final box = await Hive.openBox(_songsBox);
    for (var song in songs) {
      await box.put(song.id, song.toJson());
    }
  }

  // Get favorite songs
  Future<List<MediaItemData>> getFavoriteSongs() async {
    final box = await Hive.openBox(_favoriteSongsBox);
    if (box.isNotEmpty) {
      return box.values
          .map((e) => MediaItemData.fromJson(e as Map<dynamic, dynamic>))
          .toList();
    }
    return [];
  }

  // Add favorite song
  Future<void> addFavoriteSong(MediaItemData song) async {
    final box = await Hive.openBox(_favoriteSongsBox);
    await box.put(song.id, song.toJson());
  }

  // Remove favorite song
  Future<void> removeFavoriteSong(String id) async {
    final box = await Hive.openBox(_favoriteSongsBox);
    await box.delete(id);
  }

  // Get recently played songs
  Future<List<MediaItemData>> getRecentlyPlayedSongs() async {
    final box = await Hive.openBox(_recentlyPlayedBox);
    if (box.isNotEmpty) {
      return box.values
          .map((e) => MediaItemData.fromJson(e as Map<dynamic, dynamic>))
          .toList();
    }
    return [];
  }

  // Get theme mode
  Future<ThemeMode> getThemeMode() async {
    final box = await Hive.openBox<ThemeMode>(_themeBox);
    return box.get(_themeBox, defaultValue: ThemeMode.system)!;
  }

  // Get Playlists
  Future<List<PlaylistModelData>> getPlaylists() async {
    final box = await Hive.openBox(_playlistsBox);
    if (box.isNotEmpty) {
      return box.values
          .map((e) => PlaylistModelData.fromJson(e as Map<dynamic, dynamic>))
          .toList();
    }
    return [];
  }

  // Add playlist
  Future<void> addPlaylist(PlaylistModelData playlist) async {
    final box = await Hive.openBox(_playlistsBox);
    await box.put(playlist.id, playlist.toJson());
  }

  // Remove playlist
  Future<void> removePlaylist(String id) async {
    final box = await Hive.openBox(_playlistsBox);
    await box.delete(id);
  }

  // Update playlist
  Future<void> updatePlaylist(PlaylistModelData playlist) async {
    final box = await Hive.openBox(_playlistsBox);
    await box.put(playlist.id, playlist.toJson());
  }

  // Check if song is favorite
  Future<bool> isFavorite(String title) async {
    final box = await Hive.openBox(_favoriteSongsBox);
    return box.containsKey(title);
  }

  // save last played song
  Future<void> saveLastPlayed(MediaItemData song) async {
    final box = await Hive.openBox(_lastPlayedSongBox);
    await box.clear();
    await box.put(song.id, song.toJson());
  }

  // Get last played song
  Future<MediaItemData?> getLastPlayed() async {
    final box = await Hive.openBox(_lastPlayedSongBox);
    if (box.isNotEmpty) {
      final value = box.values.first;
      return MediaItemData.fromJson(value as Map<dynamic, dynamic>);
    }
    return null;
  }

  Future<PlaylistModelData?> getPlaylist(String id) async {
    final box = await Hive.openBox(_playlistsBox);
    final value = box.get(id);
    if (value != null) {
      return PlaylistModelData.fromJson(value as Map<dynamic, dynamic>);
    }
    return null;
  }
}

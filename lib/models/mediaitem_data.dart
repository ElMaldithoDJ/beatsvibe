import 'package:audio_service/audio_service.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:json_annotation/json_annotation.dart';

enum AudioFormat {
  mp3,
  flac,
  aac,
  wav,
  alac,
  m4a,
}

@HiveType(typeId: 1)
@JsonSerializable()
class MediaItemData {
  @HiveField(1)
  final String id;
  @HiveField(2)
  final String title;
  @HiveField(3)
  final String? artist;
  @HiveField(4)
  final String? album;
  @HiveField(5)
  final String? genre;
  @HiveField(6)
  final Uri? artUri;
  @HiveField(7)
  final Duration? duration;
  @HiveField(8)
  final String audioUrl;
  @HiveField(9)
  final AudioFormat? format;
  @HiveField(10)
  final int? bitrate;
  @HiveField(11)
  final Duration? position;

  MediaItemData({
    required this.id,
    required this.title,
    required this.audioUrl,
    this.artist,
    this.album,
    this.genre,
    this.artUri,
    this.duration,
    required this.format,
    this.bitrate,
    this.position = Duration.zero,
  });

  factory MediaItemData.fromJson(Map<dynamic, dynamic> json) {
    return MediaItemData(
      id: json['id'] as String,
      title: json['title'] as String,
      audioUrl: json['audioUrl'] as String,
      artist: json['artist'] as String,
      album: json['album'] as String,
      genre: json['genre'] as String,
      artUri: json['artUri'] != null ? Uri.parse(json['artUri']) : null,
      duration: Duration(seconds: json['duration']),
      format: json['format'] != null
          ? AudioFormat.values.firstWhere((e) => e.name == json['format'])
          : null,
      bitrate: json['bitrate'] as int?,
      position: json['position'] != null
          ? Duration(seconds: json['position'])
          : Duration.zero,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'audioUrl': audioUrl,
      'artist': artist,
      'album': album,
      'genre': genre,
      'artUri': artUri?.toString(),
      'duration': duration?.inSeconds,
      'format': format?.name,
      'bitrate': bitrate,
      'position': position?.inSeconds,
    };
  }

  MediaItem toMediaItem() {
    return MediaItem(
      id: id,
      title: title,
      artist: artist,
      album: album,
      genre: genre,
      artUri: artUri,
      duration: duration,
      extras: <String, dynamic>{
        'audioUrl': audioUrl,
        'format': format?.name,
        'bitrate': bitrate,
      },
    );
  }

  static MediaItemData? fromMediaItem(MediaItem? mediaItem) {
    if (mediaItem == null) return null;
    return MediaItemData(
      id: mediaItem.id,
      title: mediaItem.title,
      artist: mediaItem.artist,
      album: mediaItem.album,
      genre: mediaItem.genre,
      artUri: mediaItem.artUri,
      duration: mediaItem.duration,
      audioUrl: mediaItem.extras!['audioUrl'],
      format: AudioFormat.values.firstWhere(
        (e) => e.name == mediaItem.extras!['format'],
      ),
      bitrate: mediaItem.extras!['bitrate'],
    );
  }
}

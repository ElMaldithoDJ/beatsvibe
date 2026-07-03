import 'dart:io';

import 'package:beatsvibe/util/id_generator.dart';
import 'package:path_provider/path_provider.dart';

import 'package:audio_info/audio_info.dart';
import 'package:beatsvibe/models/mediaitem_data.dart';
import 'package:beatsvibe/models/storage_isolate_model.dart';
import 'package:beatsvibe/service/utfconverter_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

const List<String> _validExtensions = [
  '.mp3',
  '.wav',
  '.m4a',
  '.aac',
  '.flac',
  '.alac',
];

class FetchAudioService {
  static Future<List<MediaItemData>> scanLocalFiles() async {
    String dir = (await FilePicker.platform.getDirectoryPath(
      dialogTitle: 'S1elecciona una carpeta de música',
    ))!;

    final RootIsolateToken? token = RootIsolateToken.instance;
    if (token == null) return [];

    final Directory appDocDir = await getApplicationDocumentsDirectory();

    StorageIsolateModel model = StorageIsolateModel(
      path: dir,
      token: token,
      appDocDir: appDocDir.path,
    );

    try {
      return await compute(_scanFiles, model);
    } catch (_) {
      return [];
    }
  }
}

@pragma('vm:entry-point')
Future<List<MediaItemData>> _scanFiles(StorageIsolateModel model) async {
  final UtfConverterService utfConverter = UtfConverterService();
  List<MediaItemData> songs = [];
  Directory musicDirectory = Directory(model.path);

  BackgroundIsolateBinaryMessenger.ensureInitialized(model.token);

  if (!await musicDirectory.exists()) {
    await musicDirectory.create(recursive: true);
  }
  List<FileSystemEntity> files = (await musicDirectory
      .list(recursive: false)
      .toList());
  try {
    for (int i = 0; i < files.length; i++) {
      FileSystemEntity file = files[i];
      if (file is File) {
        String ext = file.path.split('.').last.toLowerCase();
        if (_validExtensions.contains('.$ext')) {
          AudioData? metadata = await AudioInfo.getAudioInfo(file.path);
          Uint8List? artwork = await AudioInfo.getAudioImage(file.path);

          Directory coversDir = Directory('${model.appDocDir}/covers');
          if (!await coversDir.exists()) {
            await coversDir.create(recursive: true);
          }

          Uri? artUri;
          if (metadata != null && metadata.hasArtwork && artwork != null) {
            String sanitizedTitle = (metadata.title).replaceAll(
              RegExp(r'[\\/:*?"<>|]'),
              '_',
            );
            String sanitizedArtist = (metadata.artist).replaceAll(
              RegExp(r'[\\/:*?"<>|]'),
              '_',
            );
            File artworkFile = File(
              '${coversDir.path}/${sanitizedTitle}_$sanitizedArtist.jpg',
            );
            if (!await artworkFile.exists()) {
              await artworkFile.writeAsBytes(artwork);
            }
            artUri = Uri.file(artworkFile.path);
          }

          try {
            String id = IDGenerator.generateId(length: 35);
            bool isIncluded = songs.any((e) => e.id == id);
            while (isIncluded) {
              id = IDGenerator.generateId(length: 35);
            }
            songs.add(
              MediaItemData(
                id: id,
                audioUrl: file.path,
                title: utfConverter.convertToUtf8(
                  metadata?.title ?? 'Titulo Desconocido',
                ),
                artist: utfConverter.convertToUtf8(
                  metadata?.artist ?? 'Artista Desconocido',
                ),
                album: utfConverter.convertToUtf8(
                  metadata?.album ?? 'Album Desconocido',
                ),
                genre: utfConverter.convertToUtf8(
                  metadata?.genre ?? 'Genero Desconocido',
                ),
                duration: Duration(seconds: metadata?.durationSec ?? 0),
                artUri: artUri,
                format: AudioFormat.values.firstWhere(
                  (e) => e.name.startsWith(ext),
                ),
                bitrate: metadata?.bitrate,
              ),
            );
          } catch (_) {
            String id = IDGenerator.generateId(length: 35);
            bool isIncluded = songs.any((e) => e.id == id);
            while (isIncluded) {
              id = IDGenerator.generateId(length: 35);
            }
            songs.add(
              MediaItemData(
                id: id,
                title: file.path.split('/').last.split('.').first,
                audioUrl: file.path,
                artist: 'Artista Desconocido',
                album: 'Album Desconocido',
                genre: 'Genero Desconocido',
                duration: Duration(seconds: metadata?.durationSec ?? 0),
                artUri: artUri,
                format: AudioFormat.values.firstWhere(
                  (e) => e.name.startsWith(ext),
                ),
                bitrate: metadata?.bitrate,
              ),
            );
          }
        }
      }
    }
    return songs;
  } catch (_) {
    return [];
  }
}

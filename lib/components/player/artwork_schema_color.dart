import 'dart:convert';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:beatsvibe/vm/player_vm.dart';
import 'package:flutter/material.dart';
import 'package:image_color_scheme/image_color_scheme.dart';
import 'package:provider/provider.dart';

/// Widget que extrae dinámicamente un [ColorScheme] y construye un degradado
/// a partir de la carátula [artUri] de un [MediaItem] usando la librería `image_color_scheme`.
///
/// Si [artUri] es null o falla, se vuelve transparente.
class ArtworkSchemaColor extends StatelessWidget {
  final MediaItem? mediaItem;
  final Widget? child;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  final Duration duration;
  final Curve curve;

  const ArtworkSchemaColor({
    super.key,
    this.mediaItem,
    this.child,
    this.begin = Alignment.topCenter,
    this.end = Alignment.bottomCenter,
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.easeInOut,
  });

  ImageProvider? _getImageProvider(Uri uri) {
    try {
      if (uri.scheme == 'file') {
        return FileImage(File.fromUri(uri));
      } else if (uri.scheme == 'http' || uri.scheme == 'https') {
        return NetworkImage(uri.toString());
      } else if (uri.path.isNotEmpty) {
        final bytes = base64Decode(uri.path);
        return MemoryImage(bytes);
      }
    } catch (e) {
      debugPrint('Error obteniendo ImageProvider en ArtworkSchemaColor: $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerViewModel>(
      builder: (context, playerVM, _) {
        final item = mediaItem ?? playerVM.currentItem;
        final uri = item?.artUri;

        if (uri == null) {
          return AnimatedContainer(
            duration: duration,
            curve: curve,
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            child: child,
          );
        }

        final provider = _getImageProvider(uri);
        if (provider == null) {
          return AnimatedContainer(
            duration: duration,
            curve: curve,
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            child: child,
          );
        }

        return ImageColorSchemeBuilder(
          provider: provider,
          onError: (error, stackTrace) {
            debugPrint('Error extrayendo ColorScheme con ImageColorSchemeBuilder: $error');
          },
          builder: (context, colorScheme, childWidget) {
            return AnimatedContainer(
              duration: duration,
              curve: curve,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: begin,
                  end: end,
                  colors: [
                    colorScheme.primaryContainer.withValues(alpha: 0.3),
                    colorScheme.primaryFixed,
                    colorScheme.secondaryContainer,
                  ],
                ),
              ),
              child: childWidget,
            );
          },
          child: child,
        );
      },
    );
  }
}
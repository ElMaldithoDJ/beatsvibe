import 'dart:io';

import 'package:flutter/material.dart';
import 'package:palette_generator_master/palette_generator_master.dart';

class ColorsModel {
  final Color? vibrant;
  final Color? lightVibrant;
  final Color? darkVibrant;
  final Color? muted;
  final Color? lightMuted;
  final Color? darkMuted;
  final Color? dominantColor;
  final Color? darkDominantColor;
  final List<Color> palette;

  const ColorsModel({
    this.vibrant,
    this.lightVibrant,
    this.darkVibrant,
    this.muted,
    this.lightMuted,
    this.darkMuted,
    this.dominantColor,
    this.darkDominantColor,
    this.palette = const [],
  });

  /// Extrae los colores dominantes de una imagen dado su [imagePath] (ruta local).
  ///
  /// Retorna un [ColorsModel] con los colores vibrant, muted y la paleta completa.
  /// Retorna `null` si ocurre un error al procesar la imagen.
  static Future<ColorsModel?> fromImagePath(Uri imagePath) async {
    try {
      final File imageFile = File.fromUri(imagePath);
      if (!imageFile.existsSync()) return null;

      final ImageProvider imageProvider = FileImage(imageFile);

      final PaletteGeneratorMaster generator =
          await PaletteGeneratorMaster.fromImageProvider(
            imageProvider,
            maximumColorCount: 16,
          );
      return ColorsModel(
        vibrant: generator.vibrantColor?.color,
        lightVibrant: generator.lightVibrantColor?.color,
        darkVibrant: generator.darkVibrantColor?.color,
        muted: generator.mutedColor?.color,
        lightMuted: generator.lightMutedColor?.color,
        darkMuted: generator.darkMutedColor?.color,
        dominantColor: generator.dominantColor?.color,
        darkDominantColor: darkModeColor(generator.dominantColor!.color),
        palette: generator.paletteColors.map((e) => e.color).toList(),
      );
    } catch (_) {
      return null;
    }
  }

  /// Obtiene el color de contraste (blanco o negro) dado un [color]
  static Color getContrastColor(Color color) {
    final double brightness = color.computeLuminance();
    return brightness < 0.5 ? Colors.white : Colors.black;
  }

  /// Obtiene el color dominante en modo oscuro
  static Color darkModeColor(Color color) {
    final double brightness = color.computeLuminance();
    final double darkAlpha = brightness < 0.5 ? .85 : .9;
    return color.withValues(alpha: darkAlpha);
  }

  /// Obtiene un color filtrado de la paleta
  static Color getFilteredColor(Color color) {
    final double brightness = color.computeLuminance();
    return brightness < 0.5 ? Colors.white : Colors.black;
  }
}

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
  final Color? lightDominantColor;
  final Color? darkDominantColor;
  final Color? filteredColor;
  final List<Color> palette;


  const ColorsModel({
    this.vibrant,
    this.filteredColor,
    this.lightVibrant,
    this.darkVibrant,
    this.muted,
    this.lightMuted,
    this.darkMuted,
    this.dominantColor,
    this.lightDominantColor,
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
            targets: [
              // Create custom target
              PaletteTargetMaster(
                saturationWeight: 0.8,
                lightnessWeight: 0.6,
                populationWeight: 0.4,
                minimumSaturation: 0.3,
                maximumSaturation: 0.9,
                minimumLightness: 0.2,
                maximumLightness: 0.8,
                targetSaturation: 0.6,
                targetLightness: 0.5,
                isExclusive: true,
              ),
            ],
          );
      return ColorsModel(
        vibrant: generator.vibrantColor?.color,
        lightVibrant: generator.lightVibrantColor?.color,
        darkVibrant: generator.darkVibrantColor?.color,
        muted: generator.mutedColor?.color,
        lightMuted: generator.lightMutedColor?.color,
        darkMuted: generator.darkMutedColor?.color,
        dominantColor: generator.dominantColor?.color,
        lightDominantColor: lightModeColor(generator.dominantColor!.color),
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

  /// Obtiene el color dominante en modo oscuro.
  /// Si el color es claro (luminance >= 0.5), reduce su lightness HSL
  /// para devolver una versión oscura del mismo tono.
  static Color darkModeColor(Color color) {
    final double luminance = color.computeLuminance();
    if (luminance < 0.2) return color; // ya es oscuro, no hace falta cambiarlo

    final HSLColor hsl = HSLColor.fromColor(color);
    // Mapea la lightness actual a un rango oscuro (máx 0.25)
    final double targetLightness = (hsl.lightness * 0.25).clamp(0.05, 0.25);
    return hsl.withLightness(targetLightness).toColor();
  }

  /// Obtiene el color dominante en modo claro.
  /// Si el color es oscuro (luminance < 0.5), aumenta su lightness HSL
  /// para devolver una versión clara del mismo tono.
  static Color lightModeColor(Color color) {
    final double luminance = color.computeLuminance();
    if (luminance >= 0.8) return color; // ya es muy claro, no hace falta cambiarlo

    final HSLColor hsl = HSLColor.fromColor(color);
    // Mapea la lightness actual a un rango claro (mín 0.7)
    final double targetLightness = (hsl.lightness * 0.5).clamp(0.7, 1);
    return hsl.withLightness(targetLightness).toColor();
  }

  /// Filtra un color para garantizar que sea visible:
  /// clampea la saturación a un mínimo y ajusta la luminosidad
  /// a un rango [minL, maxL] para evitar colores demasiado oscuros o lavados.
  static Color getFilteredColor(
    Color color, {
    double minSaturation = 0.3,
    double minLightness = 0.2,
    double maxLightness = 0.8,
  }) {
    final HSLColor hsl = HSLColor.fromColor(color);
    final double s = hsl.saturation.clamp(minSaturation, 1.0);
    final double l = hsl.lightness.clamp(minLightness, maxLightness);
    return hsl.withSaturation(s).withLightness(l).toColor();
  }

  /// Harmoniza un color según el brillo de la interfaz.
  /// En modo oscuro aplica [darkModeColor]; en modo claro garantiza
  /// que el color no sea tan oscuro que resulte invisible.
  static Color getHarmonizedColor(Color color, Brightness brightness) {
    if (brightness == Brightness.dark) {
      return darkModeColor(color);
    }
    // Modo claro: asegura lightness mínima para que el color sea legible
    final HSLColor hsl = HSLColor.fromColor(color);
    final double l = hsl.lightness.clamp(0.35, 0.75);
    return hsl.withLightness(l).toColor();
  }

  /// Calcula un gradiente entre dos colores usando interpolación HSL
  /// que mantiene constante el tono (hue) y ajusta la lightness de forma suave.
  /// Útil para fondos, barras de progreso y efectos visuales.
  ///
  /// [steps] debe ser >= 2 para producir un gradiente válido.
  static LinearGradient getHSLGradient(Color colorA, Color colorB, int steps) {
    assert(
      steps >= 2,
      'steps debe ser >= 2 para construir un gradiente válido',
    );

    final HSLColor hslA = HSLColor.fromColor(colorA);
    final HSLColor hslB = HSLColor.fromColor(colorB);
    final List<Color> colors = [];

    // Construye la rampa de colores interpolando HSL manualmente
    // (double no tiene método .lerp() en Dart)
    for (int i = 0; i < steps; i++) {
      final double t = i / (steps - 1);
      final double h = hslA.hue + (hslB.hue - hslA.hue) * t;
      final double s =
          hslA.saturation + (hslB.saturation - hslA.saturation) * t;
      final double l = hslA.lightness + (hslB.lightness - hslA.lightness) * t;
      // fromAHSL recibe parámetros posicionales: (alpha, hue, saturation, lightness)
      colors.add(HSLColor.fromAHSL(1.0, h, s, l).toColor());
    }

    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: colors,
    );
  }
  /// Aclara [color] en el espacio HSL.
  ///
  /// [amount] va de `0.0` (sin cambio) a `1.0` (blanco puro).
  /// Internamente incrementa la luminosidad HSL y recorta el resultado entre 0 y 1.
  ///
  /// Ejemplo:
  /// ```dart
  /// final lighter = ColorsModel.lighten(Colors.blue, 0.3);
  /// ```
  static Color lighten(Color color, double amount) {
    assert(amount >= 0.0 && amount <= 1.0, 'amount debe estar entre 0.0 y 1.0');
    final hsl = HSLColor.fromColor(color);
    return hsl
        .withLightness((hsl.lightness + amount).clamp(0.0, 1.0))
        .toColor();
  }

  /// Oscurece [color] en el espacio HSL.
  ///
  /// [amount] va de `0.0` (sin cambio) a `1.0` (negro puro).
  /// Internamente decrementa la luminosidad HSL y recorta el resultado entre 0 y 1.
  ///
  /// Ejemplo:
  /// ```dart
  /// final darker = ColorsModel.darken(Colors.blue, 0.3);
  /// ```
  static Color darken(Color color, double amount) {
    assert(amount >= 0.0 && amount <= 1.0, 'amount debe estar entre 0.0 y 1.0');
    final hsl = HSLColor.fromColor(color);
    return hsl
        .withLightness((hsl.lightness - amount).clamp(0.0, 1.0))
        .toColor();
  }
}

import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PlayerSettingsView extends StatefulWidget {
  const PlayerSettingsView({super.key});

  @override
  State<PlayerSettingsView> createState() => _PlayerSettingsViewState();
}

class _PlayerSettingsViewState extends State<PlayerSettingsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuraciones del reproductor'),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(CupertinoIcons.back),
        ),
      ),
      body: Center(
        child: Text('Reproducción'),
      ),
    );
  }
}
import 'package:beatsvibe/models/playlist_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../vm/playlist_vm.dart' show PlaylistViewModel;

class DialogPlaylistForm extends StatefulWidget {
  const DialogPlaylistForm({super.key});

  @override
  State<DialogPlaylistForm> createState() => _DialogPlaylistFormState();
}

class _DialogPlaylistFormState extends State<DialogPlaylistForm> {
  final _nameController = TextEditingController();
  FocusNode nameFocusNode = FocusNode();

  @override
  void dispose() {
    _nameController.dispose();
    nameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final playlistVm = Provider.of<PlaylistViewModel>(context, listen: false);
    return Container(
      width: Get.width * .85,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Material(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Crear Playlist",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _nameController,
                      focusNode: nameFocusNode,
                      decoration: InputDecoration(
                        hintText: "Nombre de la Playlist",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: double.maxFinite,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).colorScheme.surface,
                        ),
                        child: Center(
                          child: Text(
                            "+ Agregar Canciónes",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text("Cancelar"),
                  ),
                  SizedBox(width: 10),
                  TextButton(
                    onPressed: () async {
                      final playlist = PlaylistModelData(
                        title: _nameController.text,
                        songs: [],
                      );
                      playlistVm.createPlaylist(playlist).whenComplete(() => Get.back());
                    },
                    child: Text("Crear"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:beatsvibe/models/playlist_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../vm/playlist_vm.dart' show PlaylistViewModel;

class PlayListFormView extends StatefulWidget {
  const PlayListFormView({super.key});

  @override
  State<PlayListFormView> createState() => _PlayListFormViewState();
}

class _PlayListFormViewState extends State<PlayListFormView> {
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
    final playlistVm = Provider.of<PlaylistViewModel>(context, listen: true);
    return Scaffold(
      appBar: AppBar(title: Text("Crear Playlist")),
      body: Padding(
        padding: const .symmetric(vertical: 8, horizontal: 16),
        child: SingleChildScrollView(
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
                      onChanged: (value) {
                        setState(() {});
                      },
                      onTapOutside: (event) {
                        nameFocusNode.unfocus();
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {},
                label: Text("Agregar Canciónes"),
                icon: Icon(Icons.add),
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
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
                    onPressed: _nameController.text.isNotEmpty
                        ? () async {
                            final playlist = PlaylistModelData(
                              title: _nameController.text,
                            );
                            playlistVm
                                .createPlaylist(playlist)
                                .whenComplete(() => Get.back());
                          }
                        : null,
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

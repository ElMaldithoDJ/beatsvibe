import 'package:beatsvibe/models/playlist_data.dart';
import 'package:beatsvibe/routes.dart';
import 'package:beatsvibe/theme.dart';
import 'package:beatsvibe/variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
    final playlistVM = Provider.of<PlaylistViewModel>(context, listen: true);
    return Scaffold(
      appBar: AppBar(title: Text("Crear Playlist")),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const .symmetric(vertical: 8, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: SizedBox(
                  width: 150,
                  height: 150,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Theme.brightnessOf(context) == .dark
                          ? Colors.white.withValues(alpha: .1)
                          : Colors.black.withValues(alpha: .05),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      CupertinoIcons.music_albums,
                      size: 50,
                      color: Theme.brightnessOf(context) == .dark
                          ? Colors.white
                          : Colors.grey,
                    ),
                  ),
                ),
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
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 0,
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
                onPressed: () {
                  Get.toNamed(AppRoutes.songSelector);
                },
                label: const Text("Seleccionar Canciónes"),
                icon: const Icon(CupertinoIcons.music_note),
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ListView.builder(
                itemCount: playlistVM.selectedSongs.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final song = playlistVM.selectedSongs[index];
                  return ListTile(
                    leading: SvgPicture.asset(
                      AppVariables.appLogo,
                      width: 35,
                      height: 35,
                    ),
                    title: Text(song.title),
                    subtitle: song.artist != null && song.artist!.isNotEmpty
                        ? Text(
                            song.artist!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                        : null,
                    trailing: IconButton(
                      icon: const Icon(
                        CupertinoIcons.delete,
                        color: Colors.red,
                        size: 20,
                      ),
                      onPressed: () {
                        playlistVM.removeSelectedSong(song);
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  playlistVM.clearSelectedSongs();
                  setState(() {
                    _nameController.clear();
                  });
                  Get.back();
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: Text("Cancelar"),
              ),
              SizedBox(width: 10),
              TextButton(
                onPressed:
                    _nameController.text.isNotEmpty &&
                        playlistVM.selectedSongs.isNotEmpty
                    ? () async {
                        final playlist = PlaylistModelData(
                          title: _nameController.text,
                          songs: playlistVM.selectedSongs,
                        );
                        await playlistVM.createPlaylist(playlist).whenComplete(
                          () {
                            playlistVM.clearSelectedSongs();
                            Get.back();
                          },
                        );
                      }
                    : null,
                style: TextButton.styleFrom(
                  foregroundColor: AppTheme.primaryColor,
                ),
                child: Text("Crear"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

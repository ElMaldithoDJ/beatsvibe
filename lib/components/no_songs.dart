import 'package:beatsvibe/service/hive_service.dart';
import 'package:beatsvibe/service/permision_service.dart';
import 'package:beatsvibe/variables.dart';
import 'package:beatsvibe/vm/audio_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class NoSongs extends StatefulWidget {
  const NoSongs({super.key});

  @override
  State<NoSongs> createState() => _NoSongsState();
}

class _NoSongsState extends State<NoSongs> {
  PermisionService permisions = PermisionService();
  HiveService hive = HiveService();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final audioVM = Provider.of<AudioViewModel>(context, listen: true);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(AppVariables.appLogo, width: 100, height: 100),
          Text(
            "No se encontraron canciones",
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 10),
          FilledButton(
            onPressed: () async {
              await permisions.checkPermission([.audio, .notification]).then((
                isGranted,
              ) async {
                if (!isGranted) {
                  await permisions
                      .requestPermission([.audio, .notification])
                      .then((_) async {
                        await audioVM.fetchSongs();
                      });
                }
              });
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
            ),
            child: const Text("Escanear", style: TextStyle(color: Colors.white),),
          ),
        ],
      ),
    );
  }
}

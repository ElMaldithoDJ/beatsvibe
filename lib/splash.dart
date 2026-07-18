import 'package:asset_cache/asset_cache.dart' show ImageAssetCache;
import 'package:beatsvibe/routes.dart';
import 'package:beatsvibe/variables.dart';
import 'package:beatsvibe/vm/audio_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final assetCache = ImageAssetCache(basePath: "assets/icons");

  @override
  void initState() {
    super.initState();
    if (mounted) {
      Future.microtask(() {
        Provider.of<AudioViewModel>(
          context,
          listen: false,
        ).onInit().whenComplete(() {
          Future.delayed(
            const Duration(milliseconds: 1500),
            () => Get.offNamed(AppRoutes.home),
          );
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      AppVariables.appLogo,
                      width: 100,
                      height: 70,
                    ),
                    Text(
                      AppVariables.appName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      AppVariables.appSlogan,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                AppVariables.appVersion,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:beatsvibe/vm/player_vm.dart';
import 'package:flutter/material.dart';
import 'package:image_color_scheme/image_color_scheme.dart';
import 'package:provider/provider.dart';

class SchemaColorComponent extends StatefulWidget {
  const SchemaColorComponent({super.key});

  @override
  State<SchemaColorComponent> createState() => _SchemaColorComponentState();
}

class _SchemaColorComponentState extends State<SchemaColorComponent> {
  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerViewModel>(
      builder: (context, playerVM, child) {
        return AnimatedCrossFade(
          firstChild: AnimatedContainer(
            width: double.maxFinite,
            height: double.maxFinite,
            curve: Curves.easeInOut,
            duration: const Duration(seconds: 1),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Theme.of(context).scaffoldBackgroundColor,
                  Theme.of(
                    context,
                  ).scaffoldBackgroundColor.withValues(alpha: .5),
                ],
              ),
            ),
          ),
          secondChild: playerVM.currentItem?.artUri != null
              ? ImageColorSchemeBuilder(
                  provider: Image.file(
                    File.fromUri(playerVM.currentItem!.artUri!),
                  ).image,
                  builder: (context, colorScheme, child) {
                    return Scaffold(
                      appBar: AppBar(
                        toolbarHeight: 0,
                        backgroundColor: Theme.brightnessOf(context) == .dark ? colorScheme.primary.withValues(alpha: .9): colorScheme.primary.withValues(alpha: .9),
                      ),
                      body: AnimatedContainer(
                        width: double.maxFinite,
                        height: double.maxFinite,
                        curve: Curves.easeInOut,
                        duration: const Duration(milliseconds: 500),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              if (Theme.brightnessOf(context) == .dark) ...[
                                colorScheme.inversePrimary.withValues(
                                  alpha: .95,
                                ),
                                colorScheme.primaryContainer.withValues(
                                  alpha: .8,
                                ),
                                colorScheme.inversePrimary.withValues(
                                  alpha: .79,
                                ),
                              ] else ...[
                                colorScheme.primary.withValues(alpha: .9),
                                colorScheme.primary.withValues(alpha: .9),
                                colorScheme.primary.withValues(alpha: .75),
                              ],
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                )
              : Container(),
          crossFadeState: playerVM.currentItem?.artUri == null
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          duration: Duration(milliseconds: 100),
        );
      },
    );
  }
}

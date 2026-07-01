import 'dart:ui';

class StorageIsolateModel {
  final String path;
  final RootIsolateToken token;
  final String appDocDir;
  StorageIsolateModel({
    required this.path,
    required this.token,
    required this.appDocDir,
  });
}

class HiveIsolateModel {
  final RootIsolateToken token;
  HiveIsolateModel({required this.token});
}

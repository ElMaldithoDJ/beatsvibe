import 'package:permission_handler/permission_handler.dart';

class PermisionService {
  Future<bool> checkPermission(List<Permission> permissions) async {
    for (Permission permission in permissions) {
      PermissionStatus status = await permission.status;
      if (!status.isGranted) {
        return false;
      }
      if (status.isDenied) {
        return false;
      }
      if (status.isPermanentlyDenied) {
        return await openAppSettings();
      }
    }
    return true;
  }

  Future<void> requestPermission(List<Permission> permissions) async {
    for (Permission permission in permissions) {
      await permission.request();
    }
  }
}

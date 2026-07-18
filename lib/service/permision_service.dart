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

  Future<bool> requestPermission(List<Permission> permissions) async {
    for (Permission permission in permissions) {
      PermissionStatus status = await permission.request();
      if (!status.isGranted) {
        return false;
      }
      if (status.isDenied) {
        return false;
      }
      if (status.isPermanentlyDenied ||
          status.isRestricted ||
          status.isLimited) {
        return await openAppSettings();
      }
    }
    return true;
  }
}

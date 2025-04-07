import 'package:permission_handler/permission_handler.dart';
class CheckPermission {

Future<void> requestGalleryPermission() async {
  // Check if permission is already granted
  var status = await Permission.photos.status;
  if (status.isDenied) {
    // Request permission
    status = await Permission.photos.request();
  }

  if (status.isPermanentlyDenied) {
    // The user permanently denied the permission. You can redirect them to app settings.
    openAppSettings();
  }
}
}
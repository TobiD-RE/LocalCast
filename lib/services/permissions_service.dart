import 'package:permission_handler/permission_handler.dart';

class PermissionsService {
  static Future<void> requestAllPermissions() async{
    await [
      Permission.bluetooth,
      Permission.bluetoothConnect,
      Permission.bluetoothScan,
      Permission.locationWhenInUse,
      Permission.storage,
      Permission.location,
    ].request();
  }
}
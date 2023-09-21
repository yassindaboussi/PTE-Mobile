import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FileUtils {
  static Future<String?> getDownloadsDirectory() async {
    if (Platform.isAndroid) {
      Directory? externalDir = await getExternalStorageDirectory();
      if (externalDir != null) {
        String downloadsDirPath = '${externalDir.path}/Download';
        return downloadsDirPath;
      }
    }
    return null;
  }
}

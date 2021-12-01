import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:filesize/filesize.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

abstract class FileUtils {
  static List<String> get supportedFileExtensions => ['jpg', 'png', 'pdf'];

  static Future<String> get appPath async => (await getApplicationDocumentsDirectory()).path;

  static Future<String> filePath(String fileName) async => '${await appPath}/$fileName';

  static Future<File?> pickImage({String fileNamePrefix = 'avatar'}) async {
    XFile? image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 1080,
      maxWidth: 1920,
      imageQuality: 80,
    );
    if (image == null) {
      return null;
    }
    String path = await filePath(image.name);
    await image.saveTo(path);
    return File(path);
  }

  static Future<FilePickerResultData?> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: FileUtils.supportedFileExtensions,
    );
    if (result != null && result.files.single.path != null) {
      File file = File(result.files.single.path!);
      PlatformFile platformFile = result.files.first;
      String fileSize = filesize(platformFile.size);
      String path = await filePath(platformFile.name);
      File fileInAppDirectory = await file.rename(path);
      return FilePickerResultData(
        fileInAppDirectory,
        platformFile.name,
        fileSize,
        platformFile.size,
      );
    }
  }

  static Future<bool> exists(String fileName) async {
    String path = await filePath(fileName);
    return File(path).exists();
  }

  static String extension(String fileName) {
    return path.extension(fileName);
  }

  static bool isAudioFile(String fileName) {
    final ext = extension(fileName);
    return ['.mp3', '.ogg', '.wave', '.aac', '.wma', '.amr'].contains(ext);
  }

  static bool isImageFile(String fileName) {
    final ext = extension(fileName);
    return ['.jpg', '.jpeg', '.png', '.tiff', '.webp', '.exif'].contains(ext);
  }
}

class FilePickerResultData {
  FilePickerResultData(this.file, this.fileName, this.fileSize, this.fileSizeBytes);

  final File file;
  final String fileName;
  final String fileSize;
  final int fileSizeBytes;

  int get fileSizeMegaBytes => fileSizeBytes ~/ 1024 ~/ 1024;
}

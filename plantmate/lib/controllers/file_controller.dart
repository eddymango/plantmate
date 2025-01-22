import 'dart:io';
import 'package:get/get.dart';
import '../services/file_service.dart';

class FileController extends GetxController {
  final FileService fileService = Get.put(FileService());

  Future<String?> uploadFile(File file) async {
    try {
      final response = await fileService.uploadFile(file);
      if (response != null) {
        // 서버에서 반환된 파일 URL을 반환
        return response;
      } else {
        // Get.snackbar('Error', '파일 업로드 실패');
        return null;
      }
    } catch (e) {
      // Get.snackbar('Error', '서버 오류: $e');
      return null;
    }
  }
}

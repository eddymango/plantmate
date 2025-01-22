import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class FileService extends GetxService {
  final String baseUrl = 'http://10.0.2.2:3000'; // 서버 URL

  Future<String?> uploadFile(File file) async {
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/file'));

    // 이미지 파일 추가
    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    var response = await request.send();
    if (response.statusCode == 200) {
      var responseBody = await http.Response.fromStream(response);
      var jsonResponse = jsonDecode(responseBody.body);
      return jsonResponse['path']; // 서버에서 반환된 파일 경로
    } else {
      return null;
    }
  }
}

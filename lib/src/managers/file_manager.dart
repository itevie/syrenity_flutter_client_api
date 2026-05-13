import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:syrenity_flutter_client_api/syrenity_flutter_client_api.dart';

class SyFileManager {
  final SyrenityClient client;

  SyFileManager(this.client);

  Future<SyFile> upload(File file) async {
    final bytes = await file.readAsBytes();
    final base64Data = base64Encode(bytes);

    final fileName = file.path.split(Platform.pathSeparator).last;

    // crude mime detection
    final ext = fileName.split('.').last.toLowerCase();

    final mime = switch (ext) {
      'png' => 'image/png',
      'jpg' || 'jpeg' => 'image/jpeg',
      'webp' => 'image/webp',
      'gif' => 'image/gif',
      'pdf' => 'application/pdf',
      _ => 'application/octet-stream',
    };

    final dataUri = 'data:$mime;base64,$base64Data';

    return await client.http.post<SyFile, Map<String, dynamic>>("/api/files", {
      'data': dataUri,
      'file_name': fileName,
    }, (c, v) => SyFile.build(c, v));
  }
}

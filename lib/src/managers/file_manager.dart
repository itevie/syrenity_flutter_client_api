import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:syrenity_flutter_client_api/syrenity_flutter_client_api.dart';

class SyFileManager {
  final SyrenityClient client;

  SyFileManager(this.client);

  Future<SyFile> upload(PlatformFile file) async {
    final bytes = file.bytes ?? await File(file.path!).readAsBytes();

    final base64Data = base64Encode(bytes);

    final ext = file.extension?.toLowerCase();

    final mime = switch (ext) {
      'png' => 'image/png',
      'jpg' || 'jpeg' => 'image/jpeg',
      'webp' => 'image/webp',
      'gif' => 'image/gif',
      'pdf' => 'application/pdf',
      'txt' => 'text/plain',
      _ => 'application/octet-stream',
    };

    final dataUri = 'data:$mime;base64,$base64Data';

    return await client.http.post<SyFile, Map<String, dynamic>>("/api/files", {
      'data': dataUri,
      'file_name': file.name,
    }, (c, v) => SyFile.build(c, v));
  }
}

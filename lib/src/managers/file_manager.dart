import 'dart:convert';
import 'dart:io';

import 'package:syrenity_flutter_client_api/syrenity_flutter_client_api.dart';

class SyFileManager {
  final SyrenityClient client;

  SyFileManager(this.client);

  Future<SyFile> upload(File file) async {
    final bytes = await file.readAsBytes();
    final base64Data = base64Encode(bytes);

    final fileName = file.path.split(Platform.pathSeparator).last;

    return await client.http.post<SyFile, Map<String, dynamic>>("/api/files", {
      'data': base64Data,
      'file_name': fileName,
    }, (c, v) => SyFile.build(c, v));
  }
}

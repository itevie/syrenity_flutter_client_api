import 'package:syrenity_flutter_client_api/src/client.dart';

class SyFile {
  final SyrenityClient client;

  final String id;
  final DateTime createdAt;
  final String fileName;
  final String? originalUrl;
  final String? url;

  SyFile(
    this.client, {
    required this.id,
    required this.createdAt,
    required this.fileName,
    required this.originalUrl,
    required this.url,
  });

  factory SyFile.build(SyrenityClient client, Map<String, dynamic> json) {
    return SyFile(
      client,
      id: json['id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      fileName: json['file_name'] as String,
      originalUrl: json['original_url'] as String?,
      url: json['url'] as String?,
    );
  }
}

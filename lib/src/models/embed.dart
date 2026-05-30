import 'package:syrenity_flutter_client_api/src/client.dart';

class SyEmbed {
  final SyrenityClient client;

  final int id;
  final int messageId;

  final String? title;
  final String? description;
  final int? colour;
  final String? url;

  final String? thumbnailFile;
  final String? imageFile;

  final String? authorName;
  final String? authorIconFile;
  final String? authorUrl;

  final String? footerText;
  final String? footerIconFile;

  final DateTime? timestamp;
  final DateTime createdAt;

  SyEmbed(
    this.client, {
    required this.id,
    required this.messageId,
    required this.title,
    required this.description,
    required this.colour,
    required this.url,
    required this.thumbnailFile,
    required this.imageFile,
    required this.authorName,
    required this.authorIconFile,
    required this.authorUrl,
    required this.footerText,
    required this.footerIconFile,
    required this.timestamp,
    required this.createdAt,
  });

  factory SyEmbed.build(SyrenityClient client, Map<String, dynamic> json) {
    return SyEmbed(
      client,
      id: json['id'] as int,
      messageId: json['message_id'] as int,

      title: json['title'] as String?,
      description: json['description'] as String?,
      colour: json['colour'] as int?,
      url: json['url'] as String?,

      thumbnailFile: json['thumbnail_file'] as String?,
      imageFile: json['image_file'] as String?,

      authorName: json['author_name'] as String?,
      authorIconFile: json['author_icon_file'] as String?,
      authorUrl: json['author_url'] as String?,

      footerText: json['footer_text'] as String?,
      footerIconFile: json['footer_icon_file'] as String?,

      timestamp:
          json['timestamp'] != null
              ? DateTime.parse(json['timestamp'] as String)
              : null,

      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}

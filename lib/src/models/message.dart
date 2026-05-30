import 'package:syrenity_flutter_client_api/src/content_parser/lexer.dart';
import 'package:syrenity_flutter_client_api/src/models/embed.dart';
import 'package:syrenity_flutter_client_api/syrenity_flutter_client_api.dart';

class MessageEditOptions {
  final String? content;

  const MessageEditOptions({this.content});

  Map<String, dynamic> toJson() {
    final body = <String, dynamic>{};

    if (content != null) {
      body["content"] = content;
    }

    return body;
  }
}

class SyMessage {
  final SyrenityClient client;

  final int id;
  final String content;
  final int channelId;
  final DateTime createdAt;

  final int authorId;
  final SyUser author;

  final bool isPinned;
  final bool isEdited;
  final bool isSystem;
  final String? sysType;

  final List<SyReaction> reactions;

  final String? webhookId;
  final SyWebhook? webhook;

  final List<SyEmbed> embeds;

  final int? proxyId;

  SyMessage(
    this.client, {
    required this.id,
    required this.content,
    required this.channelId,
    required this.createdAt,
    required this.authorId,
    required this.author,
    required this.isPinned,
    required this.isEdited,
    required this.isSystem,
    required this.sysType,
    required this.reactions,
    required this.webhookId,
    required this.webhook,
    required this.proxyId,
    required this.embeds,
  });

  factory SyMessage.build(SyrenityClient client, Map<String, dynamic> json) {
    return SyMessage(
      client,
      id: json['id'] as int,
      content: json['content'] as String,
      channelId: json['channel_id'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),

      authorId: json['author_id'] as int,
      author: SyUser.build(client, json['author'] as Map<String, dynamic>),

      isPinned: json['is_pinned'] as bool,
      isEdited: json['is_edited'] as bool,
      isSystem: json['is_system'] as bool,
      sysType: json['sys_type'] as String?,

      reactions:
          (json['reactions'] as List<dynamic>)
              .map((e) => SyReaction.build(client, e as Map<String, dynamic>))
              .toList(),

      embeds:
          (json['embeds'] as List<dynamic>)
              .map((e) => SyEmbed.build(client, e as Map<String, dynamic>))
              .toList(),

      webhookId: json['webhook_id'] as String?,
      webhook:
          json['webhook'] == null
              ? null
              : SyWebhook.build(
                client,
                json['webhook'] as Map<String, dynamic>,
              ),

      proxyId: json['proxy_id'] as int?,
    );
  }

  SyParserResponse parseMarkdown() {
    return SyContentParser(lex(content)).parse();
  }

  Future<void> delete() async {
    await client.http.rawDelete('/api/channels/$channelId/messages/$id', null);
  }

  Future<void> pin() async {
    await client.http.post('/api/channels/$channelId/pins/$id', {}, null);
  }

  Future<void> unpin() async {
    await client.http.delete('/api/channels/$channelId/pins/$id', null);
  }

  Future<SyChannel> fetchChannel() async {
    return await client.channels.fetch(channelId);
  }

  Future<SyMessage> edit(MessageEditOptions options) async {
    return await client.http.patch<SyMessage, Map<String, dynamic>>(
      "/api/channels/$channelId/messages/$id",
      options.toJson(),
      (client, value) => SyMessage.build(client, value),
    );
  }
}

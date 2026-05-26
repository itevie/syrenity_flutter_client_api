import 'package:syrenity_flutter_client_api/syrenity_flutter_client_api.dart';

class ChannelMessageQueryOptions {
  final int? amount;
  final int? startAt;
  final int? fromUser;
  final bool? isPinned;

  ChannelMessageQueryOptions({
    this.amount,
    this.startAt,
    this.fromUser,
    this.isPinned,
  });
}

class SyTextChannel extends SyChannel {
  SyTextChannel(
    super.client, {
    required super.id,
    required super.type,
    required super.guildId,
    required super.name,
    required super.topic,
    required super.isNsfw,
    required super.position,
    super.lastMessageAck,
  });

  Future<SyMessage> send(String content) async {
    return await client.http.post<SyMessage, Map<String, dynamic>>(
      "/api/channels/$id/messages",
      {'content': content},
      (client, value) => SyMessage.build(client, value),
    );
  }

  Future<void> startTyping() async {
    await client.http.post("/api/channels/$id/start-typing", {}, null);
  }

  Future<List<SyMessage>> query([ChannelMessageQueryOptions? options]) async {
    final queryParams = <String, String>{};

    if (options?.amount != null) {
      queryParams['amount'] = options!.amount.toString();
    }
    if (options?.fromUser != null) {
      queryParams['from_user'] = options!.fromUser!.toString();
    }
    if (options?.isPinned != null) {
      queryParams['is_pinned'] = options!.isPinned.toString();
    }
    if (options?.startAt != null) {
      queryParams['start_at'] = options!.startAt!.toString();
    }

    final queryString =
        queryParams.entries.isNotEmpty
            ? '?${queryParams.entries.map((e) => '${e.key}=${Uri.encodeComponent(e.value)}').join('&')}'
            : '';

    return await client.http.get<List<SyMessage>, List<dynamic>>(
      "/api/channels/$id/messages$queryString",
      (c, x) => x.map((v) => SyMessage.build(client, v)).toList(),
    );
  }
}

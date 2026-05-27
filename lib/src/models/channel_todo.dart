import 'package:syrenity_flutter_client_api/syrenity_flutter_client_api.dart';

class TodoChannelMessageQueryOptions {
  final int? amount;
  final int? startAt;
  final int? fromUser;
  final bool? completed;

  TodoChannelMessageQueryOptions({
    this.amount,
    this.startAt,
    this.fromUser,
    this.completed,
  });
}

class SyTodoChannel extends SyChannel {
  SyTodoChannel(
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

  Future<SyTodoItem> send(String name) async {
    return await client.http.post<SyTodoItem, Map<String, dynamic>>(
      "/api/channels/$id/todos",
      {'name': name},
      (client, value) => SyTodoItem.build(client, value),
    );
  }

  Future<List<SyTodoItem>> query([
    TodoChannelMessageQueryOptions? options,
  ]) async {
    final queryParams = <String, String>{};

    if (options?.amount != null) {
      queryParams['amount'] = options!.amount.toString();
    }
    if (options?.fromUser != null) {
      queryParams['from_user'] = options!.fromUser!.toString();
    }
    if (options?.completed != null) {
      queryParams['completed'] = options!.completed.toString();
    }
    if (options?.startAt != null) {
      queryParams['start_at'] = options!.startAt!.toString();
    }

    final queryString =
        queryParams.entries.isNotEmpty
            ? '?${queryParams.entries.map((e) => '${e.key}=${Uri.encodeComponent(e.value)}').join('&')}'
            : '';

    return await client.http.get<List<SyTodoItem>, List<dynamic>>(
      "/api/channels/$id/todos$queryString",
      (c, x) => x.map((v) => SyTodoItem.build(client, v)).toList(),
    );
  }
}

import 'package:syrenity_flutter_client_api/src/content_parser/lexer.dart';
import 'package:syrenity_flutter_client_api/syrenity_flutter_client_api.dart';

class TodoEditOptions {
  final String? name;
  final String? description;
  final bool? completed;
  final int? groupId;

  const TodoEditOptions({
    this.name,
    this.description,
    this.completed,
    this.groupId,
  });

  Map<String, dynamic> toJson() {
    final body = <String, dynamic>{};

    if (name != null) {
      body["name"] = name;
    }

    if (description != null) {
      body["description"] = description;
    }

    if (completed != null) {
      body["completed"] = completed;
    }

    if (groupId != null) {
      body["group_id"] = groupId;
    }

    return body;
  }
}

class SyTodoItem {
  final SyrenityClient client;

  final int id;
  final int channelId;
  final int authorId;
  final String name;
  final String? description;
  final DateTime createdAt;
  final DateTime? completedAt;
  final bool completed;
  final int? groupId;

  SyTodoItem(
    this.client, {
    required this.id,
    required this.channelId,
    required this.authorId,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.completedAt,
    required this.completed,
    required this.groupId,
  });

  factory SyTodoItem.build(SyrenityClient client, Map<String, dynamic> json) {
    return SyTodoItem(
      client,
      id: json['id'] as int,
      channelId: json['channel_id'] as int,
      authorId: json['author_id'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      completedAt:
          json['completed_at'] == null
              ? null
              : DateTime.parse(json['completed_at'] as String),
      completed: json['completed'] as bool,
      groupId: json['group_id'] as int?,
    );
  }

  Future<void> delete() async {
    await client.http.rawDelete('/api/channels/$channelId/todos/$id', null);
  }

  Future<SyTodoItem> edit(TodoEditOptions options) async {
    return await client.http.patch<SyTodoItem, Map<String, dynamic>>(
      "/api/channels/$channelId/todos/$id",
      options.toJson(),
      (client, value) => SyTodoItem.build(client, value),
    );
  }
}

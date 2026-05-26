import 'package:syrenity_flutter_client_api/syrenity_flutter_client_api.dart';

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
}

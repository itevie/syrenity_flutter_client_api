import 'package:syrenity_flutter_client_api/src/client.dart';
import 'package:syrenity_flutter_client_api/src/events.dart';
import 'package:syrenity_flutter_client_api/src/models/channel_text.dart';
import 'package:syrenity_flutter_client_api/src/models/channel_todo.dart';
import 'package:syrenity_flutter_client_api/src/models/message_ack.dart';

enum SyChannelType {
  channel,
  dm,
  todo;

  static SyChannelType fromString(String value) {
    switch (value) {
      case 'channel':
        return SyChannelType.channel;
      case 'dm':
        return SyChannelType.dm;
      case 'to-do':
        return SyChannelType.todo;
      default:
        throw ArgumentError('Invalid channel type: $value');
    }
  }

  String toJson() => name;
}

class SyChannel {
  final SyrenityClient client;

  final int id;
  final SyChannelType type;
  final int? guildId;
  final String name;
  final String? topic;
  final bool isNsfw;
  final int position;
  final SyMessageAck? lastMessageAck;

  SyChannel(
    this.client, {
    required this.id,
    required this.type,
    required this.guildId,
    required this.name,
    required this.topic,
    required this.isNsfw,
    required this.position,
    this.lastMessageAck,
  });

  factory SyChannel.build(SyrenityClient client, Map<String, dynamic> json) {
    final channel = SyChannel(
      client,
      id: json['id'] as int,
      type: SyChannelType.fromString(json['type'] as String),
      guildId: json['guild_id'] as int?,
      name: json['name'] as String,
      topic: json['topic'] as String?,
      isNsfw: json['is_nsfw'] as bool,
      position: json['position'] as int,
      lastMessageAck:
          json['last_message_ack'] != null
              ? SyMessageAck.build(
                client,
                json['last_message_ack'] as Map<String, dynamic>,
              )
              : null,
    );

    client.events.emit(SyEvents.createChannel, channel);

    return channel;
  }

  SyTextChannel asText() {
    if (type != SyChannelType.channel) {
      throw StateError('Channel is not a text channel');
    }

    return this as SyTextChannel;
  }

  SyTodoChannel asTodo() {
    if (type != SyChannelType.todo) {
      throw StateError('Channel is not a todo channel');
    }

    return this as SyTodoChannel;
  }
}

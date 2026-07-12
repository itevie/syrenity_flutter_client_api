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

  String toServerName(SyChannelType type) {
    switch (type) {
      case SyChannelType.channel:
        return "channel";
      case SyChannelType.dm:
        return "dm";
      case SyChannelType.todo:
        return "to-do";
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

  bool isTextChannel() => type == SyChannelType.channel;
  bool isTodoChannel() => type == SyChannelType.todo;

  SyTextChannel asTextChannel() {
    if (type != SyChannelType.channel) {
      throw StateError('Channel is not a text channel');
    }
    return SyTextChannel(
      client,
      id: id,
      type: type,
      guildId: guildId,
      name: name,
      topic: topic,
      isNsfw: isNsfw,
      position: position,
      lastMessageAck: lastMessageAck,
    );
  }

  SyTodoChannel asTodoChannel() {
    if (type != SyChannelType.todo) {
      throw StateError('Channel is not a to-do channel');
    }
    return SyTodoChannel(
      client,
      id: id,
      type: type,
      guildId: guildId,
      name: name,
      topic: topic,
      isNsfw: isNsfw,
      position: position,
      lastMessageAck: lastMessageAck,
    );
  }
}

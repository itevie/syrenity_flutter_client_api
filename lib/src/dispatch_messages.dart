import 'package:syrenity_flutter_client_api/src/ws_messages.dart';
import 'package:syrenity_flutter_client_api/syrenity_flutter_client_api.dart';

sealed class DispatchMessage {
  const DispatchMessage();

  factory DispatchMessage.fromJson(
    WsMsgDispatch dispatch,
    SyrenityClient client,
  ) {
    switch (dispatch.type) {
      case "MessageCreate":
        return DispatchMessageCreate(
          message: SyMessage.build(client, dispatch.originalPayload['message']),
        );

      case "MessageUpdate":
        return DispatchMessageUpdate(
          message: SyMessage.build(client, dispatch.originalPayload['message']),
        );

      case "MessageDelete":
        return DispatchMessageDelete(
          messageId: dispatch.originalPayload['message_id'],
        );

      case "TodoUpdate":
        return DispatchTodoUpdate(
          todo: SyTodoItem.build(client, dispatch.originalPayload['todo']),
        );

      case "TodoCreate":
        return DispatchTodoCreate(
          todo: SyTodoItem.build(client, dispatch.originalPayload['todo']),
        );

      case "TodoDelete":
        return DispatchTodoDelete(id: dispatch.originalPayload['todo_id']);

      case "UserStatusUpdate":
        return DispatchUserStatusUpdate(
          status: SyCustomStatus.build(
            client,
            dispatch.originalPayload['status'],
          ),
        );
      case "ChannelStartTyping":
        return DispatchChannelStartTyping(
          channelId: dispatch.originalPayload['channel_id'],
          userId: dispatch.originalPayload['user_id'],
        );

      case "ChannelOrderUpdate":
        return DispatchChannelOrderUpdate(
          channels: List<int>.from(dispatch.originalPayload['channels']),
        );

      case "ServerMemberAdd":
        return DispatchServerMemberAdd(
          member: SyMember.build(client, dispatch.originalPayload['member']),
        );

      case "ServerMemberRemove":
        return DispatchServerMemberRemove(
          member: SyMember.build(client, dispatch.originalPayload['member']),
        );

      case "ChannelUpdateMessageAck":
        return DispatchChannelUpdateMessageAck(
          channel: SyChannel.build(
            client,
            dispatch.originalPayload['channel'] as Map<String, dynamic>,
          ),
        );
      default:
        throw Exception("Unknown dispatch type: ${dispatch.type}");
    }
  }
}

class DispatchMessageCreate extends DispatchMessage {
  final SyMessage message;

  const DispatchMessageCreate({required this.message});
}

class DispatchMessageUpdate extends DispatchMessage {
  final SyMessage message;

  const DispatchMessageUpdate({required this.message});
}

class DispatchMessageDelete extends DispatchMessage {
  final int messageId;

  const DispatchMessageDelete({required this.messageId});
}

class DispatchTodoUpdate extends DispatchMessage {
  final SyTodoItem todo;

  const DispatchTodoUpdate({required this.todo});
}

class DispatchTodoCreate extends DispatchMessage {
  final SyTodoItem todo;

  const DispatchTodoCreate({required this.todo});
}

class DispatchTodoDelete extends DispatchMessage {
  final int id;

  const DispatchTodoDelete({required this.id});
}

class DispatchUserStatusUpdate extends DispatchMessage {
  final SyCustomStatus status;

  const DispatchUserStatusUpdate({required this.status});
}

class DispatchChannelStartTyping extends DispatchMessage {
  final int channelId;
  final int userId;

  const DispatchChannelStartTyping({
    required this.channelId,
    required this.userId,
  });
}

class DispatchChannelOrderUpdate extends DispatchMessage {
  final List<int> channels;

  const DispatchChannelOrderUpdate({required this.channels});
}

class DispatchServerMemberAdd extends DispatchMessage {
  final SyMember member;

  const DispatchServerMemberAdd({required this.member});
}

class DispatchServerMemberRemove extends DispatchMessage {
  final SyMember member;

  const DispatchServerMemberRemove({required this.member});
}

class DispatchChannelUpdateMessageAck extends DispatchMessage {
  final SyChannel channel;

  const DispatchChannelUpdateMessageAck({required this.channel});
}

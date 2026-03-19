import 'package:syrenity_flutter_client_api/src/client.dart';
import 'package:syrenity_flutter_client_api/src/models/custom_status.dart';
import 'package:syrenity_flutter_client_api/src/models/member.dart';
import 'package:syrenity_flutter_client_api/src/models/message.dart';
import 'package:syrenity_flutter_client_api/src/ws_messages.dart';

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

      case "MessageDelete":
        return DispatchMessageDelete(
          messageId: dispatch.originalPayload['message_id'],
        );

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

      case "ServerMemberAdd":
        return DispatchServerMemberAdd(
          member: SyMember.build(client, dispatch.originalPayload['member']),
        );

      case "ServerMemberRemove":
        return DispatchServerMemberRemove(
          member: SyMember.build(client, dispatch.originalPayload['member']),
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

class DispatchUserStatusUpdate extends DispatchMessage {
  final SyCustomStatus status;

  const DispatchUserStatusUpdate({required this.status});
}

class DispatchMessageDelete extends DispatchMessage {
  final int messageId;

  const DispatchMessageDelete({required this.messageId});
}

class DispatchChannelStartTyping extends DispatchMessage {
  final int channelId;
  final int userId;

  const DispatchChannelStartTyping({
    required this.channelId,
    required this.userId,
  });
}

class DispatchServerMemberAdd extends DispatchMessage {
  final SyMember member;

  const DispatchServerMemberAdd({required this.member});
}

class DispatchServerMemberRemove extends DispatchMessage {
  final SyMember member;

  const DispatchServerMemberRemove({required this.member});
}

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:syrenity_flutter_client_api/src/client.dart';
import 'package:syrenity_flutter_client_api/src/dispatch_messages.dart';
import 'package:syrenity_flutter_client_api/src/events.dart';
import 'package:syrenity_flutter_client_api/src/ws_messages.dart';

class SpecialDispatchChannelUpdateOrder {
  final List<int> channels;
  final int? guildId;

  SpecialDispatchChannelUpdateOrder({
    required this.channels,
    required this.guildId,
  });
}

class SyWebsocketManager {
  final SyrenityClient client;

  SyWebsocketManager(this.client);

  late WebSocket socket;

  final StreamController<String> _messages = StreamController.broadcast();

  Stream<String> get messages => _messages.stream;

  Future<void> connect() async {
    client.debug("Attempting to connect to ${client.websocketUrl}...");
    socket = await WebSocket.connect(client.websocketUrl);
    client.debug("WS Connection established");
    socket.listen(
      (data) {
        _messages.add(data);
        client.debug("Received WS: $data");
        final message = WsMessage.fromJson(jsonDecode(data), client);
        handleMessage(message);
      },
      onDone: () {
        client.debug("WS Disconnect");
        client.events.emit(SyEvents.disconnect, socket.closeReason);
      },
    );
  }

  void handleMessage(WsMessage message) async {
    switch (message) {
      case WsMsgIdentify(token: final _):
        break;
      case WsMsgAuthenticate():
        final payload = WsMsgIdentify(token: client.token!);

        send(jsonEncode(payload.toJson()));
        break;
      case WsMsgError(error: final _):
        break;

      case WsMsgHello(user: final user):
        client.user = user;
        client.events.emit(SyEvents.ready, user);
        break;

      case WsMsgDispatch(
        guildId: final guildId,
        channelId: final _,
        type: final type,
        originalPayload: final _,
        payload: final payload,
      ):
        switch (payload) {
          case DispatchMessageCreate(message: final message):
            client.events.emit(SyEvents.dispatchMessageCreate, message);
            break;

          case DispatchMessageUpdate(message: final message):
            client.events.emit(SyEvents.dispatchMessageUpdate, message);
            break;

          case DispatchMessageDelete(messageId: final messageId):
            client.events.emit(SyEvents.dispatchMessageDelete, messageId);
            break;

          case DispatchTodoUpdate(todo: final todo):
            client.events.emit(SyEvents.dispatchTodoUpdate, todo);
            break;

          case DispatchTodoCreate(todo: final todo):
            client.events.emit(SyEvents.dispatchTodoCreate, todo);
            break;

          case DispatchTodoDelete(id: final id):
            client.events.emit(SyEvents.dispatchTodoDelete, id);
            break;

          case DispatchChannelStartTyping(channelId: _, userId: _):
            client.events.emit(SyEvents.dispatchChannelStartTyping, payload);
            break;

          case DispatchChannelOrderUpdate(channels: final channelOrder):
            client.events.emit(
              SyEvents.dispatchChannelOrderUpdate,
              SpecialDispatchChannelUpdateOrder(
                channels: channelOrder,
                guildId: guildId,
              ),
            );
            break;

          case DispatchChannelCreate(:final channel):
            client.events.emit(SyEvents.dispatchChannelCreate, channel);
            break;

          case DispatchUserStatusUpdate(status: final status):
            client.events.emit(SyEvents.dispatchUserStatusUpdate, status);
            break;

          case DispatchServerMemberAdd(:final member):
            client.events.emit(SyEvents.dispatchServerMemberAdd, member);
            break;

          case DispatchServerMemberRemove(:final member):
            client.events.emit(SyEvents.dispatchServerMemberRemove, member);
            break;

          case DispatchChannelUpdateMessageAck(channel: final channel):
            client.events.emit(SyEvents.channelUpdateMessageAck, channel);
            break;

          // ignore: unreachable_switch_default
          default:
            client.events.emit(
              SyEvents.debug,
              "Dispatch was ignored due to not being implemented: $type",
            );
        }

        break;

      case WsMsgHeartbeat():
        send(jsonEncode(WsMsgHeartbeat()));
        break;
    }
  }

  void send(String message) {
    socket.add(message);
  }

  void dispose() {
    socket.close();
    _messages.close();
  }
}

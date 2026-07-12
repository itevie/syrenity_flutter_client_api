import 'package:syrenity_flutter_client_api/syrenity_flutter_client_api.dart';

class ServerChannelsManager {
  final SyrenityClient client;
  final SyServer server;

  ServerChannelsManager({required this.client, required this.server});

  Future<SyChannel> createChannel(SyChannelType type, String name) async {
    return await client.http.post<SyChannel, Map<String, dynamic>>(
      "/api/servers/${server.id}/channels",
      {'type': type.toServerName(type), 'name': name},
      (client, value) => SyChannel.build(client, value),
    );
  }
}

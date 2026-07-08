import 'package:syrenity_flutter_client_api/syrenity_flutter_client_api.dart';

class SyServer {
  final SyrenityClient client;

  final int id;
  final String name;
  final int ownerId;
  final String? description;
  final String? avatar;

  late final ServerChannelsManager channels = ServerChannelsManager(
    client: client,
    server: this,
  );

  late final ServerInvitesManager invites = ServerInvitesManager(
    client: client,
    server: this,
  );

  late final ServerMembertManager members = ServerMembertManager(
    client: client,
    server: this,
  );

  SyServer(
    this.client, {
    required this.id,
    required this.name,
    required this.ownerId,
    required this.description,
    required this.avatar,
  });

  factory SyServer.build(SyrenityClient client, Map<String, dynamic> json) {
    final server = SyServer(
      client,
      id: json['id'] as int,
      name: json['name'] as String,
      ownerId: json['owner_id'] as int,
      description: json['description'] as String?,
      avatar: json['avatar'] as String?,
    );

    client.events.emit(SyEvents.createServer, server);

    return server;
  }

  Future<SyUser> fetchOwner() async {
    return await client.users.fetch(ownerId);
  }

  Future<List<SyChannel>> fetchChannels() async {
    return await client.channels.fetchChannelsForServer(id);
  }

  Future<List<SyRole>> fetchRoles() async {
    return await client.http.get<List<SyRole>, List<dynamic>>(
      "/api/servers/$id/roles",
      (c, data) {
        return data
            .map((x) => SyRole.build(c, x as Map<String, dynamic>))
            .toList();
      },
    );
  }

  Future<List<SyInvite>> fetchInvites() async {
    return await client.http.get<List<SyInvite>, List<dynamic>>(
      "/api/servers/$id/invites",
      (c, data) {
        return data
            .map((x) => SyInvite.build(c, x as Map<String, dynamic>))
            .toList();
      },
    );
  }

  Future<void> updateChannelOrder(Map<int, int> channelOrder) async {
    await client.http.patch(
      "/api/servers/$id/channels-order",
      channelOrder.map((key, value) => MapEntry(key.toString(), value)),
      null,
    );
  }

  Future<void> leave() async {
    await client.http.delete("/api/users/${client.user.id}/servers/$id", {});
  }
}

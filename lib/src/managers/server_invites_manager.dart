import 'package:syrenity_flutter_client_api/src/client.dart';
import 'package:syrenity_flutter_client_api/src/models/invite.dart';
import 'package:syrenity_flutter_client_api/src/models/server.dart';

class ServerInvitesManager {
  final SyrenityClient client;
  final SyServer server;

  ServerInvitesManager({required this.client, required this.server});

  Future<SyInvite> fetchAll(String content) async {
    return await client.http.get<SyInvite, Map<String, dynamic>>(
      "/api/servers/${server.id}/invites",
      (client, value) => SyInvite.build(client, value),
    );
  }

  Future<SyInvite> create() async {
    return await client.http.post<SyInvite, Map<String, dynamic>>(
      "/api/servers/${server.id}/invites",
      {},
      (client, value) => SyInvite.build(client, value),
    );
  }
}

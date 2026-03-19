import 'package:syrenity_flutter_client_api/src/client.dart';
import 'package:syrenity_flutter_client_api/src/models/invite.dart';

class SyInviteManager {
  final SyrenityClient client;

  SyInviteManager(this.client);

  Future<SyInvite> fetch(String code) async {
    return await client.http.get("/api/invites/$code", SyInvite.build);
  }
}

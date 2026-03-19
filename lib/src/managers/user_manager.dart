import 'package:syrenity_flutter_client_api/src/client.dart';
import 'package:syrenity_flutter_client_api/src/models/user.dart';

class UserManager {
  final SyrenityClient client;

  UserManager(this.client);

  Future<SyUser> fetch(int id) async {
    return await client.http.get<SyUser, Map<String, dynamic>>(
      "/api/users/$id",
      (c, x) => SyUser.build(client, x),
    );
  }
}

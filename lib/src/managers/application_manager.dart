import 'package:syrenity_flutter_client_api/src/models/application.dart';
import 'package:syrenity_flutter_client_api/syrenity_flutter_client_api.dart';

class SyApplicationManager {
  final SyrenityClient client;

  SyApplicationManager(this.client);

  Future<List<SyApplication>> fetchPublic(int serverId) async {
    return await client.http.get<List<SyApplication>, List<dynamic>>(
      "/api/applications/public",
      (c, data) {
        return data
            .map((x) => SyApplication.build(c, x as Map<String, dynamic>))
            .toList();
      },
    );
  }
}

import 'package:syrenity_flutter_client_api/src/client.dart';
import 'package:syrenity_flutter_client_api/src/models/server.dart';

class ServerChannelsManager {
  final SyrenityClient client;
  final SyServer server;

  ServerChannelsManager({required this.client, required this.server});
}

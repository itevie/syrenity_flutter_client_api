import 'package:syrenity_flutter_client_api/src/client.dart';
import 'package:syrenity_flutter_client_api/src/models/user.dart';

class SyApplication {
  final SyrenityClient client;

  final int id;
  final String token;
  final String applicationName;
  final int botAccount;
  final int ownerId;
  final DateTime createdAt;
  final bool isPublic;
  final String? description;

  final SyUser bot;
  final SyUser owner;

  SyApplication(
    this.client, {
    required this.id,
    required this.token,
    required this.applicationName,
    required this.botAccount,
    required this.ownerId,
    required this.createdAt,
    required this.isPublic,
    required this.description,
    required this.bot,
    required this.owner,
  });

  factory SyApplication.build(
    SyrenityClient client,
    Map<String, dynamic> json,
  ) {
    final app = SyApplication(
      client,
      id: json['id'] as int,
      token: json['token'] as String,
      applicationName: json['application_name'] as String,
      botAccount: json['bot_account'] as int,
      ownerId: json['owner_id'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      isPublic: json['public'] as bool,
      description: json['descriptionn'] as String?,
      bot: SyUser.build(client, json['bot'] as Map<String, dynamic>),
      owner: SyUser.build(client, json['owner'] as Map<String, dynamic>),
    );

    return app;
  }

  Future<void> inviteTo(int serverId) async {
    await client.http.post(
      "/applications/$botAccount/servers/$serverId",
      {},
      null,
    );
  }
}

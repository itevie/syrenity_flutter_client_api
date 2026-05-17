import 'package:syrenity_flutter_client_api/src/client.dart';

class SyRole {
  final SyrenityClient client;

  final int id;
  final int guildId;
  final String name;
  final int bitfieldAllow;
  final int bitfieldDeny;
  final bool isEveryone;
  final String? color;
  final int rank;

  SyRole(
    this.client, {
    required this.id,
    required this.guildId,
    required this.name,
    required this.bitfieldAllow,
    required this.bitfieldDeny,
    required this.isEveryone,
    required this.color,
    required this.rank,
  });

  factory SyRole.build(SyrenityClient client, Map<String, dynamic> json) {
    return SyRole(
      client,
      id: json['id'] as int,
      guildId: json['guild_id'] as int,
      name: json['name'] as String,
      bitfieldAllow: json['bitfield_allow'] as int,
      bitfieldDeny: json['bitfield_deny'] as int,
      isEveryone: json['is_everyone'] as bool,
      color: json['color'] as String?,
      rank: json['rank'] as int,
    );
  }
}

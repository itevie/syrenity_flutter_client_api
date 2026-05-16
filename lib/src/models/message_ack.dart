class SyMessageAck {
  final int channelId;
  final int userId;
  final int? messageId;
  final DateTime acknowledgedAt;

  SyMessageAck({
    required this.channelId,
    required this.userId,
    required this.messageId,
    required this.acknowledgedAt,
  });

  factory SyMessageAck.build(Map<String, dynamic> json) {
    final acknowledgedAtRaw = json['acknowledged_at'];
    final acknowledgedAt =
        acknowledgedAtRaw is DateTime
            ? acknowledgedAtRaw
            : DateTime.parse(acknowledgedAtRaw as String);

    return SyMessageAck(
      channelId: json['channel_id'] as int,
      userId: json['user_id'] as int,
      messageId: json['message_id'] as int?,
      acknowledgedAt: acknowledgedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'channel_id': channelId,
      'user_id': userId,
      'message_id': messageId,
      'acknowledged_at': acknowledgedAt.toIso8601String(),
    };
  }
}

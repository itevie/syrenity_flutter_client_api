class SyPermission {
  SyPermission._();

  static const int createMessages = 1 << 0;
  static const int manageMessages = 1 << 1;
  static const int readChannelHistory = 1 << 2;
  static const int manageChannels = 1 << 3;
  static const int createInvites = 1 << 4;
  static const int manageInvites = 1 << 5;
  static const int manageRoles = 1 << 6;
  static const int manageServer = 1 << 7;
  static const int kickMembers = 1 << 8;

  static bool hasPermission(int bitfield, int flag) {
    return (bitfield & flag) != 0;
  }
}

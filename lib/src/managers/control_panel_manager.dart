import 'package:syrenity_flutter_client_api/syrenity_flutter_client_api.dart';

class SyControlPanel {
  SyControlPanelScope? serverScope;
  SyControlPanelScope? userScope;

  SyControlPanel({required this.serverScope, required this.userScope});
}

class SyControlPanelScope {
  List<SyControlPanelTab> tabs;

  SyControlPanelScope({required this.tabs});
}

class SyControlPanelTab {
  String name;
  List<SyControlPanelSetting> settings;

  /// Only applicable when this is the server scope
  int permissions;

  SyControlPanelTab({
    required this.name,
    required this.settings,
    this.permissions = 0,
  });
}

enum SyControlPanelSettingType { bool, string }

class SyControlPanelSetting {
  String name;
  String description;
  String settingId;
  SyControlPanelSettingType type;

  dynamic defaultValue;

  /// Only applicable when this is the server scope
  int permissions;

  SyControlPanelSetting({
    required this.name,
    required this.description,
    required this.settingId,
    required this.type,
    required this.defaultValue,
    this.permissions = 0,
  });
}

class SyControlPanelManager {
  SyrenityClient client;

  SyControlPanelManager(this.client);
}

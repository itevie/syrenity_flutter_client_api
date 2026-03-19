import 'dart:convert';

import 'package:syrenity_flutter_client_api/src/events.dart';
import 'package:syrenity_flutter_client_api/src/http.dart';
import 'package:syrenity_flutter_client_api/src/managers/application_manager.dart';
import 'package:syrenity_flutter_client_api/src/managers/channel_manager.dart';
import 'package:syrenity_flutter_client_api/src/managers/invite_manager.dart';
import 'package:syrenity_flutter_client_api/src/managers/server_manager.dart';
import 'package:syrenity_flutter_client_api/src/managers/user_manager.dart';
import 'package:syrenity_flutter_client_api/src/models/file_base.dart';
import 'package:syrenity_flutter_client_api/src/models/user.dart';
import 'package:syrenity_flutter_client_api/src/socket.dart';

class SyrenityClient {
  final String baseUrl;
  final String websocketUrl;

  late final HttpClient http = HttpClient(this);
  late final UserManager users = UserManager(this);
  late final ChannelManager channels = ChannelManager(this);
  late final ServerManager servers = ServerManager(this);
  late final SyEventEmitter events = SyEventEmitter(this);
  late final SyWebsocketManager ws = SyWebsocketManager(this);
  late final SyInviteManager invites = SyInviteManager(this);
  late final SyApplicationManager applications = SyApplicationManager(this);
  late final SyFileBase fileBase = SyFileBase(
    this,
    badUrl: "$baseUrl/public/logo192.png",
  );

  String? token;
  SyUser? _user;

  SyUser get user {
    if (_user == null) {
      throw "Client user has not been initialised yet";
    }

    return _user!;
  }

  SyUser? get scaryUser {
    return _user;
  }

  set user(SyUser user) {
    _user = user;
  }

  SyrenityClient({required this.baseUrl, required this.websocketUrl});

  void setToken(String token) {
    this.token = token;
  }

  Future<String> fetchSession(String email, String password) async {
    final response = await http.rawPost(
      "/auth/password",
      '{"username":"$email","password":"$password"}',
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode != 200) {
      throw Exception("Login failed");
    }

    final cookie = response.headers['set-cookie'];

    if (cookie == null) {
      throw Exception("No session cookie returned");
    }

    // Extract connect.sid
    final session = cookie.split(';').first;

    return await _getToken(session);
  }

  Future<String> _getToken(String session) async {
    final response = await http.rawPost(
      "/auth/get-token",
      null,
      headers: {"Cookie": session, "Content-Type": "application/json"},
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to get token (${response.statusCode})");
    }

    final json = jsonDecode(response.body);

    return json['token'];
  }

  Future<void> login(String token, {bool noWs = false}) async {
    this.token = token;

    if (noWs) {
      debug("Logging in without ws");
      _user = await getUser();
    } else {
      debug("Logging in with ws");
      await ws.connect();
    }
  }

  Future<bool> checkConnected() async {
    try {
      await http.get("/api/ping", null);
      debug("Check connected success");
      return true;
    } catch (e) {
      debug("Check connected failure");
      return false;
    }
  }

  Future<SyUser> getUser() async {
    return await http.get("/api/users/@me", SyUser.build);
  }

  void debug(String message) {
    events.emit(SyEvents.debug, message);
  }
}

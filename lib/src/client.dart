import 'dart:convert';

import 'package:http/browser_client.dart';
import 'package:http/http.dart';
import 'package:syrenity_flutter_client_api/src/events.dart';
import 'package:syrenity_flutter_client_api/src/http.dart';
import 'package:syrenity_flutter_client_api/src/managers/application_manager.dart';
import 'package:syrenity_flutter_client_api/src/managers/channel_manager.dart';
import 'package:syrenity_flutter_client_api/src/managers/file_manager.dart';
import 'package:syrenity_flutter_client_api/src/managers/invite_manager.dart';
import 'package:syrenity_flutter_client_api/src/managers/server_manager.dart';
import 'package:syrenity_flutter_client_api/src/managers/user_manager.dart';
import 'package:syrenity_flutter_client_api/src/models/file_base.dart';
import 'package:syrenity_flutter_client_api/src/models/user.dart';
import 'package:syrenity_flutter_client_api/src/socket.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class SyrenityClient {
  final String baseUrl;
  final String websocketUrl;
  final bool useProxy;

  late final HttpClient http = HttpClient(this);
  late final UserManager users = UserManager(this);
  late final ChannelManager channels = ChannelManager(this);
  late final ServerManager servers = ServerManager(this);
  late final SyEventEmitter events = SyEventEmitter(this);
  late final SyWebsocketManager ws = SyWebsocketManager(this);
  late final SyInviteManager invites = SyInviteManager(this);
  late final SyApplicationManager applications = SyApplicationManager(this);
  late final SyFileManager files = SyFileManager(this);
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

  SyrenityClient({
    required this.baseUrl,
    required this.websocketUrl,
    this.useProxy = true,
  });

  void setToken(String token) {
    this.token = token;
  }

  Future<String> fetchSession(String email, String password) async {
    String? session;

    if (kIsWeb) {
      final client = BrowserClient()..withCredentials = true;

      final response = await client.post(
        Uri.parse("$baseUrl/auth/password"),
        body: '{"username":"$email","password":"$password"}',
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode != 200) {
        client.close();
        throw Exception("Login failed");
      }

      // Browser stores the cookie automatically
      client.close();
    } else {
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

      session = cookie.split(';').first;
    }

    return await _getToken(session);
  }

  Future<String> _getToken(String? session) async {
    late Response response;

    if (kIsWeb) {
      final client = BrowserClient()..withCredentials = true;

      response = await client.post(
        Uri.parse("$baseUrl/auth/get-token"),
        headers: {"Content-Type": "application/json"},
      );

      client.close();
    } else {
      response = await http.rawPost(
        "/auth/get-token",
        null,
        headers: {"Cookie": session!, "Content-Type": "application/json"},
      );
    }

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

  String makeProxyUrl(String url, {int? size}) {
    if (!useProxy) return url;
    return "$baseUrl/api/proxy?use_fallback&url=${Uri.encodeComponent(url)}${size != null ? "&size=$size" : ""}";
  }
}

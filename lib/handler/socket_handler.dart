import 'dart:convert';

import 'package:chatting/constants.dart';
import 'package:chatting/model/user_message.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

class SocketHandler {

  final String username;
  final int roomId;

  Function? onJoin, onLeave, onMessage;

  late StompClient _client;
  bool _connected = false;

  SocketHandler({required this.username, required this.roomId}) {
    _client = StompClient(config: StompConfig(
      url: "ws://${Constants.apiUrl}/chatting",
      webSocketConnectHeaders: {"username": username},
      onConnect: onConnect,
      onWebSocketError: onError,
    ));
  }

  void connect() {
    if (_connected) {
      disconnect();
    }
    _client.activate();
  }
  
  void disconnect() {
    _client.deactivate();
    _connected = false;
  }
  
  void sendMessage(String content) {
    if (_connected) {
      _client.send(destination: "/app/room.send", body: content);
    }
  }

  void onConnect(StompFrame frame) {
    _client.subscribe(destination: "/user/join", callback: (frame) {
      onJoin!(frame.body);
    });

    _client.subscribe(destination: "/user/leave", callback: (frame) {
      onLeave!(frame.body);
    });

    _client.subscribe(destination: "/user/message", callback: (frame) {
      final _data = json.decode(frame.body!);
      onMessage!(UserMessage(
        id: _data["id"],
        roomId: _data["roomId"],
        sender: _data["sender"]["principal"]["name"],
        date: DateTime.now(),
        content: _data["content"],
      ));
    });

    _client.send(destination: "/app/room.join", body: roomId.toString());
    _connected = true;
  }

  void onError(error) {
    _connected = false;
  }
}
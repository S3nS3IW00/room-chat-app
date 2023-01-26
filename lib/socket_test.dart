import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

final StompClient client = StompClient(
    config: const StompConfig(url: 'ws://danidev.ddns.net/chatting', webSocketConnectHeaders: {"username": "Ash"}, onConnect: onConnected, onWebSocketError: onError));

void main() {
  client.activate();
}

void onConnected(StompFrame frame) {
  print('Connected');

  client.subscribe(destination: "/user/join", callback: (frame) {
    print("Joined: " + frame.body!);
  });

  client.subscribe(destination: "/user/leave", callback: (frame) {
    print("Left: " + frame.body!);
  });

  client.subscribe(destination: "/user/message", callback: (frame) {
    print("Message: " + frame.body!);
  });

  client.send(destination: "/app/room.join", body: "2");
  client.send(destination: "/app/room.send", body: "Hello there!");
}

void onError(error) {
  print(error.toString());
}

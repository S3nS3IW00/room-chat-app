import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chatting/handler/socket_handler.dart';
import 'package:chatting/model/join_message.dart';
import 'package:chatting/model/leave_message.dart';
import 'package:chatting/model/message.dart';
import 'package:equatable/equatable.dart';

part 'socket_event.dart';

class SocketBloc extends Bloc<SocketEvent, List<Message>> {
  final SocketHandler socketHandler;

  SocketBloc(this.socketHandler) : super(const []);

  final List<Message> messages = [];

  @override
  Stream<List<Message>> mapEventToState(
    SocketEvent event,
  ) async* {
    if (event is JoinEvent) {
      messages.add(JoinMessage(event.username));
      yield messages.toList();
    } else if (event is LeaveEvent) {
      messages.add(LeaveMessage(event.username));
      yield messages.toList();
    } else if (event is NewMessageEvent) {
      messages.add(event.message);
      yield messages.toList();
    }
  }
}

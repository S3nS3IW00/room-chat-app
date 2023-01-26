part of 'socket_bloc.dart';

abstract class SocketEvent extends Equatable {
  const SocketEvent();
}

class JoinEvent extends SocketEvent {

  final String username;
  const JoinEvent(this.username);

  @override
  List<Object?> get props => [username];
}

class LeaveEvent extends SocketEvent {

  final String username;
  const LeaveEvent(this.username);

  @override
  List<Object?> get props => [username];
}

class NewMessageEvent extends SocketEvent {

  final Message message;
  const NewMessageEvent(this.message);

  @override
  List<Object> get props => [message];
}